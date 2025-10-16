`timescale 1ns/1ps
module tb_fsub();
  reg [31:0] a, b;
  reg round_mode;
  wire [31:0] result;

  fsub m2 (.op_a(a),.op_b(b),.round_mode(round_mode),.result(result));

  initial begin
    round_mode = 1;

    // 5.5 (0x40B00000) - 2.25 (0x40200000) = 3.25 (0x40500000)
    a = 32'h40B00000; b = 32'h40200000; #10

    // 2.25 (0x40200000) - 5.5 (0x40B00000) = -3.25 (0xC0500000)
    a = 32'h40200000; b = 32'h40B00000;#10

    // 1.5 (0x3FC00000) - 1.5 (0x3FC00000) = 0 (0x00000000)
    a = 32'h3FC00000; b = 32'h3FC00000; #10

    // (-3.75) (0xC0700000) - (-2.5) (0xC0200000) = (-1.25) (0xBFA00000)
    a = 32'hC0700000; b = 32'hC0200000;#10

    $finish;
  end
endmodule
