module fp16_32(
  input [15:0] in16,
  output reg [31:0] out32
);
  wire sign;
  wire [4:0] exp16;
  wire [9:0] frac16;
  reg [7:0] exp32;
  reg [22:0] frac32;

  assign sign = in16[15];
  assign exp16 = in16[14:10];
  assign frac16 = in16[9:0];

  always @(*) begin
    if (exp16 == 0) begin
      // Subnormal or zero
      if (frac16 == 0)
        {exp32, frac32} = {8'b0, 23'b0};
      else begin
        exp32 = 8'd127 - 15 + 1;
        frac32 = {frac16, 13'b0};
      end
    end else if (exp16 == 5'b11111) begin
      // Inf or NaN
      exp32 = 8'hFF;
      frac32 = {frac16, 13'b0};
    end else begin
      exp32 = exp16 + (127 - 15);
      frac32 = {frac16, 13'b0};
    end
    out32 = {sign, exp32, frac32};
  end
endmodule
