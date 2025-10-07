# proyecto-1---arquitectura-de-computadores
Diseño e implementación de una ALU capaz de resolver operaciones en punto flotante (IEEE-754, 32 bits y 16 bits) en FPGA Basys3

Deben diseñar, implementar y verificar una Unidad Aritmético-Lógica (ALU) con soporte para números en punto flotante conforme al estándar IEEE-754 (single precision, 32 bits y half precision, 16 bits). El proyecto exige la ejecución correcta de operaciones aritméticas básicas y el manejo de los casos especiales definidos por el estándar (NaN, ±Inf, denormales, distintos modos de redondeo y excepciones).
2. Objetivos generales
* Diseñar una ALU en HDL (Verilog o VHDL) que implemente operaciones aritméticas en punto flotante de 32 y 16 bits.
• Verificar la funcionalidad mediante testbenches y vectores de prueba.
• Implementar el diseño en la placa Basys3 y demostrar su funcionamiento.
3. Objetivos específicos
1. Implementar las siguientes operaciones en punto flotante (IEEE-754, single y half):
o Suma (fadd)
o Resta (fsub)
o Multiplicación (fmul)
o División (fdiv)
2. Manejar modos de redondeo: round to nearest even (obligatorio).
3. Detectar y reportar excepciones/flags: overflow, underflow, divide-by-zero, invalid operation,
inexact.
4. Soporte correcto para NaN, ±Inf, ceros con signo y números denormales.
4. Interfaz y especificación funcional
• Entradas principales:
o op_a[31:0], op_b[31:0] — operandos (IEEE-754, single o half)
o op_code[2:0] — selecciona la operación (ADD, SUB, MUL, DIV)
o mode_fp — bit que selecciona el formato: 0 = half (16 bits), 1 = single (32 bits)
o clk, rst — señales de control
o round_mode — modo de redondeo (mínimo: nearest)
