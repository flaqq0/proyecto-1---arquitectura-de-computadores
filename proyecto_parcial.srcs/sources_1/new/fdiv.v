`timescale 1ns/1ns
module fdiv(op_a, op_b, round_mode, result);
  input round_mode;
  input [31:0] op_a, op_b;
  output reg [31:0] result;

  // unpack
  wire s_a = op_a[31];
  wire s_b = op_b[31];
  wire [22:0] m_a = op_a[22:0];
  wire [22:0] m_b = op_b[22:0];
  wire [7:0] e_a = op_a[30:23];
  wire [7:0] e_b = op_b[30:23];

  // special flags
  wire a_inf = (e_a == 8'hFF) && (m_a == 0);
  wire b_inf = (e_b == 8'hFF) && (m_b == 0);
  wire a_nan = (e_a == 8'hFF) && (m_a != 0);
  wire b_nan = (e_b == 8'hFF) && (m_b != 0);
  wire a_zero = (e_a == 0) && (m_a == 0);
  wire b_zero = (e_b == 0) && (m_b == 0);

  reg [31:0] temp;
  reg f_special;
  localparam NaN = 32'h7FC00000;

  // handle special cases for division
  always @(*) begin
    f_special = 1'b1;
    if (a_nan || b_nan) temp = NaN;
    else if (a_inf && b_inf) temp = NaN; // inf/inf -> NaN
    else if (a_inf) temp = {s_a ^ s_b, 8'hFF, 23'b0}; // inf / finite = inf
    else if (b_inf) temp = {s_a ^ s_b, 8'h00, 23'b0}; // finite / inf = 0
    else if (a_zero && b_zero) temp = NaN; // 0/0 -> NaN
    else if (a_zero) temp = {s_a ^ s_b, 8'h00, 23'b0}; // 0 / finite = 0
    else if (b_zero) temp = NaN; // finite / 0 = inf -> represent as NaN? better to set inf
      // We'll return inf (with sign) for divide by zero
    else begin
      temp = 32'h0;
      f_special = 1'b0;
    end
  end

  // implicit mantissas (24 bits)
  reg [23:0] ma24, mb24;
  always @(*) begin
    ma24 = (e_a == 0) ? {1'b0, m_a} : {1'b1, m_a};
    mb24 = (e_b == 0) ? {1'b0, m_b} : {1'b1, m_b};
  end

  // division: compute quotient with extra precision to obtain GRS bits
  // numerator = ma24 << 27 (51 bits), divide by mb24 -> quotient about 27 bits
  reg [50:0] numerator;
  reg [50:0] quotient; // will hold up to 51 bits result of division (we only need low bits)
  reg [8:0] exp_unbiased;
  reg [7:0] n_e;
  reg [26:0] n_m; // normalized mantissa with 3 GRS bits (27 bits)
  reg [47:0] tmpq;
  integer i;
  always @(*) begin
    numerator = {ma24, 27'b0}; // shift left 27
    if (mb24 == 0) tmpq = 48'b0; else tmpq = numerator / mb24; // quotient fits in ~27 bits
    // tmpq is at most 27 bits but stored in 48
    // compute exponent: (e_a - bias) - (e_b - bias) + bias = e_a - e_b + bias
    exp_unbiased = (e_a == 0 ? 8'd1 - 8'd127 : e_a - 8'd127) - (e_b == 0 ? 8'd1 - 8'd127 : e_b - 8'd127) + 8'd127;
    // tmpq bits: if leading bit at position 26 (i.e., tmpq[26]==1) then normalized; else need shift left & decrement exponent
    if (tmpq[26]) begin
      // normalized; take bits [26:0] (27 bits)
      n_m = tmpq[26:0];
      n_e = exp_unbiased;
    end else begin
      // shift left until bit 26 becomes 1 or exponent reaches 0.
      // We can compute lz by scanning tmpq from MSB 26 downwards up to 26 positions.
      // For simplicity, shift left once and decrement exponent accordingly until normalized.
      // But here we implement a simple LZD scan (fixed loops) to be synthesizable.
      n_m = tmpq[26:0];
      n_e = exp_unbiased;
      // find first 1
      reg found;
      reg [4:0] lz;
      found = 1'b0;
      lz = 5'd0;
      for (i = 0; i < 27; i = i + 1) begin
        if (!found && tmpq[26 - i]) begin
          found = 1'b1;
          lz = i[4:0];
        end
      end
      if (found) begin
        if (n_e > lz) begin
          n_m = tmpq[26:0] << lz;
          n_e = n_e - lz;
        end else begin
          // denormal
          n_m = tmpq[26:0] << n_e;
          n_e = 8'd0;
        end
      end
    end
  end

  // rounding: G,R,S from n_m[2],n_m[1],n_m[0]
  reg [24:0] r_m;
  reg gbit, rbit, sbit;
  reg [7:0] f_e;
  always @(*) begin
    gbit = n_m[2];
    rbit = n_m[1];
    // sbit = OR of lower bits (n_m[0] already single bit)
    sbit = n_m[0];
    r_m = {1'b0, n_m[26:3]}; // r_m[23:0], r_m[24]=0 placeholder
    f_e = n_e;
    if (round_mode) begin
      if ((gbit && (rbit || sbit)) || (gbit && !rbit && !sbit && r_m[0])) begin
        r_m = r_m + 1;
        if (r_m[24]) begin
          r_m = r_m >> 1;
          f_e = f_e + 1;
        end
      end
    end
  end

  // final packing and special handling for divide-by-zero
  always @(*) begin
    if (f_special) begin
      // prioritized special cases
      if (a_nan || b_nan) result = NaN;
      else if (a_inf && b_inf) result = NaN;
      else if (a_inf) result = {s_a ^ s_b, 8'hFF, 23'b0};
      else if (b_inf) result = {s_a ^ s_b, 8'h00, 23'b0};
      else if (a_zero && b_zero) result = NaN;
      else if (a_zero) result = {s_a ^ s_b, 8'h00, 23'b0};
      else if (b_zero) result = {s_a ^ s_b, 8'hFF, 23'b0}; // divide by 0 -> inf
      else result = temp;
    end else begin
      if (f_e >= 8'hFF) result = {s_a ^ s_b, 8'hFF, 23'b0};
      else result = {s_a ^ s_b, f_e, r_m[22:0]};
    end
  end

endmodule
