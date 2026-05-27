`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2026 01:31:19 PM
// Design Name: 
// Module Name: Dual_Edge__Detector_Tester
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


module Dual_Edge_Detector_Tester(
  input i_Clk,
  input i_Rst,
  input i_Level,
  output o_Edge);
  
  wire w_debounced_level;
  
  Debounce_Filter Debounce_Filter0(
  .i_Clk(i_Clk),
  .i_BouncyBtn(i_Level),
  .o_DebouncedBtn_Level(),
  .o_DebouncedBtn_Pulse(w_debounced_level)
  );
  
  Dual_Edge_Detector_Moore UUT(
  .i_Clk(i_Clk),
  .i_Rst(i_Rst), 
  .i_Level(w_debounced_level),
  .o_Edge(o_Edge));
  
//  Uncomment to test edge detector using Mealy machine
//  Dual_Edge_Detector_Mealy(
//  .i_Clk(i_Clk),
//  .i_Rst(i_Rst), 
//  .i_Level(w_debounced_level),
//  .o_Edge(o_Edge));
endmodule
