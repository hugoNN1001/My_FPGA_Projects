`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2025 04:45:50 PM
// Design Name: 
// Module Name: BCD_Digit_Incrementor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// This module is a one BCD digit incrementor.
// The input for i_En can be a button (if it's the first digit)
// or a carry in from the previous digit (if it's not the first digit). 
module BCD_Digit_Incrementor(
  input i_Clk,
  input i_Rst,
  input i_En,
  output reg o_Carry_Out,
  output reg [3:0] o_Digit);
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      o_Digit <= 4'd0;
      o_Carry_Out <= 1'b0;
    end
    else if (i_En) begin
      if (o_Digit == 4'd9) begin
        o_Digit <= 4'd0;
        o_Carry_Out <= 1'b1;
      end else begin
        o_Digit <= o_Digit + 4'd1;
        o_Carry_Out <= 1'b0; 
      end
    end 
    else begin
      o_Carry_Out <= 1'b0; 
    end 
  end
endmodule
