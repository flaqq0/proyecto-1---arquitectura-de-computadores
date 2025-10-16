`timescale 1ns/1ps
module fsub(op_a, op_b, round_mode, result);
  input [31:0] op_a, op_b;
  input round_mode;
  output [31:0] result;

  wire [31:0] b_neg; // invierte el bit de signo
  assign b_neg = {~op_b[31], op_b[30:0]};

  fadd negg(.op_a(op_a),.op_b(b_neg),.round_mode(round_mode),.result(result));
endmodule