`timescale 1ns/1ns
module fmul(op_a, op_b, mode_fp, round_mode, re);
  input [31:0] op_a, op_b;
  input mode_fp, round_mode;
  // mode_fp: 	 0 = 16 half	& 1 = 32 single
  // round_mode: 0 = truncate	& 1 = round to nearest even
  output reg [31:0] re;
  
  // variables de SINGLE PRECISION
  wire s_a_32, s_b_32;
  wire [7:0] e_a_32, e_b_32;
  wire [22:0] m_a_32, m_b_32;

  assign s_a_32 = op_a[31];
  assign e_a_32 = op_a[30:23];
  assign m_a_32 = op_a[22:0];
  assign s_b_32 = op_b[31];
  assign e_b_32 = op_b[30:23];
  assign m_b_32 = op_b[22:0];
  
  // variables de HALF PRECISION
  wire s_a_16, s_b_16;
  wire [4:0] e_a_16, e_b_16;
  wire [9:0] m_a_16, m_b_16;

  assign s_a_16 = op_a[15];
  assign e_a_16 = op_a[14:10];
  assign m_a_16 = op_a[9:0];
  assign s_b_16 = op_b[15];
  assign e_b_16 = op_b[14:10];
  assign m_b_16 = op_b[9:0];
  
  // constantes IEEE-754
  localparam BIAS_32 = 127;
  localparam BIAS_16 = 15;
  localparam NAN_32  = 32'h7FC00000;
  localparam INF_32P = 32'h7F800000;
  localparam INF_32N = 32'hFF800000;

  localparam NAN_16  = 16'h7E00;
  localparam INF_16P = 16'h7C00;
  localparam INF_16N = 16'hFC00;
  
  // señales
  reg sign;
  reg [47:0] mant_mult;
  reg [9:0] mant_16;
  reg [22:0] mant_32;
  reg [8:0] exp_16;
  reg [9:0] exp_32;
  
  reg [31:0] out_32;
  reg [15:0] out_16;
  reg spcase;
  
  reg [23:0] mantA_32, mantB_32;
  reg [11:0] mantA_16, mantB_16;
  reg [23:0] mantProd_16;
  
  
  always @(*) begin
    spcase = 0;
    if(mode_fp) begin
      // - SINGLE -
      sign = s_a_32 ^ s_b_32;
      
      // casos especiales
      if((e_a_32==8'hFF && m_a_32!=0) || (e_b_32==8'hFF && m_b_32!=0)) begin
        out_32 = NAN_32;
        spcase = 1;
      end else if((e_a_32==8'hFF && m_a_32==0) || (e_b_32==8'hFF && m_b_32==0)) begin
        out_32 = sign ? INF_32N : INF_32P;
        spcase = 1;
      end else if((e_a_32==0 && m_a_32==0)||(e_b_32==0 && m_b_32==0)) begin
        out_32 = {sign, 31'b0};
        spcase = 1;
      end else begin
        // multiplicación normal
        mantA_32 = (e_a_32 == 0) ? {1'b0, m_a_32} : {1'b1, m_a_32};
        mantB_32 = (e_b_32 == 0) ? {1'b0, m_b_32} : {1'b1, m_b_32};
        mant_mult = mantA_32 * mantB_32;
        exp_32 = e_a_32 + e_b_32 - BIAS_32;
        
        // normalización
        if (mant_mult[47]) begin
          mant_mult = mant_mult >> 1;
          exp_32 = exp_32 + 1;
        end
        
        // redondeo
        mant_32 = mant_mult[45:23];
        if (round_mode && mant_mult[22]) mant_32 = mant_32 + 1'b1;        
        out_32 = {sign, exp_32[7:0], mant_32};
      end
      re = out_32;
    end else begin
      
      // - HALF -
      sign = s_a_16 ^ s_b_16;
      if((e_a_16==5'h1F && m_a_16!=0) || (e_b_16==5'h1F && m_b_16!=0)) begin
        out_16 = NAN_16;
        spcase = 1;
      end else if((e_a_16==5'h1F && m_a_16==0) || (e_b_16==5'h1F && m_b_16==0)) begin
        out_16 = sign ? INF_16N : INF_16P;
        spcase = 1;
      end else if((e_a_16==0 && m_a_16==0)||(e_b_16==0 && m_b_16==0)) begin
        out_16 = {sign, 15'b0};
        spcase = 1;
      end else begin
        mantA_16 = (e_a_16 == 0) ? {1'b0, m_a_16} : {1'b1, m_a_16};
        mantB_16 = (e_b_16 == 0) ? {1'b0, m_b_16} : {1'b1, m_b_16};
        mantProd_16 = mantA_16 * mantB_16;
        exp_16 = e_a_16 + e_b_16 - BIAS_16;
        
        if (mantProd_16[23]) begin
          mantProd_16 = mantProd_16 >> 1;
          exp_16 = exp_16 + 1;
        end

        mant_16 = mantProd_16[21:11];
        if (round_mode && mantProd_16[10]) mant_16 = mant_16 + 1'b1;
        out_16 = {sign, exp_16[4:0], mant_16[9:0]};
      end
      // guardar en 16 bits menos significativos
      re = {16'b0, out_16};
    end
  end

endmodule