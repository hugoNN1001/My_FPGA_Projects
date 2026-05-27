`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2025 11:10:50 AM
// Design Name: 
// Module Name: Dual_Priority_Encoder_Tester
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


module Dual_Priority_Encoder_Tester(
  input i_Clk,
  input [11:0] i_Sw,
  output [11:0] o_LED, // To show the input from the switches
  output [6:0] o_7Segment,
  output [3:0] o_AN);
  
  assign o_LED = i_Sw;
  
  wire [3:0] first, second;
  
  Dual_Priority_Encoder Dual_Priority_Encoder0 (
  .in(i_Sw),
  .first(first),
  .second(second));
  
  Display_Mux_wo_DP Display_Mux_wo_DP0 (
  .i_Clk(i_Clk),
  .in0(second), 
  .in1(first), 
  .in2(4'd0), 
  .in3(4'd0),
  .i_En(4'b0011),
  .o_7Segment(o_7Segment),
  .o_AN(o_AN));
  
endmodule
