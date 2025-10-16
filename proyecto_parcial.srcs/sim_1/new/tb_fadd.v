`timescale 1ns/1ps
module tb_fadd();

  reg [31:0] a, b;
  reg round_mode;
  wire [31:0] result;

  fadd m1(.op_a(a),.op_b(b),.round_mode(round_mode),.result(result));

  initial begin
    // 0 + 0 = 0
    a = 32'h00000000; b = 32'h00000000; round_mode = 0; #10

    // 0.5 (0x3f000000) + 2.25 (0x40100000) = 2.75 (0x40300000)
    a = 32'h3f000000; b = 32'h40100000;round_mode = 0; #10

    // 1.5 + (-1.5) = 0
    a = 32'h3FC00000; b = 32'hBFC00000; round_mode = 1; #10

    // +inf + +inf = +inf
    a = 32'h7F800000; b = 32'h7F800000; round_mode = 1; #10

    // +inf + -inf = NaN
    a = 32'h7F800000; b = 32'hFF800000; round_mode = 1; #10
    
     //2.25 (0x40100000) + 2.25 (0x40100000) = 4.5 (0x40900000)
    a = 32'h40100000; b = 32'h40100000; round_mode = 1; #10
    
    //4.5 (0x40900000) + 0.249999 (0xh3E7FFFFF) 
    a = 32'h40900000; b = 32'h3E7FFFFF;
     round_mode = 1; #10 //4.75
     round_mode = 0; #10 //4.7499995

    $finish;
  end
endmodule