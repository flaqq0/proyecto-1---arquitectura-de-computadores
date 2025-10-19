`timescale 1ns/1ps
module fdiv(op_a, op_b, round_mode, mode_fp, result, flags);
  input round_mode, mode_fp;
  input [31:0] op_a, op_b;
  output reg [31:0] result;
  output reg [4:0] flags;
  
  wire [31:0] op_a_conv, op_b_conv;
  wire [31:0] conv_a_out, conv_b_out;

  fp16_32 conv_a(.in16(op_a[15:0]), .out32(conv_a_out));
  fp16_32 conv_b(.in16(op_b[15:0]), .out32(conv_b_out));

  // Si mode_fp = 1 usar FP32 directamente, si no: convertir desde FP16
  assign op_a_conv = mode_fp ? op_a : conv_a_out;
  assign op_b_conv = mode_fp ? op_b : conv_b_out;
  
  // unpack los 32b en signo, exponente y mantisa
  wire s_a, s_b; 
  wire [22:0] m_a, m_b; 
  wire [7:0] e_a, e_b;
  assign s_a = op_a_conv[31]; 
  assign e_a = op_a_conv[30:23]; 
  assign m_a = op_a_conv[22:0];
  assign s_b = op_b_conv[31]; 
  assign e_b = op_b_conv[30:23]; 
  assign m_b = op_b_conv[22:0];
  
  // flags casos especiales NaN, infinito y cero
  wire a_inf = (e_a == 8'hFF) && (m_a == 0);
  wire b_inf = (e_b == 8'hFF) && (m_b == 0);
  wire a_nan = (e_a == 8'hFF) && (m_a != 0);
  wire b_nan = (e_b == 8'hFF) && (m_b != 0);
  wire a_zero = (e_a == 0) && (m_a == 0);
  wire b_zero = (e_b == 0) && (m_b == 0);

  reg [31:0] temp;
  reg f_special;// flag casos especiales
  reg [4:0] e16;
  reg [9:0] m16;
  integer extra_shift;
  
  localparam NaN = 32'h7FC00000;

  // Manejo de casos especiales NaN, Inf, 0
  always @(*) begin
    f_special = 1;
    if (a_nan || b_nan) temp = NaN;
    else if (a_inf && b_inf) temp = NaN;
    else if (a_inf) temp = s_a ? 32'hFF800000 : 32'h7F800000;
    else if (b_inf) temp = s_a ^ s_b ? 32'h80000000 : 32'h00000000; // resultado 0
    else if (a_zero && b_zero) temp = NaN;
    else if (a_zero) temp = s_a ^ s_b ? 32'h80000000 : 32'h00000000;
    else if (b_zero) temp = s_a ^ s_b ? 32'hFF800000 : 32'h7F800000; // +-Inf
    else begin
      temp = 0;
      f_special = 0; // no es caso especial
    end

    // Si esta en modo FP16, convertir resultado especial a FP16
    if (f_special && mode_fp == 1'b0) begin
      case (temp[30:23])
        8'hFF: begin
          if (temp[22:0] == 0)
            temp = {16'b0, {temp[31], 5'b11111, 10'b0}}; // inf
          else
            temp = {16'b0, {temp[31], 5'b11111, 10'b1000000000}}; // NaN
        end
        8'h00: begin
          temp = {16'b0, {temp[31], 15'b0}}; // 0
        end
        default: begin
          e16 = (temp[30:23] > 8'd112) ? (temp[30:23] - 8'd112) : 5'd0;
          m16 = temp[22:13];
          temp = {16'b0, {temp[31], e16, m16}};
        end
      endcase
    end
  end

  // bit implicito de la mantisa(23 +1 bits)
  reg [23:0] f_a, f_b;
  always @(*) begin
    f_a = (e_a == 0) ? {1'b0, m_a} : {1'b1, m_a};
    f_b = (e_b == 0) ? {1'b0, m_b} : {1'b1, m_b};
  end

  // División principal y normalización de resultado
  reg [7:0] n_e; // nuevo exponente normalizado
  reg [26:0] n_m; // nueva mantisa normalizado
  reg signed [10:0] exp_unbiased; //exponente unbiased
  reg [50:0] n; // numerador (se shiftea 26, suficiente espacio para grs y normalizar correctamente)
  reg [47:0] c; // cociente + grs
  integer i; // iterador
  reg found; // flag
  reg [4:0] lz; // left shift
  reg [5:0] shift; // contador de shifts hasta 26
  
  always @(*) begin
    n = {f_a, 26'b0}; // desplazamiento para aumentar precisión
    if (f_b == 0) c = 48'b0;
    else c = n / f_b; // división entera de mantisas (f_a/f_b) * 2^26

    //cálculo del exponente real sin sesgo (ea - eb) + bias
    exp_unbiased = (e_a == 0 ? (1 - 127) : (e_a - 127)) - (e_b == 0 ? (1 - 127) : (e_b - 127)) + 127;

    // 1: resultado muy pequeño: denormal o cero
    if (exp_unbiased < 1) begin
      n_e = 8'd0;
      if (exp_unbiased < -26)
        n_m = 0; // demasiado pequeño: 0
      else
        n_m = c[25:0] >> (1 - exp_unbiased); // denormaliza
    end

    // 2: resultado normal
    else if (c[26]) begin //si c[26] es uno, se mantiene, sino se shiftea hasta que c[26] sea 1
      n_m = c[26:0];
      n_e = exp_unbiased;
    end else begin
      found = 1'b0;
      lz = 0;

      // contar ceros a la izquierda en el cociente
      for (i = 0; i < 26; i = i + 1) begin
        if (!found && c[25 - i]) begin
          found = 1'b1;
          lz = i[4:0];
        end
      end

      if (found) begin
        shift = lz + 1; // para mover el 1 a la posición 26 se necesita desplazar lz + 1
        if (exp_unbiased > shift) begin
          n_m = (c[25:0] << shift);
          n_e = exp_unbiased - shift;
        end else begin
          // underflow: número denormal
          extra_shift = shift - exp_unbiased;
          if (extra_shift < 27) n_m = (c[25:0] >> extra_shift);
          else n_m = 0;
          n_e = 8'd0; // denormal si exponente se hace 0
        end
      end else begin // en caso no encontrar 1 se vuelve denormal (exponente llega a 0)
        n_m = 0;
        n_e = 8'd0;
      end
    end
  end

  // round to nearest even
  reg [24:0] r_m; // 25 bits para detectar carry en +1
  reg g, r, s;
  reg [7:0] f_e;
  always @(*) begin
    g = n_m[2]; //guard bit
    r = n_m[1]; //round bit
    s = n_m[0]; //sticky bit
    r_m = {1'b0, n_m[26:3]};
    f_e = n_e;

    if (round_mode) begin
      // Si se requiere redondear hacia arriba
      if ((g && (r || s)) || (g && !r && !s && r_m[0])) begin
        r_m = r_m + 1;
        // Si hay overflow en mantisa, ajustar exponente
        if (r_m[24]) begin
          r_m = r_m >> 1;
          f_e = f_e + 1;
        end
      end
    end
  end

  // Conversión del resultado final FP32 a FP16
  wire [15:0] result16;
  fp32_16 conv_res(.in32({s_a ^ s_b, f_e, r_m[22:0]}), .out16(result16));
  
  // Ensamblado del resultado final y configuración de flags
  always @(*) begin
    flags = 5'b0;
    result = 32'b0;

    if (f_special) begin
      // casos especiales NaN, inf, div/0
      result = temp;
      if (a_nan || b_nan || (a_inf && b_inf)) flags[4] = 1'b1; // invalid
      else if (b_zero && !a_zero) flags[1] = 1'b1; // div_zero
      else if (a_inf || b_inf) flags[3] = 1'b1; // overflow
    end else begin
      // resultado normal
      result = mode_fp ? {s_a ^ s_b, f_e, r_m[22:0]} : {16'b0, result16};

      if (f_e >= 8'hFF) begin
        flags[3] = 1'b1; // overflow
        result = {s_a ^ s_b, 8'hFF, 23'b0};
      end

      if (f_e == 8'h00 && r_m[22:0] != 0) flags[2] = 1'b1; // underflow
      if (g || r || s) flags[0] = 1'b1; // inexact
    end
  end

endmodule
