`timescale 1ns / 1ps
module falu(
    input clk,
    input rst,
    input start,
    input [31:0] op_a,
    input [31:0] op_b,
    input [2:0] op_code,      // 00=add, 01=sub, 10=mul, 11=div
    input mode_fp,            // 0=half, 1=single
    input round_mode,         // 0=nearest (por ahora único implementado)
    output reg [31:0] result,
    output reg valid_out,
    output reg [4:0] flags    // {invalid, overflow, underflow, div_zero, inexact}
);

    wire [31:0] add_res, sub_res, mul_res, div_res;
    wire add_valid, sub_valid, mul_valid, div_valid;

    // calculos
    fadd m_add(.op_a(op_a),.op_b(op_b),.mode_fp(mode_fp),.round_mode(round_mode),.result(add_res),.valid_out(add_valid));
    fsub m_sub(.op_a(op_a),.op_b(op_b),.mode_fp(mode_fp),.round_mode(round_mode),.result(sub_res),.valid_out(sub_valid));
    fmul m_mul(.op_a(op_a),.op_b(op_b),.mode_fp(mode_fp),.round_mode(round_mode),.result(mul_res),.valid_out(mul_valid));
    fdiv m_div(.op_a(op_a),.op_b(op_b),.mode_fp(mode_fp),.round_mode(round_mode),.result(div_res),.valid_out(div_valid));

    reg [31:0] res;
    reg valid;

    always @(*) begin
        case (op_code)
            2'b00: begin res = add_res; valid = add_valid; end // add
            2'b01: begin res = sub_res; valid = sub_valid; end // sub
            2'b10: begin res = mul_res; valid = mul_valid; end // mul
            2'b11: begin res = div_res; valid = div_valid; end // div
            default: begin res = 32'b0; valid = 1'b0; end
        endcase
    end

    // flagssssss
    wire sign_res = res[31];
    wire is_zero  = (res[30:0] == 0);
    wire is_inf   = (res[30:23] == 8'hFF && res[22:0] == 0);
    wire is_nan   = (res[30:23] == 8'hFF && res[22:0] != 0);
    wire is_subnormal = (res[30:23] == 8'h00 && res[22:0] != 0);

    always @(*) begin
        flags = 5'b00000; // {invalid, overflow, underflow, div_zero, inexact}

        if (is_nan) flags[4] = 1'b1; // invalid
        if (is_inf) flags[3] = 1'b1; // overflow (o div_zero)
        if (is_subnormal) flags[2] = 1'b1; // underflow
        if (op_code == 3'b11 && op_b[30:0] == 0) flags[1] = 1'b1; // div_zero
        if (!is_nan && !is_inf && !is_zero) flags[0] = 1'b1; // inexact
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 32'b0;
            valid_out <= 1'b0;
            flags <= 5'b0;
        end else if (start) begin
            result <= res;
            valid_out <= valid;
        end
    end

endmodule
