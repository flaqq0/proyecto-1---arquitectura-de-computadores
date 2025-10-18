`timescale 1ns/1ps
module fdiv(op_a, op_b, round_mode, mode_fp, result,flags);
  input round_mode, mode_fp;
  input [31:0] op_a, op_b;
  output reg [31:0] result;
  output reg [4:0] flags;
  
  wire [31:0] op_a_conv, op_b_conv;
  wire [31:0] conv_a_out, conv_b_out;

  fp16_32 conv_a(.in16(op_a[15:0]), .out32(conv_a_out));
  fp16_32 conv_b(.in16(op_b[15:0]), .out32(conv_b_out));

  assign op_a_conv = mode_fp ? op_a : conv_a_out;
  assign op_b_conv = mode_fp ? op_b : conv_b_out;
  
  //unpack los 32 bits
  wire s_a, s_b; 
  wire [22:0] m_a, m_b; 
  wire [7:0] e_a, e_b;
  assign s_a = op_a_conv[31]; assign e_a = op_a_conv[30:23]; assign m_a = op_a_conv[22:0];
  assign s_b = op_b_conv[31]; assign e_b = op_b_conv[30:23]; assign m_b = op_b_conv[22:0];
  
  // flags casos especiales
  wire a_inf = (e_a == 8'hFF) && (m_a == 0);
  wire b_inf = (e_b == 8'hFF) && (m_b == 0);
  wire a_nan = (e_a == 8'hFF) && (m_a != 0);
  wire b_nan = (e_b == 8'hFF) && (m_b != 0);
  wire a_zero = (e_a == 0) && (m_a == 0);
  wire b_zero = (e_b == 0) && (m_b == 0);

  reg [31:0] temp;
  reg f_special; // flag casos especiales
  localparam NaN = 32'h7FC00000;

  // resultado casos especiales
  always @(*) begin
    f_special = 1'b1;
    if (a_nan || b_nan) temp = NaN;
    else if (a_inf && b_inf) temp = NaN; // inf/inf = NaN
    else if (a_inf) temp = {s_a ^ s_b, 8'hFF, 23'b0}; // inf / finite = inf
    else if (b_inf) temp = {s_a ^ s_b, 8'h00, 23'b0}; // finite / inf = 0
    else if (b_zero) temp = NaN; // num / 0 = NaN
    else if (a_zero) temp = {s_a ^ s_b, 8'h00, 23'b0}; // 0 / num = 0
    else begin
      temp = 32'h0;
      f_special = 1'b0;
    end
  end

  // bit implicito de la mantisa(23 +1 bits)
  reg [23:0] f_a, f_b;
  always @(*) begin
    f_a = (e_a == 0) ? {1'b0, m_a} : {1'b1, m_a};
    f_b = (e_b == 0) ? {1'b0, m_b} : {1'b1, m_b};
  end

  reg [7:0] n_e;  // exponente normalizado
  reg [26:0] n_m; //mantiza normalizada
  reg [8:0] exp; //exponenete unbiased
  reg [50:0] n; //numerador (se shiftea 26, suficiente espacio para grs y normalizar correctamente)
  reg [47:0] c; // cociente + grs
  integer i; //iterador
  reg found; // flag
  reg [4:0] lz; //left shift
  reg [5:0] shift; // contador de shifts hasta 26 

  always @(*) begin
    n = {f_a, 26'b0}; // f_a << 26
    if (f_b == 0) c = 48'b0;
    else c = n / f_b; // la idea es(f_a/f_b) * 2^26

    //(ea - eb) + bias
    exp = (e_a == 0 ? 8'd1 - 8'd127 : e_a - 8'd127) - (e_b == 0 ? 8'd1 - 8'd127 : e_b - 8'd127) + 8'd127;

    // normalización 1 
    if (c[26]) begin //si c[26] es uno, se mantiene, sino se shiftea hasta que c[26] sea 1
      n_m = c[26:0];
      n_e = exp;
    end else begin
      found = 1'b0;
      lz = 5'd0;
      for (i = 0; i < 26; i = i + 1) begin
        if (!found && c[25 - i]) begin
          found = 1'b1;
          lz = i[4:0];
        end
      end

      if (found) begin
        shift = lz + 1; // para mover el 1 a la posición 26 se necesita desplazar lz + 1
        n_m = (c[25:0] << shift);
        if (exp > shift)
          n_e = exp - shift;
        else
          n_e = 8'd0; // denormal si exponente se hace 0
      end else begin // en caso no encontrar 1 se vuelve denormal (exponente llega a 0)
        n_m = 27'b0;
        n_e = 8'd0;
      end
    end
  end

  // redondeo
  reg [24:0] r_m; // 25 bits para detectar carry en +1
  reg g, r, s;
  reg [7:0] f_e;
  always @(*) begin
    g = n_m[2];
    r = n_m[1];
    s = n_m[0]; 
    
    r_m = {1'b0, n_m[26:3]};
    f_e = n_e;
    if (round_mode) begin
      if ((g && (r || s)) || (g && !r && !s && r_m[0])) begin
        r_m = r_m + 1;
        if (r_m[24]) begin
          r_m = r_m >> 1;
          f_e = f_e + 1;
        end
      end
    end
  end
  
  wire [15:0] result16;
  fp32_16 conv_res(.in32({s_a ^ s_b, f_e, r_m[22:0]}), .out16(result16));
  
  
  always @(*) begin
    flags = 5'b0;
    result = 32'b0;
    if (f_special) begin
      result = temp;
      if (a_nan || b_nan || (a_inf && b_inf)) flags[4] = 1'b1; // invalid
      else if (b_zero && !a_zero) flags[1] = 1'b1; // div_zero
      else if (a_inf || b_inf) flags[3] = 1'b1; // overflow o inf result
    end else begin
      result = mode_fp ? {s_a ^ s_b, f_e, r_m[22:0]} : {16'b0, result16};
      if (f_e >= 8'hFF) begin flags[3] = 1'b1; result = {s_a ^ s_b, 8'hFF, 23'b0}; end // overflow
      if (f_e == 8'h00 && r_m[22:0] != 0) flags[2] = 1'b1; // underflow
      if (g || r || s) flags[0] = 1'b1; // inexact
    end
  end

endmodule
