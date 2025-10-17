`timescale 1ns/1ns
module tb();
  reg [31:0] op_a, op_b;
  reg mode_fp, round_mode;
  wire [31:0] result;

  fmul uut (.op_a(op_a), .op_b(op_b), .mode_fp(mode_fp), .round_mode(round_mode), .re(result));

  initial begin
    $dumpfile("fmul.vcd");
    $dumpvars(0, tb);

    // prueba
    mode_fp = 1; // single
    round_mode = 0;
    op_a = 32'h3f800000; // 1
    op_b = 32'h40000000; // 2
    #10;
    op_a = 32'h40400000; // 3
    op_b = 32'h40800000; // 4
    #10;
    op_a = 32'h40400000; // 3
    op_b = 32'h40800000; // 4

    $finish;
  end
endmodule
