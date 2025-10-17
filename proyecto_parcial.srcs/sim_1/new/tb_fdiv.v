`timescale 1ns/1ps
module tb_fdiv();
  reg round_mode;
  reg [31:0] a, b;
  wire [31:0] r;

  fdiv m4(.op_a(a),.op_b(b),.round_mode(round_mode),.result(r));

  initial begin
    round_mode = 1;

    // 5 / 2 = 2.75 (0x40300000)
    a = 32'h40B00000; b = 32'h40000000; #10

    // 2.25 / 5.5 = ~0.40909 (0xc0b00000)
    a = 32'h40200000; b = 32'h40B00000; #10

    // 1.5 / 1.5 = 1 (0x3f800000)
    a = 32'h3FC00000; b = 32'h3FC00000; #10

    // 1 / 0 = nan
    a = 32'h3F800000;b = 32'h00000000;#10

    $finish;
  end
endmodule
