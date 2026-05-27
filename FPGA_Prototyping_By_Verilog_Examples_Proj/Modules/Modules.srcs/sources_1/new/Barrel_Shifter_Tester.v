`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2025 10:36:58 AM
// Design Name: 
// Module Name: Barrel_Shifter_Tester
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


module Barrel_Shifter_R_Tester(
  input [7:0] input_sw,
  input [2:0] amt_sw,
  output [7:0] output_led);
  
  Barrel_Shifter_R Barrel_Shifter_R0 (
  .a(input_sw),
  .amt(amt_sw),
  .y(output_led));
  
endmodule
