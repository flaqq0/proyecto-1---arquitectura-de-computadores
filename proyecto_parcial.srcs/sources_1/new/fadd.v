`timescale 1ns/1ps
module fadd(op_a, op_b, round_mode, result);
  input round_mode;
  input [31:0] op_a, op_b;
  output reg [31:0] result;
  
  //unpack los bits
  wire s_a, s_b; 
  wire [22:0] m_a, m_b; 
  wire [7:0] e_a, e_b;
  assign s_a = op_a[31]; assign e_a = op_a[30:23]; assign m_a = op_a [22:0];
  assign s_b = op_b[31]; assign e_b = op_b[30:23]; assign m_b = op_b [22:0];
  
  //flags para identificar casos especiales
  wire a_inf = (e_a == 8'hFF) && (m_a == 0);
  wire b_inf = (e_b == 8'hFF) && (m_b == 0);
  wire a_nan = (e_a == 8'hFF) && (m_a != 0);
  wire b_nan = (e_b == 8'hFF) && (m_b != 0);
  wire a_zero = (e_a == 0) && (m_a == 0);
  wire b_zero = (e_b == 0) && (m_b == 0);
  
  reg [31:0] temp;
  reg f_special;
  
  localparam NaN = 32'h7FC00000;
  
  //resultado casos especiales
  always @(*) begin
    f_special = 1;
    if (a_nan || b_nan) temp = NaN;
    else if (a_inf && b_inf) begin 
      if (s_a != s_b) temp = NaN; // inf - inf = NaN
      else temp = s_a ? 32'hFF800000 : 32'h7F800000; //inf + inf = inf 
    end
    else if (a_inf) temp = s_a ? 32'hFF800000 : 32'h7F800000;
    else if (b_inf) temp = s_b ? 32'hFF800000 : 32'h7F800000;
    else if (a_zero && b_zero) temp = 0;
    else if (a_zero) temp = op_b;
    else if (b_zero) temp = op_a;
    else begin
      temp = 0;
      f_special = 0;
    end
  end
  
  
  
  
  // bit implicito de la mantisa
  //si e != 0, el bit implícito es 1; si e == 0, es 0.
  // se le agrega 3 bits de guarda G, R, S
  reg [27:0] f_a, f_b; 
  always @(*) begin
    f_a = (e_a == 0) ? {1'b0, m_a, 3'b000} : {1'b1, m_a, 3'b000};
    f_b = (e_b == 0) ? {1'b0, m_b, 3'b000} : {1'b1, m_b, 3'b000};
  end
  
  
  //alinear exponente y mantisas
  reg [27:0] sh_a, sh_b; //mantisas shifteadas
  reg [7:0] exp; //exponente alineado
  always @(*) begin
    if(e_a > e_b)begin
      exp = e_a;
      if (e_a - e_b < 28) begin //prevenir overflow al shiftear
        sh_b = f_b >> (e_a - e_b); 
        sh_a = f_a;
      end
      else begin sh_b = 0; sh_a = f_a; end //diferencia es muy grande, o sea b es esencialmente cero
    end else begin
      exp = e_b;
      if (e_a - e_b < 28) begin
        sh_a = f_a >> (e_b - e_a); 
        sh_b = f_b;
      end 
      else begin sh_a = 0; sh_b = f_b;end
    end
  end

  
  
  
  reg s_f; //signo final
  reg [28:0] man; //mantiza
  
  always @ (*) begin
    if (s_a == s_b) begin
      man = {1'b0, sh_a} + {1'b0, sh_b};
      s_f = s_a;
    end else begin
      if (sh_a >= sh_b) begin
        man = {1'b0, sh_a} - {1'b0, sh_b};
        s_f = s_a;
      end else begin
        man = {1'b0, sh_b} - {1'b0, sh_a};
        s_f = s_b;
      end
    end
  end


    /*
    if (sh_a == sh_b) begin //a + b
      man = {1'b0, sh_a} + {1'b0, sh_b};
      s_f = s_a;
    end else begin //a + (-b)
      if(sh_a >= sh_b) begin  // si |a| > = |b| se queda con el signo de a
        man = {1'b0, sh_a} - {1'b0, sh_b};
        s_f = s_a;
      end else begin // si |b| > = |a|
        man = {1'b0, sh_b} - {1'b0, sh_a};
        s_f = s_b;
      end
    end
  end
  */
  
  
  //redondeo (round to nearest even)
  reg [27:0] n_m; //mantiza normalizada
  reg [7:0] n_e; // exponente normalizado
  reg [4:0] s_c; //contador shift, max 27 
 
  //normalización 1
  always @(*) begin
    n_m = man[27:0];
    n_e = exp;

    if (man[28]) begin //overflow, se shiftea a la derecha y se incrementa 1 al exponente
      n_m = man[28:1];
      n_e = exp + 1;
    end else begin
      while (n_m[27] == 0 && n_e > 0) begin
        n_m = n_m << 1;
        n_e = n_e - 1;
      end
    end
  end

 
  //redondeo
  reg [27:0] r_m; //mantisa redondeada
  reg [7:0] f_e; //exponente final
  reg g, r, s;
  
  always @(*) begin
    g = n_m[2];
    r = n_m[1];
    s = |n_m[0];
    
    r_m = n_m[27:3]; //mantiza sin grs
    f_e = n_e;
    
    
    if(round_mode) begin
      // g = 1 y r o s = 1 -> redondeo hacia arriba
      // 2. g = 1 y r=s=0 y  r_m[0]= 1 -> redondeo hacia arriba (numero par)
      if((g && (r || s)) || (g && !r && !s && r_m[0])) begin
        r_m = r_m + 1;
        if (r_m[24]) begin
          r_m = r_m >> 1;
          f_e = f_e + 1;
        end
      end
    end
  end
  
  
  always @(*) begin
    if (f_special) result = temp;
    else result = {s_f, f_e, r_m[22:0]};
  end
endmodule

      
/*
IEEE punto flotante
	[31][30:23][22:0] -> signo (s) - exponente (e) - mantisa (m)
    - 32 bits bias: 127
    - 16 bits bias: 15
    casos:
    	1. 0<e<255 : result = (−1)^S × 1.F × 2^(E − bias) [normal]
        2. e = 0 y m !=0 : result = (−1)^S × 0.F × 2^(1 − bias) [denormal]
        3. e = 0 y m =0 : result = 0
        4. e = 255 y m=0 : result = inf
        5. e = 255 y m!=0 : NaN
        
     input [31:0] op_a, op_b;
  input [3:0] op_code; //ADD 00, SUB 01, MUL 10, DIV 10
  input mode_fp; // = half (16 bits), 1 = single (32 bits)
  input clk, rst, round_mode, start;
  output reg [31:0] result;
  output reg valid_out;
  output wire [3:0] ALUFlags
  
  wire neg, zero, carry, overflow;
  
  assign neg = result[31]; //resultado negativo o no
  assign zero = (result == 32'b0); //si resultado es 0
*/ 