`timescale 1ns / 1ps
module tb_falu();
    reg clk, rst, start;
    reg [31:0] op_a, op_b;
    reg [2:0] op_code;
    reg mode_fp;
    reg round_mode;
    wire [31:0] result;
    wire valid_out;
    wire [4:0] flags;

    falu aluuu (.clk(clk),.rst(rst),.start(start),.op_a(op_a),.op_b(op_b),.op_code(op_code),.mode_fp(mode_fp),
        .round_mode(round_mode),.result(result),.valid_out(valid_out),.flags(flags));

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;start = 0;round_mode = 0;mode_fp = 1;#10 
        rst = 0;

        // 32 bits

        // add 5.5 + 2 = 7.5 (0x40f00000)
        start = 1; op_code = 3'b000;
        op_a = 32'h40B00000; op_b = 32'h40000000; #10

        // sub  5.5 - 2 = 3.5
        start = 1; op_code = 3'b001;
        op_a = 32'h40B00000; op_b = 32'h40000000; #10

        /*
        // mul 2.5 * 4 = 10
        start = 1; op_code = 3'b010; 
        op_a = 32'h40200000; op_b = 32'h40800000; #10 */

        // div 10 / 4 = 2.5
        start = 1; op_code = 3'b011; 
        op_a = 32'h41200000; op_b = 32'h40800000; #10

        // div en  zero
        start = 1; op_code = 3'b011; // 1 / 0
        op_a = 32'h3F800000; op_b = 32'h00000000; #10

        // nan
        start = 1; op_code = 3'b000;
        op_a = 32'h7FC00000; op_b = 32'h3F800000; #10

        //16 buts

        mode_fp = 0; 

        // add 1.5 + 2.5 = 4.0 → 0x4400 
        start = 1; op_code = 3'b000;
        op_a = 32'h00003E00; op_b = 32'h00004000; #10

        // sub 2.5 - 1.5 = 1.0
        start = 1; op_code = 3'b001;
        op_a = 32'h00004000; op_b = 32'h00003E00; #10
        
        /*
        // mul 1.5 * 2 = 3
        start = 1; op_code = 3'b010;
        op_a = 32'h00003E00; op_b = 32'h00004000; #10*/

        // div 6 / 2 = 3
        start = 1; op_code = 3'b011;
        op_a = 32'h000040C0; op_b = 32'h00004000; #10

        $finish;
    end

endmodule
