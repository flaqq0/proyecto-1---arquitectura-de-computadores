`timescale 1ns/1ps
module fdiv(op_a, op_b, round_mode, result);
  input round_mode;
  input [31:0] op_a, op_b;
  output reg [31:0] result;

  // unpack los bits
  wire s_a, s_b;
  wire [22:0] m_a, m_b;
  wire [7:0] e_a, e_b;
  assign s_a = op_a[31]; assign e_a = op_a[30:23]; assign m_a = op_a [22:0];
  assign s_b = op_b[31]; assign e_b = op_b[30:23]; assign m_b = op_b [22:0];

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
    else if (b_zero) temp = 32'h7F800000; // num / 0 = NaN
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
        // ahora n_m tiene la forma [26:0]
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

  // rounding: tomar G,R,S = n_m[2], n_m[1], n_m[0]
  reg [24:0] r_m; // 25 bits para detectar carry en +1
  reg gbit, rbit, sbit;
  reg [7:0] f_e;
  always @(*) begin
    gbit = n_m[2];
    rbit = n_m[1];
    sbit = n_m[0]; // ya es bit único por nuestra construcción
    // r_m[23:0] serán los 24 bits (1 + 23 fraction) desplazados, r_m[24] es bit extra
    r_m = {1'b0, n_m[26:3]}; // extraemos mantisa (bits 26..3) -> 24 bits, dejar msb extra en [24]
    f_e = n_e;
    if (round_mode) begin
      // round to nearest even
      if ((gbit && (rbit || sbit)) || (gbit && !rbit && !sbit && r_m[0])) begin
        r_m = r_m + 1;
        if (r_m[24]) begin
          // carry produjo 1.xxx overflow -> shift right y ajustar exponent
          r_m = r_m >> 1;
          f_e = f_e + 1;
        end
      end
    end
  end

  // packing final y manejo post-checks
  always @(*) begin
    if (f_special) begin
      // casos especiales ya resueltos (prioritarios)
      if (a_nan || b_nan) result = NaN;
      else if (a_inf && b_inf) result = NaN;
      else if (a_inf) result = {s_a ^ s_b, 8'hFF, 23'b0};
      else if (b_inf) result = {s_a ^ s_b, 8'h00, 23'b0};
      else if (a_zero && b_zero) result = NaN;
      else if (a_zero) result = {s_a ^ s_b, 8'h00, 23'b0};
      else if (b_zero) result = {s_a ^ s_b, 8'hFF, 23'b0}; // div by zero -> inf
      else result = temp;
    end else begin
      // overflow exponent -> inf
      if (f_e >= 8'hFF) result = {s_a ^ s_b, 8'hFF, 23'b0};
      else result = {s_a ^ s_b, f_e, r_m[22:0]};
    end
  end

endmodule
