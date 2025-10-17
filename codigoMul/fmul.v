`timescale 1ns/1ns
module fmul(op_a, op_b, mode_fp, round_mode, re, flags);
  input  [31:0] op_a, op_b;
  input         mode_fp;     // 0 = half, 1 = single
  input         round_mode;  // 0 = truncate, 1 = round-to-nearest-even
  output reg [31:0] re;
  output reg [4:0]  flags;   // {overflow, underflow, invalid, inexact, denormal}

  // constants
  localparam integer BIAS_32 = 127;
  localparam integer BIAS_16 = 15;
  localparam [31:0] NAN_32  = 32'h7FC00000;
  localparam [31:0] INF_32P = 32'h7F800000;
  localparam [31:0] INF_32N = 32'hFF800000;
  localparam [15:0] NAN_16  = 16'h7E00;
  localparam [15:0] INF_16P = 16'h7C00;
  localparam [15:0] INF_16N = 16'hFC00;

  // temporaries for single path
  reg s_a32, s_b32;
  reg [7:0] e_a32, e_b32;
  reg [22:0] m_a32, m_b32;

  // temporaries for half path (packed in 32-bit input)
  reg s_a16, s_b16;
  reg [4:0] e_a16, e_b16;
  reg [9:0] m_a16, m_b16;

  // generics
  reg [23:0] mantA_24, mantB_24;   
  reg [47:0] mant_prod48;
  reg signed [16:0] exp_un_a, exp_un_b, exp_un_sum;
  reg [7:0] biased32;
  reg [22:0] frac32;
  reg g32, r32, sticky32;
  reg inexact_local;

  // half temporaries
  reg [10:0] mantA_11, mantB_11; 
  reg [47:0] prod48_half;        
  reg signed [16:0] biased16_signed, biased32_signed;
  reg [4:0] biased16;
  reg [9:0] frac16;
  reg g16, r16, sticky16;

  integer kk, shift_right, sr, sl;
  reg [23:0] mAext, mBext;
  reg [47:0] temp, t, tmp;
  reg sticky, sticky_local;

  // extract fields each time
  always @(*) begin
    // default outputs
    re = 32'b0;
    flags = 5'b0;
    inexact_local = 1'b0;

    // --- extract single fields ---
    s_a32 = op_a[31];
    e_a32 = op_a[30:23];
    m_a32 = op_a[22:0];
    s_b32 = op_b[31];
    e_b32 = op_b[30:23];
    m_b32 = op_b[22:0];

    // --- extract half fields (packed in low 16 bits of inputs) ---
    s_a16 = op_a[15];
    e_a16 = op_a[14:10];
    m_a16 = op_a[9:0];
    s_b16 = op_b[15];
    e_b16 = op_b[14:10];
    m_b16 = op_b[9:0];

    if (mode_fp) begin
      // ---------------------------
      // SINGLE PRECISION PATH (32)
      // ---------------------------

      // quick special case detection
      if ((e_a32 == 8'hFF && m_a32 != 0) || (e_b32 == 8'hFF && m_b32 != 0)) begin
        // any NaN -> canonical qNaN
        re = NAN_32;
        flags[2] = 1'b1; // invalid (presence of NaN)
      end else if (((e_a32 == 8'hFF) && (m_a32 == 0) && (e_b32 == 0) && (m_b32 == 0)) ||
                   ((e_b32 == 8'hFF) && (m_b32 == 0) && (e_a32 == 0) && (m_a32 == 0))) begin
        // Inf * 0 => invalid -> NaN
        re = NAN_32;
        flags[2] = 1'b1;
      end else if ((e_a32 == 8'hFF) && (m_a32 == 0)) begin
        // Inf * finite -> Inf with sign
        re = s_a32 ^ s_b32 ? INF_32N : INF_32P;
        flags[4] = 1'b1; // overflow
      end else if ((e_b32 == 8'hFF) && (m_b32 == 0)) begin
        re = s_a32 ^ s_b32 ? INF_32N : INF_32P;
        flags[4] = 1'b1;
      end else if ((e_a32 == 0) && (m_a32 == 0)) begin
        // zero * anything -> signed zero
        re = {s_a32 ^ s_b32, 31'b0};
        flags[0] = 1'b1; // denormal/zero indicator
      end else if ((e_b32 == 0) && (m_b32 == 0)) begin
        re = {s_a32 ^ s_b32, 31'b0};
        flags[0] = 1'b1;
      end else begin
        // normal or subnormal multiplicaton
        // build 24-bit mantissas (implicit 1 for normals, 0 for subnormals)
        mantA_24 = (e_a32 == 0) ? {1'b0, m_a32} : {1'b1, m_a32};
        mantB_24 = (e_b32 == 0) ? {1'b0, m_b32} : {1'b1, m_b32};

        // unbiased exponents
        exp_un_a = (e_a32 == 0) ? (1 - BIAS_32) : (e_a32 - BIAS_32);
        exp_un_b = (e_b32 == 0) ? (1 - BIAS_32) : (e_b32 - BIAS_32);

        // multiply mantissas (24x24 -> 48 bits)
        mant_prod48 = mantA_24 * mantB_24;
        exp_un_sum = exp_un_a + exp_un_b;

        // normalize product: place integer bit (1) at bit 47 if possible
        sl = 0;
        if (mant_prod48 == 0) begin
          // product is zero, exponent irrelevant (will be caught por underflow/zero cases)
        end else if (mant_prod48[47]) begin
          // product >= 2 -> shift right 1 and bump exponent
          mant_prod48 = mant_prod48 >> 1;
          exp_un_sum = exp_un_sum + 1;
        end else begin
          // product < 2 and > 0: need to left-shift until MSB is at bit 47
          // find first 1 starting from MSB
          sl = 0;
          while (sl < 48 && mant_prod48[47 - sl] == 0)
            sl = sl + 1;

          if (sl != 0 && sl < 48) begin
            mant_prod48 = mant_prod48 << sl;
            exp_un_sum = exp_un_sum - sl;
          end
        end
        // normalize: ensure integer bit sits at bit index 46 (i.e., value 1.x)
        // if mant_prod48[47]==1 then product >=2 -> shift right by 1 and bump exponent
        if (mant_prod48[47]) begin
          mant_prod48 = mant_prod48 >> 1;
          exp_un_sum = exp_un_sum + 1;
        end

        biased32_signed = exp_un_sum + BIAS_32;

        // overflow check
        if (biased32_signed >= 255) begin
          re = (s_a32 ^ s_b32) ? INF_32N : INF_32P;
          flags[4] = 1'b1; // overflow
          flags[1] = 1'b1; // inexact (overflow loses information)
          end else if (biased32_signed <= 0) begin
          // --- UNDERFLOW (single) : producir denormal o cero ---
          // shift_right = 1 - biased32_signed  (cuántos bits hay que desplazar a la derecha)
          shift_right = (1 - biased32_signed) + 1;
          temp = mant_prod48;

          if (shift_right >= 48) begin
            // todo se pierde -> cero con signo
            re = {s_a32 ^ s_b32, 31'b0};
            flags[3] = 1'b1; // underflow
            flags[1] = 1'b1; // inexact
            flags[0] = 1'b1; // denormal/zero
          end else begin
            // calcular sticky de los bits que se perderán al desplazar
            sticky_local = 1'b0;
            for (kk = 0; kk < shift_right; kk = kk + 1) sticky_local = sticky_local | temp[kk];
            temp = temp >> shift_right;

            // extraer fracción (23 bits) y bits G/R/S desde temp
            frac32 = temp[45:23];
            g32    = temp[22];
            r32    = temp[21];
            sticky32 = sticky_local | (|temp[20:0]);

            // redondeo
            if (round_mode) begin
              // round to nearest even
              if (g32 && (r32 || sticky32 || frac32[0])) begin
                frac32 = frac32 + 1'b1;
                flags[1] = 1'b1; // inexact
                // si carry a la fracción produce normalización:
                if (frac32 == 23'h400000) begin
                  // se convierte en normal con exponente = 1 (biased)
                  re = {s_a32 ^ s_b32, 8'd1, 23'h0};
                end else begin
                  re = {s_a32 ^ s_b32, 8'd0, frac32};
                end
              end else begin
                re = {s_a32 ^ s_b32, 8'd0, frac32};
                if (g32 || r32 || sticky32) flags[1] = 1'b1;
              end
            end else begin
              // truncate
              re = {s_a32 ^ s_b32, 8'd0, frac32};
              if (g32 || r32 || sticky32) flags[1] = 1'b1;
            end

            // si el resutado es pequeño y cae fuera del rando normalizado, se mantiene exp = 0, denormal
            if(re[30:23] != 8'd0) re[30:23] = 8'd0;

            flags[3] = 1'b1; // underflow
            flags[0] = (re[30:0] == 31'b0) ? 1'b1 : flags[0];
          end
        end else begin
          // normal result: biased in [1..254]
          t = mant_prod48; // normalized mantissa with integer bit at 46
          frac32 = t[45:23];
          g32 = t[22];
          r32 = t[21];
          sticky32 = |t[20:0];
          // rounding
          if (round_mode) begin
            if (g32 && (r32 || sticky32 || frac32[0])) begin
              frac32 = frac32 + 1'b1;
              inexact_local = 1'b1;
              // handle carry-out of mantissa
              if (frac32 == 23'h400000) begin
                // mantissa overflow -> becomes 1.0 and exponent +1
                frac32 = 23'h0;
                biased32_signed = biased32_signed + 1;
                if (biased32_signed >= 255) begin
                  // overflow to Inf
                  re = (s_a32 ^ s_b32) ? INF_32N : INF_32P;
                  flags[4] = 1'b1;
                  flags[1] = 1'b1;
                end else begin
                  re = {s_a32 ^ s_b32, biased32_signed[7:0], frac32};
                end
              end else begin
                re = {s_a32 ^ s_b32, biased32_signed[7:0], frac32};
              end
            end else begin
              // no rounding increment
              re = {s_a32 ^ s_b32, biased32_signed[7:0], frac32};
              if (g32 || r32 || sticky32) inexact_local = 1'b1;
            end
          end else begin
            // truncate
            re = {s_a32 ^ s_b32, biased32_signed[7:0], frac32};
            if (g32 || r32 || sticky32) inexact_local = 1'b1;
          end
          if (inexact_local) flags[1] = 1'b1;
          // denormal indicator if exponent bits are zero (not in this branch)
          flags[0] = (re[30:0] == 31'b0) ? 1'b1 : flags[0];
        end
      end
    end else begin
      // ---------------------------
      // HALF PRECISION PATH (16)
      // We return result in lower 16 bits of 're' (upper 16 bits zero)
      // ---------------------------

      // special cases
      if ((e_a16 == 5'h1F && m_a16 != 0) || (e_b16 == 5'h1F && m_b16 != 0)) begin
        re = {16'b0, NAN_16};
        flags[2] = 1'b1;
      end else if (((e_a16 == 5'h1F) && (m_a16 == 0) && (e_b16 == 0) && (m_b16 == 0)) ||
                   ((e_b16 == 5'h1F) && (m_b16 == 0) && (e_a16 == 0) && (m_a16 == 0))) begin
        re = {16'b0, NAN_16};
        flags[2] = 1'b1;
      end else if ((e_a16 == 5'h1F) && (m_a16 == 0)) begin
        re = {16'b0, (s_a16 ^ s_b16) ? INF_16N : INF_16P};
        flags[4] = 1'b1;
      end else if ((e_b16 == 5'h1F) && (m_b16 == 0)) begin
        re = {16'b0, (s_a16 ^ s_b16) ? INF_16N : INF_16P};
        flags[4] = 1'b1;
      end else if ((e_a16 == 0) && (m_a16 == 0)) begin
        re = { (s_a16 ^ s_b16) ? 32'h8000_0000 : 32'h0000_0000 }; // lower 16 contain zero
        flags[0] = 1'b1;
      end else if ((e_b16 == 0) && (m_b16 == 0)) begin
        re = { (s_a16 ^ s_b16) ? 32'h8000_0000 : 32'h0000_0000 };
        flags[0] = 1'b1;
      end else begin
        // form 11-bit mantissas (implicit 1)
        mantA_11 = (e_a16 == 0) ? {1'b0, m_a16} : {1'b1, m_a16};
        mantB_11 = (e_b16 == 0) ? {1'b0, m_b16} : {1'b1, m_b16};

        // to reuse single logic, left-align 11-bit mantissas into 24-bit fields:
        // shift left by (24 - 11) = 13
        mAext = {mantA_11, 13'b0}; // 24-bit
        mBext = {mantB_11, 13'b0};
        prod48_half = mAext * mBext; // 48-bit

        exp_un_a = (e_a16 == 0) ? (1 - BIAS_16) : (e_a16 - BIAS_16);
        exp_un_b = (e_b16 == 0) ? (1 - BIAS_16) : (e_b16 - BIAS_16);
        exp_un_sum = exp_un_a + exp_un_b;

        // normalization: after left-alignment the integer bit location ends up at index 46 (same convention)
        if (prod48_half[47]) begin
          prod48_half = prod48_half >> 1;
          exp_un_sum = exp_un_sum + 1;
        end

        biased16_signed = exp_un_sum + BIAS_16;

        if (biased16_signed >= 31) begin
          // overflow -> INF16
          re = {16'b0, (s_a16 ^ s_b16) ? INF_16N : INF_16P};
          flags[4] = 1'b1;
          flags[1] = 1'b1;
        end else if (biased16_signed <= 0) begin
          // --- UNDERFLOW (half) : producir denormal o zero ---
          sr = 1 - biased16_signed;

          if (sr >= 48) begin
            re = { (s_a16 ^ s_b16) ? 32'h8000_0000 : 32'h0000_0000 };
            flags[3] = 1'b1;
            flags[1] = 1'b1;
            flags[0] = 1'b1;
          end else begin
            // calc sticky de los bits que se pierden
            tmp = prod48_half;
            sticky_local = 1'b0;
            for (kk = 0; kk < sr; kk = kk + 1) sticky_local = sticky_local | tmp[kk];
            tmp = tmp >> sr;

            // fraction 10 bits: posiciones 45:36 (después de normalización)
            frac16 = tmp[45:36];
            g16 = tmp[35];
            r16 = tmp[34];
            sticky16 = sticky_local | (|tmp[33:0]);

            if (round_mode) begin
              // round-to-nearest-even
              if (g16 && (r16 || sticky16 || frac16[0])) begin
                frac16 = frac16 + 1'b1;
                flags[1] = 1'b1;
                if (frac16 == 10'h3FF) begin
                  // se vuelve normal con exp=1
                  re = {16'b0, { (s_a16 ^ s_b16), 5'd1, 10'h0 } };
                end else begin
                  re = {16'b0, { (s_a16 ^ s_b16), 5'd0, frac16 } };
                end
              end else begin
                re = {16'b0, { (s_a16 ^ s_b16), 5'd0, frac16 } };
                if (g16 || r16 || sticky16) flags[1] = 1'b1;
              end
            end else begin
              re = {16'b0, { (s_a16 ^ s_b16), 5'd0, frac16 } };
              if (g16 || r16 || sticky16) flags[1] = 1'b1;
            end

            flags[3] = 1'b1;
            flags[0] = (re[15:0] == 16'b0) ? 1'b1 : flags[0];
          end
        end else begin
          // normal half result
          biased16 = biased16_signed[4:0];
          // fraction selecting: after normalization integer is at bit 46, so fraction bits are 45:36 (10 bits)
          frac16 = prod48_half[45:36];
          g16 = prod48_half[35];
          r16 = prod48_half[34];
          sticky16 = |prod48_half[33:0];
          if (round_mode) begin
            if (g16 && (r16 || sticky16 || frac16[0])) begin
              frac16 = frac16 + 1'b1;
              flags[1] = 1'b1;
              if (frac16 == 10'h3FF) begin
                // carry -> exponent +1
                biased16 = biased16 + 1;
                frac16 = 10'h0;
                if (biased16 >= 5'h1F) begin
                  // overflow to Inf16
                  re = {16'b0, (s_a16 ^ s_b16) ? INF_16N : INF_16P};
                  flags[4] = 1'b1;
                  flags[1] = 1'b1;
                end else begin
                  re = {16'b0, { (s_a16 ^ s_b16), biased16, frac16 } };
                end
              end else begin
                re = {16'b0, { (s_a16 ^ s_b16), biased16, frac16 } };
              end
            end else begin
              re = {16'b0, { (s_a16 ^ s_b16), biased16, frac16 } };
              if (g16 || r16 || sticky16) flags[1] = 1'b1;
            end
          end else begin
            re = {16'b0, { (s_a16 ^ s_b16), biased16, frac16 } };
            if (g16 || r16 || sticky16) flags[1] = 1'b1;
          end
        end
      end
    end
  end
endmodule
