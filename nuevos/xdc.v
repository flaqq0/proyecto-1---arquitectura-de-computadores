`timescale 1ns / 1ps

module falu_top(
    input clk,
    input btnC,       // botón para confirmar input
    input btnU,       // botón para iniciar
    input btnR,       // reset
    input [15:0] sw,  // switches input
    output [15:0] led // salida LEDs
);

    // Control por switches
    wire [2:0] op_code = sw[15:13];  // operación: add/sub/mul/div
    wire mode_fp = sw[12];           // 0=half, 1=single
    wire showH = sw[0];          // 0: bits bajos, 1: bits altos

    // Internos
    reg [31:0] op_a, op_b;
    reg [1:0] state; // 0=A[31:16], 1=A[15:0], 2=B[31:16], 3=B[15:0]
    reg start;
    wire [31:0] result;
    wire valid_out;
    wire [4:0] flags;

    // Instancia de la ALU flotante
    falu alu_inst (.clk(clk), .rst(btnR), .start(start), .op_a(op_a), .op_b(op_b),
        .op_code(op_code), .mode_fp(mode_fp), .round_mode(1'b0), .result(result),
        .valid_out(valid_out), .flags(flags));

    // Carga de datos x secuencia
    always @(posedge clk or posedge btnR) begin
        if (btnR) begin
            op_a <= 32'b0;
            op_b <= 32'b0;
            state <= 2'b00;
            start <= 1'b0;
        end else begin
            start <= 1'b0; // default

            if (btnC) begin
                case (state)
                    2'b00: begin
                        op_a[31:16] <= sw;  // primeros 16 bits de a
                        state <= 2'b01;
                    end
                    2'b01: begin
                        op_a[15:0] <= sw;   // últimos 16 bits de a
                        if (mode_fp) state <= 2'b10; // single → pasar a b high
                        else state <= 2'b11;         // half → pasar directo a b low
                    end
                    2'b10: begin
                        op_b[31:16] <= sw;  // primeros 16 bits de b
                        state <= 2'b11;
                    end
                    2'b11: begin
                        op_b[15:0] <= sw;   // últimos 16 bits de b
                        state <= 2'b00;     // reiniciar para siguiente operación
                    end
                endcase
            end

            if (btnU) begin
                start <= 1'b1; // ejecutar ALU
            end
        end
    end

    // Mostrar resultado. sw[0] = 0 bits bajos, = 1 bits altos
    assign led = (showH) ? result[31:16] : result[15:0];

endmodule
