`timescale 1ns/1ps
module tb_fsub();
  reg [31:0] a, b;
  reg round_mode;
  wire [31:0] result;

  fsub m2 (.op_a(a),.op_b(b),.round_mode(round_mode),.result(result));

  initial begin
    round_mode = 0;

    //  16384(0x46800000) - 512 (0x44000000) = 15,872 (0x46780000)
    a = 32'h46800000; b = 32'h44000000; #10

    // -0.000118255615 (0xb8f80000) - 1 (0x3f800000) = -1.0001183 (0xbf8003e0)
    a = 32'hb8f80000; b = 32'h3f800000; #10
    
    // 2.75 (0x40300000) - -1.5 (0xbfc00000) = -1.25 (0x40880000)
    a = 32'h40300000; b = 32'hbfc00000;#10

    // (-3.75) (0xC0700000) - (-2.5) (0xC0200000) = (-1.25) (0xBFA00000)
    a = 32'hC0700000; b = 32'hC0200000; #10

    $finish;
  end
endmodule
