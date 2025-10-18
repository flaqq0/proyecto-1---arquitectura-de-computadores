`timescale 1ns / 1ps
module fp32_16(input [31:0] in32, output reg [15:0] out16);
    wire sign;
    wire [7:0] exp32;
    wire [22:0] frac32;

    assign sign  = in32[31];
    assign exp32 = in32[30:23];
    assign frac32 = in32[22:0];

    reg [4:0] exp16;
    reg [9:0] frac16;
    integer exp_unbias;

    always @(*) begin
        if (exp32 == 8'b0 && frac32 == 0)
            out16 = {sign, 15'b0}; // ±0
        else if (exp32 == 8'hFF) begin
            // Inf o NaN
            if (frac32 == 0)
                out16 = {sign, 5'b11111, 10'b0}; // Inf
            else
                out16 = {sign, 5'b11111, 10'b1}; // NaN
        end else begin
            exp_unbias = exp32 - 127 + 15;

            if (exp_unbias >= 31)
                out16 = {sign, 5'b11111, 10'b0}; // Overflow → Inf
            else if (exp_unbias <= 0)
                out16 = {sign, 15'b0}; // Underflow → 0
            else begin
                exp16 = exp_unbias[4:0];
                frac16 = frac32[22:13]; // truncar mantisa (23→10)
                out16 = {sign, exp16, frac16};
            end
        end
    end
endmodule
