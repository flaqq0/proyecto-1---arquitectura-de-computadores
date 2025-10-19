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
        clk = 1; rst = 1;start = 0;round_mode = 0;mode_fp = 0; op_a = 32'h00000000; op_b = 32'h00000000; op_code = 2'b00;#10 
        rst = 0;

        // 32 bits

        // add ---------------------------------
        /*
        //5555.55 + 2000.2 = 75555.75 (0x479391e0) -> 7555.7495 0x45ec1dff
        start = 1; op_code = 2'b00;
        op_a = 32'h45ad9c66; op_b = 32'h44fa0666; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // +0 + -0 = +0 (0x00000000) check
        start = 1; op_code = 2'b00;
        op_a = 32'h00000000; op_b = 32'h80000000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // +Inf + (-Inf) = NaN (0x7FC00000) check
        start = 1; op_code = 3'b000;
        op_a = 32'h7F800000; op_b = 32'hFF800000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // NaN + 5.0 = NaN (0x7FC00000) check
        start = 1; op_code = 2'b00;
        op_a = 32'h7FC00000; op_b = 32'h40A00000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // 2.2e-44 (denormal) + 1 (normal) = ~1 (0x3F800000) check
        start = 1; op_code = 2'b00;
        op_a = 32'h00000010; op_b = 32'h3F800000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // conmutatividad (a+b == b+a) -> -292.24353 (0xc3921f2c)+ 515.4794 (0x4400deae) = 223.23587 (0x435f3c62)
        start = 1; op_code = 2'b00;
        op_a = 32'hc3921f2c; op_b = 32'h4400deae; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        op_a = 32'h4400deae; op_b = 32'hc3921f2c; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // sub ---------------------------------
        //783.57 - 285.17 = 498.4 (0x43f93333) check
        start = 1; op_code = 2'b01;
        op_a = 32'h4443e47b; op_b = 32'h438e95c3; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
       
        // Inf - Inf = NaN (0x7FC00000)
        start = 1; op_code = 3'b001;
        op_a = 32'h7F800000; op_b = 32'h7F800000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
         
         // 0.000000000000000000000000000000000000000000011 - 0.000000000000000000000000000000000000000000006 
        // denormal- denormal = 5e-45 (0x00000004)
        start = 1; op_code = 3'b001;
        op_a = 32'h00000008; op_b = 32'h00000004; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // 340282350000000000000000000000000000000 - -340282350000000000000000000000000000000 = 6.805647e+38 (0x7f800000)
        start = 1; op_code = 3'b001;
        op_a = 32'h7F7FFFFF; op_b = 32'hFF7FFFFF; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
      
        // mul ---------------------------------
        
        //432.5381 (0x43d844e0) * -744.2421 (0xc43a0f7f)= -321913.063874 (0xc89d2f22) 
        start = 1; op_code = 2'b10; 
        op_a = 32'h43d844e0; op_b = 32'hc43a0f7f; #20
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // +Inf * 0 = 0 
        start = 1; op_code = 3'b010;
        op_a = 32'h7F800000; op_b = 32'h00000000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // (-Inf) * (-1) = +Inf
        start = 1; op_code = 3'b010;
        op_a = 32'hFF800000; op_b = 32'hBF800000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // 4.5e-44 (denormal) * 2 = 9e-44(0x00000040) -> 0x00000000 PARA ESTE NO ME FUNIONA AHHHHHHH
        start = 1; op_code = 3'b010;
        op_a = 32'h00000020; op_b = 32'h40000000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // conmutatividad (a*b == b*a) -> 515.4794 (0x4400deae) * -723.0139 (0xc434c0e4) = 372698.771364 (0xc8b5fb58)
        start = 1; op_code = 3'b010;
        op_a = 32'h4400deae; op_b = 32'hc434c0e4; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        op_a = 32'hc434c0e4; op_b = 32'h4400deae; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // div ---------------------------------
        
        // -53.166138 (0xc254aa20) / 695.80005 (0x442df334) = -0.07641008074 (0xbd9c7ce3) check
        start = 1; op_code = 2'b11;
        op_a = 32'hc254aa20; op_b = 32'h442df334; #20
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // 1 / 0  = NaN (0x7FC00000) check
        start = 1; op_code = 2'b11; // 1 / 0
        op_a = 32'h3F800000; op_b = 32'h00000000; #20
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // 1.5845633e29 / Inf = NaN (0x7FC00000)
        start = 1; op_code = 3'b011;
        op_a = 32'h70000000; op_b = 32'h7F800000; #10
        
        // 1e-45 / 3.4028235e38 = NaN
        start = 1; op_code = 3'b011;
        op_a = 32'h00000001; op_b = 32'h7f7fffff; #10
        
        // 0.00002 (0x37a7c5ac) / 5.381e-42 (0x00000f00) = 3.7167813e+36 (0x7c32f4de) ESTE TMPC FUNCIONA POR DENORMAL
        start = 1; op_code = 3'b011;
        op_a = 32'h37a7c5ac; op_b = 32'h00000f00; #10
        
        //16 bits

        mode_fp = 0; 

        // add ---------------------------------
        
        // 0.5 (0x3800) + 2.25 (0x4080) ≈ 2.75 (0x00004180) check
        start = 1; op_code = 2'b00;
        op_a = 32'h00003800; op_b = 32'h00004080; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // +INf (0x7C00) + 1.0 (0x3C00) = +Inf
        start = 1; op_code = 2'b00;
        op_a = 32'h00007C00; op_b = 32'h00003C00; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        // -inf (0xFC00) + 1.0 (0x3C00) = -inf
        start = 1; op_code = 2'b00;
        op_a = 32'h0000FC00; op_b = 32'h00003C00; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        //+inf (0x7C00) + -Inf (0xFC00) = NaN (0x7E00)
        start = 1; op_code = 2'b00;
        op_a = 32'h00007C00; op_b = 32'h0000FC00; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        //NaN (0x7E00) + -2.0 (0x4000) = NaN
        start = 1; op_code = 2'b00;
        op_a = 32'h00007E00; op_b = 32'h0000c000; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        // 0.00006(0x0001) + 1.0 (0x3C00)= 1.00006 (0x3C00)
        start = 1; op_code = 2'b00;
        op_a = 32'h00000001; op_b = 32'h00003C00; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        //sub 
        
        // 0.00000017881393 (0x0003) - 0.00000011920929(0x0002) = 0 -> 0x0001
        start = 1; op_code = 2'b01;
        op_a = 32'h00000003; op_b = 32'h00000002; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        //0.0029182434  (0x19fa) - -Inf (0xFC00) = +inf (0x7c00)
        start = 1; op_code = 2'b01;                   
        op_a = 32'h000019fa; op_b = 32'h0000FC00; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        // 466.75 (0x5f4b)  -  -466.75 (0xdf4b) = 933.5 (0x634b)
        start = 1; op_code = 2'b01;
        op_a = 32'h00005f4b; op_b = 32'h0000df4b; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        // mul
       
        // 1.75 * 2 = 3.5 (0x00004300) CHECK
        start = 1; op_code = 2'b10;
        op_a = 32'h00003f00; op_b = 32'h00004000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        //1e-5 (0x04C4) * 1e-5 (0x04C4) ≈ 1e-10 (underflow → 0x0000)
        start = 1; op_code = 2'b10;
        op_a = 32'h000004C4; op_b = 32'h000004C4; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        //inf* 2.0 = inf
        start = 1; op_code = 2'b10;
        op_a = 32'h00007C00; op_b = 32'h00004000; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        //0.0 (0x0000) * inf (0x7C00) = NaN (0x7E00)
        start = 1; op_code = 2'b10;
        op_a = 32'h00000000; op_b = 32'h00007C00; #20;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        
        // div 
        
        
        //6 / 2 = 3 (0x00004200) check
        start = 1; op_code = 2'b11;
        op_a = 32'h00004600; op_b = 32'h00004000; #10
        op_a = 32'h00000000; op_b = 32'h00000000; #10
        
        //1.0 / 0.0 = +Inf (0x7C00)
        start = 1; op_code = 2'b11;
        op_a = 32'h00003C00; op_b = 32'h00000000; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        */
        //0.5 (0x3800) / 5.96e-8 (0x0004) = inf overflow
        start = 1; op_code = 2'b11;
        op_a = 32'h00003800; op_b = 32'h00000004; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
        /*
         //0.0 (0x0000) / inf (0x7C00) = NaN (0x7E00)
        start = 1; op_code = 2'b11;
        op_a = 32'h00000000; op_b = 32'h00007C00; #10;
        op_a = 32'h00000000; op_b = 32'h00000000; #10;
*/
        $finish;
    end

endmodule
