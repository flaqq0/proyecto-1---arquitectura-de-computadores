`timescale 1ns / 1ps
module tb_falu();
    reg clk, rst, start;
    reg [31:0] op_a, op_b;
    reg [1:0] op_code;
    reg mode_fp;
    reg round_mode;
    wire [31:0] result;
    wire valid_out;
    wire [4:0] flags;

    falu aluuu (.clk(clk),.rst(rst),.start(start),.op_a(op_a),.op_b(op_b),.op_code(op_code),.mode_fp(mode_fp),
        .round_mode(round_mode),.result(result),.valid_out(valid_out),.flags(flags));

    always #5 clk = ~clk;

    initial begin
        clk = 1; rst = 1;start = 0;round_mode = 0;mode_fp = 1; op_a = 32'h00000000; op_b = 32'h00000000; op_code = 2'b00;#10 
        rst = 0;

        // 32 bits

        // add 
/*
        //5555.55 + 2000.2 = 75555.75 (0x479391e0) -> 7555.7495 0x45ec1dff
        start = 1; op_code = 2'b00;
        op_a = 32'h45ad9c66; op_b = 32'h44fa0666; #10
        // +0 + -0 = +0 (0x00000000) check
        start = 1; op_code = 2'b00;
        op_a = 32'h00000000; op_b = 32'h80000000; #10
        // +Inf + (-Inf) = NaN (0x7FC00000) check
        start = 1; op_code = 3'b000;
        op_a = 32'h7F800000; op_b = 32'hFF800000; #10
        // NaN + 5.0 = NaN (0x7FC00000) check
        start = 1; op_code = 2'b00;
        op_a = 32'h7FC00000; op_b = 32'h40A00000; #10
        // 2.2e-44 (denormal) + 1 (normal) = ~1 (0x3F800000) check
        start = 1; op_code = 2'b00;
        op_a = 32'h00000010; op_b = 32'h3F800000; #10
*/
        // conmutatividad (a+b == b+a) -> 5 + 10 = 15 (0x41700000)
        start = 1; op_code = 2'b00;
        op_a = 32'h40A00000; op_b = 32'h41200000; #20 // 5 + 10 check
        start = 0; #10
        
        start = 1; op_code = 2'b00;
        op_a = 32'h41200000; op_b = 32'h40A00000; #20 // 10 + 5 chck
        start = 0; #10
        
        // sub  
        //783.57 - 285.17 = 498.4 (0x43f93333) check
        start = 1; op_code = 2'b01;
        op_a = 32'h4443e47b; op_b = 32'h438e95c3; #20
        start = 0; #10
      
        // mul 2.5 * 4 = 10 (0x41200000) CHECK
        start = 1; op_code = 2'b10; 
        op_a = 32'h40200000; op_b = 32'h40800000; #20
        start = 0; #10

        // div 10 / 4 = 2.5 (0x40200000) check
        start = 1; op_code = 2'b11; 
        op_a = 32'h41200000; op_b = 32'h40800000; #20
        start = 0; #10

        // div en  zero 1 (3f800000) check
        start = 1; op_code = 2'b11; // 1 / 0
        op_a = 32'h3F800000; op_b = 32'h00000000; #20
        start = 0; #10


        //16 buts

        mode_fp = 0; 

        // add 0.5 (0x3800) + 2.25 (0x4100) ≈ 2.75 (0x00004180) check
        start = 1; op_code = 2'b00;
        op_a = 32'h00003800; op_b = 32'h00004080; #20
        start = 0; #10

        // sub 3.75 - 2.5 = 1.25 (0x000003d00) CHECK
        start = 1; op_code = 2'b01;
        op_a = 32'h00004380; op_b = 32'h00004100; #20;
        start = 0; #10
        
       
        // mul 1.75 * 2 = 3.5 (0x00004300) CHECK
        start = 1; op_code = 2'b10;
        op_a = 32'h00003f00; op_b = 32'h00004000; #20
        start = 0; #10

        // div 6 / 2 = 3 (0x00004200) check
        start = 1; op_code = 2'b11;
        op_a = 32'h00004600; op_b = 32'h00004000; #20
        start = 0; #10

        $finish;
    end

endmodule
