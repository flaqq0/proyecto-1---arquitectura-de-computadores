`timescale 1ns / 1ps
module fmul(op_a, op_b, round_mode, mode_fp, result, flags);
  input [31:0] op_a, op_b;
  input round_mode, mode_fp;
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

  //flags para identificar casos especiales
  wire a_inf = (e_a == 8'hFF) && (m_a == 0);
  wire b_inf = (e_b == 8'hFF) && (m_b == 0);
  wire a_nan = (e_a == 8'hFF) && (m_a != 0);
  wire b_nan = (e_b == 8'hFF) && (m_b != 0);
  wire a_zero = (e_a == 0) && (m_a == 0);
  wire b_zero = (e_b == 0) && (m_b == 0);

  reg [31:0] temp;
  reg f_special; //flag casos especiales
  reg [4:0] e16;
  reg [9:0] m16;
  
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
    else if (a_zero) temp = op_b_conv;
    else if (b_zero) temp = op_a_conv;
    else begin
      temp = 0;
      f_special = 0;
    end
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

  // bit implicito de la mantisa
  reg [23:0] f_a, f_b;
  always @(*) begin
    f_a = (e_a == 0) ? {1'b0, m_a} : {1'b1, m_a};
    f_b = (e_b == 0) ? {1'b0, m_b} : {1'b1, m_b};
  end

  // multiplicacion y normalizacion
  reg [47:0] prod;// 24 x 24 -> 48 bits
  reg signed [10:0] exp_sum; // enough bits for sum and adjustments
  reg [7:0] n_e;
  reg [26:0] n_m; // 27 bits: 24 mantissa + grs
  reg sticky;
  integer i;

  always @(*) begin
    prod = f_a * f_b; 

    // exponente (unbiased ea + eb  luego + bias 127)
    exp_sum = (e_a == 8'd0 ? (1 - 127) : (e_a - 127)) + (e_b == 8'd0 ? (1 - 127) : (e_b - 127)) + 127;

    n_m = 27'b0;
    n_e = 8'd0;
    sticky = 1'b0;

    if (prod == 48'b0) begin
      n_m = 27'b0;
      n_e = 8'd0;
    end else begin
      //  caso 1: prod[47] = 1  ent producto entre [2.0, 4.0) -> se toma de 47 al 21 (27 bits)  y el sticky es dle 20 al 0, exponente mas 1
      //  caso 2: prod[47] = 0 ent producto entre [1.0, 2.0) -> se toma del 46 al 20 (27 bits) y el sticky es del 19 al 0

      if (prod[47]) begin
        n_m = {prod[47], prod[46:21]}; 
        sticky = |prod[20:0];
        if (exp_sum + 1 > 255) n_e = 8'hFF; //overflow
        else if (exp_sum + 1 < 0) n_e = 8'h00; //underflow
        else n_e = exp_sum + 1;
      end else begin
        n_m = {prod[46], prod[45:20]};
        sticky = |prod[19:0];
        if (exp_sum > 255) n_e = 8'hFF;
        else if (exp_sum < 0) n_e = 8'h00;
        else n_e = exp_sum;
      end
    end
  end

  // redondeo
  reg g, r, s;
  reg [24:0] r_m;
  reg [7:0] f_e;

  always @(*) begin
    g = n_m[2];
    r = n_m[1];
    s = n_m[0] | sticky;
    r_m = 25'b0;
    f_e = n_e;

    r_m = {1'b0, n_m[26:3]}; //sin grs

    if (round_mode) begin
      if ((g && (r || s)) || (g && !r && !s && r_m[0])) begin
        r_m = r_m + 1;
        if (r_m[24]) begin
          r_m = r_m >> 1;
          if (f_e != 8'hFF) f_e = f_e + 1;
        end
      end
    end
  end

  wire [15:0] result16;
  wire s_f;
  assign s_f = s_a ^ s_b;
  fp32_16 conv_res(.in32({s_f, f_e, r_m[22:0]}), .out16(result16));

  always @(*) begin
    flags = 5'b0;
    result = 32'b0;

    if (f_special) begin
      result = temp;
      if (a_nan || b_nan || ((a_inf && b_zero) || (b_inf && a_zero))) flags[4] = 1'b1; // invalid
      else if ((a_inf || b_inf)) flags[3] = 1'b1; // overflow -> inf
    end else begin
      result = mode_fp ? {s_f, f_e, r_m[22:0]} : {16'b0, result16};

      if (f_e >= 8'hFF) begin // overflow
        flags[3] = 1'b1;
        result = {s_f, 8'hFF, 23'b0};
      end

      if (f_e == 8'h00 && r_m[22:0] != 0) flags[2] = 1'b1; //underflow
      if (g || r || s) flags[0] = 1'b1; //inexact

    end
  end

endmodule