`timescale 1ns/1ps
module fsub(op_a, op_b, round_mode, mode_fp, result, valid_out);
  input [31:0] op_a, op_b;
  input round_mode, mode_fp;
  output [31:0] result;
  output valid_out;

  wire [31:0] op_a_conv, op_b_conv;
  wire [31:0] conv_a_out, conv_b_out;

  fp16_32 conv_a(.in16(op_a[15:0]), .out32(conv_a_out));
  fp16_32 conv_b(.in16(op_b[15:0]), .out32(conv_b_out));

  assign op_a_conv = mode_fp ? op_a : conv_a_out;
  assign op_b_conv = mode_fp ? op_b : conv_b_out;

  wire [31:0] b_neg;
  assign b_neg = {~op_b_conv[31], op_b_conv[30:0]};

  fadd negg(.op_a(op_a_conv), .op_b(b_neg),
            .round_mode(round_mode), .mode_fp(1'b1),
            .result(result),.valid_out(valid_out));
endmodule
