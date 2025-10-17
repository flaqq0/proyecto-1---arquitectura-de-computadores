`timescale 1ns/1ps
module fdiv(op_a, op_b, round_mode, result);
  input round_mode;                                                         
  input [31:0] op_a, op_b;                                                  
  output reg [31:0] result;                                                 
                                                                            
  //unpack los bits                                                         
  wire s_a, s_b;                                                            
  wire [22:0] m_a, m_b;                                                     
  wire [7:0] e_a, e_b;                                                      
  assign s_a = op_a[31]; assign e_a = op_a[30:23]; assign m_a = op_a [22:0];
  assign s_b = op_b[31]; assign e_b = op_b[30:23]; assign m_b = op_b [22:0];

  //flags para identificar casos especiales
  wire a_inf = (e_a == 8'hFF) && (m_a == 0);
  wire b_inf = (e_b == 8'hFF) && (m_b == 0);
  wire a_nan = (e_a == 8'hFF) && (m_a != 0);
  wire b_nan = (e_b == 8'hFF) && (m_b != 0);
  wire a_zero = (e_a == 0) && (m_a == 0);
  wire b_zero = (e_b == 0) && (m_b == 0);

  reg [31:0] temp;
  reg f_special; //flag casos especiales
  localparam NaN = 32'h7FC00000;

  //resultado casos especiales
  always @(*) begin
    f_special = 1'b1;
    if (a_nan || b_nan) temp = NaN;
    else if (a_inf && b_inf) temp = NaN; // inf/inf = NaN
    else if (a_inf) temp = {s_a ^ s_b, 8'hFF, 23'b0}; // inf / finite = inf
    else if (b_inf) temp = {s_a ^ s_b, 8'h00, 23'b0}; // num / inf = 0
    else if (b_zero) temp = NaN; // num/0 = NaN
    else if (a_zero) temp = {s_a ^ s_b, 8'h00, 23'b0}; // 0 / finite = 0
    else begin
      temp = 32'h0;
      f_special = 1'b0;
    end
  end

endmodule
