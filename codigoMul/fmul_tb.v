`timescale 1ns/1ns
module tb();
  reg [31:0] op_a, op_b;
  reg mode_fp, round_mode;
  wire [31:0] result;
  integer total_tests, failed_tests;

  // banderas IEEE
  reg invalid, overflow, underflow, inexact, divide_by_zero;

  fmul uut (.op_a(op_a), .op_b(op_b), .mode_fp(mode_fp), .round_mode(round_mode), .re(result));

  // --- Constantes IEEE ---
  localparam NAN_32  = 32'h7FC00000;
  localparam INF_32P = 32'h7F800000;
  localparam INF_32N = 32'hFF800000;
  localparam ZP_32   = 32'h00000000;
  localparam ZN_32   = 32'h80000000;
  localparam DEN_32  = 32'h00000001; // subnormal más pequeño
  localparam ONE_32  = 32'h3F800000; // 1.0
  localparam TWO_32  = 32'h40000000; // 2.0
  localparam NEG_32  = 32'hBF800000; // -1.0
  localparam BIG_32  = 32'h7F7FFFFF; // máximo normal antes de overflow
  localparam SMALL_32= 32'h00800000; // mínimo normal

  task check_case;
    input [31:0] a, b;
    input [31:0] expected;
    input [255:0] name;
    begin
      total_tests = total_tests + 1;
      #10;
      if (result !== expected) begin
        failed_tests = failed_tests + 1;
        $display("Falló %-20s | a=%h b=%h result=%h esperado=%h", name, a, b, result, expected);
      end else begin
        $display("OK %-20s | a=%h b=%h result=%h", name, a, b, result);
      end
    end
  endtask

  task ieee_flags_reset;
    begin
      invalid = 0; overflow = 0; underflow = 0; inexact = 0; divide_by_zero = 0;
    end
  endtask

  initial begin
    $dumpfile("fmul.vcd");
    $dumpvars(0, tb);
    total_tests = 0;
    failed_tests = 0;

    mode_fp = 1; // SINGLE PRECISION
    round_mode = 1; // round to nearest even

    
    // ==== CASOS BÁSICOS ===
    
    ieee_flags_reset();
    op_a = ONE_32; op_b = TWO_32; check_case(op_a, op_b, 32'h40000000, "1*2=2");
    op_a = TWO_32; op_b = ONE_32; check_case(op_a, op_b, 32'h40000000, "2*1=2");
    op_a = ONE_32; op_b = NEG_32; check_case(op_a, op_b, 32'hBF800000, "1*(-1)=-1");
    op_a = NEG_32; op_b = NEG_32; check_case(op_a, op_b, 32'h3F800000, "(-1)*(-1)=1");
    op_a = ZP_32; op_b = ONE_32; check_case(op_a, op_b, ZP_32, "0*1=0");
    op_a = ONE_32; op_b = ZN_32; check_case(op_a, op_b, ZN_32, "1*(-0)=-0");

    
    // ==== CASOS ESPECIALES IEEE ===
    
    op_a = NAN_32; op_b = ONE_32; check_case(op_a, op_b, NAN_32, "NaN*1=NaN");
    op_a = INF_32P; op_b = ZP_32; check_case(op_a, op_b, NAN_32, "Inf*0=NaN");
    op_a = INF_32P; op_b = INF_32N; check_case(op_a, op_b, INF_32N, "+Inf*-Inf=-Inf");
    op_a = INF_32N; op_b = INF_32N; check_case(op_a, op_b, INF_32P, "-Inf*-Inf=+Inf");

    
    // ==== DENORMALES ===
    
    op_a = DEN_32; op_b = TWO_32; check_case(op_a, op_b, 32'h00000002, "denormal*2");
    op_a = SMALL_32; op_b = DEN_32; check_case(op_a, op_b, 32'h00000000, "min_normal*denormal (underflow)");

    
    // ==== OVERFLOW / UNDERFLOW ===
    
    op_a = BIG_32; op_b = TWO_32; check_case(op_a, op_b, INF_32P, "overflow");
    op_a = SMALL_32; op_b = SMALL_32; check_case(op_a, op_b, 32'h00000000, "underflow");

    
    // ==== PROPIEDADES ===
    
    op_a = 32'h3F000000; // 0.5
    op_b = 32'h40000000; // 2.0
    check_case(op_a, op_b, 32'h3F800000, "0.5*2=1");
    op_a = 32'h40000000; op_b = 32'h3F000000; check_case(op_a, op_b, 32'h3F800000, "2*0.5=1 (commutativo)");

    
    // ==== HALF PRECISION ===
    
    mode_fp = 0;
    op_a = 32'h00003C00; // half: 1.0
    op_b = 32'h00004000; // half: 2.0
    check_case(op_a, op_b, 32'h00004000, "half 1*2=2");
    op_a = 32'h00007C00; // +Inf half
    op_b = 32'h00000000; // +0 half
    check_case(op_a, op_b, 32'h00007E00, "half +Inf*0=NaN");

    $display("\n===============================");
    $display(" RESUMEN DE PRUEBAS FMUL IEEE-754");
    $display("===============================");
    $display(" Casos totales: %0d", total_tests);
    $display(" Casos fallidos: %0d", failed_tests);
    $display(" Casos exitosos: %0d", total_tests - failed_tests);
    if (failed_tests == 0)
      $display("Todos los casos pasaron correctamente.");
    else
      $display("Revisar los casos fallidos mostrados arriba.");
    $finish;
  end
endmodule
