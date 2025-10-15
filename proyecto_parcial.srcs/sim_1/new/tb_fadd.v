`timescale 1ns/1ps
module tb_fadd();

  reg [31:0] a, b;
  reg round_mode;
  wire [31:0] result;

  fadd m1(.op_a(a),.op_b(b),.round_mode(round_mode),.result(result));

  initial begin
    // 0 + 0 = 0
    a = 32'h00000000; b = 32'h00000000; round_mode = 0; #10

    // 1.5 (0x3FC00000) + 2.25 (0x40200000) = 3.75 (0x40700000)
    a = 32'h3FC00000; b = 32'h40200000; round_mode = 1; #10

    // 1.5 + (-1.5) = 0
    a = 32'h3FC00000; b = 32'hBFC00000; round_mode = 1; #10

    // +inf + +inf = +inf
    a = 32'h7F800000; b = 32'h7F800000; round_mode = 1; #10

    // +inf + -inf = NaN
    a = 32'h7F800000; b = 32'hFF800000; round_mode = 1; #10

    // 5.25 (40A80000) + 0.25 (3E800000)= 5.5 (40B00000)
    // truncado -> 5.0 (40A00000)
    // redondeado al par -> 6.0 (40C00000)
    a = 32'h40A80000; b = 32'h3E800000;
    round_mode = 0; #10
    round_mode = 1; #10
    
     //2.25 (0x40100000) + 2.25 (0x40100000) = 4.5 (0x40900000)
    a = 32'h40100000; b = 32'h40100000; round_mode = 1; #10
    
    // 4.25 (0x40880000) + 0.249999 (0xh3E7FFFFF) = 4.499999 (0x408FFFFE)
    a = 32'h40880000; b = 32'h3E7FFFFF;
    round_mode = 0; #10
    round_mode = 1; #10

    $finish;
  end
endmodule
