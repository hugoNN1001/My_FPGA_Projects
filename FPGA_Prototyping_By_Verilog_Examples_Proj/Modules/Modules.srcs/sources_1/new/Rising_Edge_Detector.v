`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2026 12:17:49 AM
// Design Name: 
// Module Name: Rising_Edge_Detector
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

// Before clk edge 1: i_Wave_In = 1, r_Wave_In = 0, r_Wave_In_Delayed = 0
// At clk edge 1: i_Wave_In = 1, r_Wave_In = 1, r_Wave_In_Delayed = 0 => o_Edge = 1
// At clk edge 2: i_Wave_In = 1, r_Wave_In = 1, r_Wave_In_Delayed = 1 => o_Edge = 0
module Rising_Edge_Detector(
  input i_Clk, i_Rst, 
  input i_Wave_In,
  output wire o_Edge);
  
  reg r_Wave_In;
  reg r_Wave_In_Delayed;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      r_Wave_In <= 1'b0;
      r_Wave_In_Delayed <= 1'b0;
    end
    else begin
      r_Wave_In <= i_Wave_In;
      // Create a delayed version of the input wave
      r_Wave_In_Delayed <= r_Wave_In;
    end
  end
  
  // Set o_Edge when the delayed wave is 0 and the current wave is 1
  assign o_Edge = r_Wave_In & !r_Wave_In_Delayed;
  
endmodule
