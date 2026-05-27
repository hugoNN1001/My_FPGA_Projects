`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2026 04:17:46 PM
// Design Name: 
// Module Name: BCD_To_Binary
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Converts a 4-digit BCD number into its binary equivalent
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BCD_To_Binary(
  input i_Clk, i_Rst,
  input [15:0] i_BCD_In,
  output reg [$clog2(9999)-1:0] o_Binary_Out
  );
  
  reg [$clog2(9)-1:0] r_Sum_Ones;       // Max 9 
  reg [$clog2(90)-1:0] r_Sum_Tens;       // Max 90
  reg [$clog2(900)-1:0] r_Sum_Hundreds;   // Max 900
  reg [$clog2(9000)-1:0] r_Sum_Thousands;  // Max 9000
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      r_Sum_Ones = 0;
      r_Sum_Tens = 0;
      r_Sum_Hundreds = 0;
      r_Sum_Thousands = 0;
      o_Binary_Out = 0;
    end
    else begin
      r_Sum_Ones <= i_BCD_In[3:0];
      r_Sum_Tens <= i_BCD_In[7:4] * 10;
      r_Sum_Hundreds <= i_BCD_In[11:8] * 100;
      r_Sum_Thousands <= i_BCD_In[15:12] * 1000;
    end
  end
  
  always @(posedge i_Clk) begin
    o_Binary_Out <= r_Sum_Ones + r_Sum_Tens + r_Sum_Hundreds + r_Sum_Thousands;
  end
endmodule
