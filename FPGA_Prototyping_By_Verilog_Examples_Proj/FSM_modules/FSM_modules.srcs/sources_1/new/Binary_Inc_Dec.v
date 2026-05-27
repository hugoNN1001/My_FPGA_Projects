`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2026 01:29:53 PM
// Design Name: 
// Module Name: Counter
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


module Binary_Inc_Dec #(parameter COUNT_LIMIT = 16) (
  input i_Clk,
  input i_Rst,
  input i_Inc,
  input i_Dec,
  output reg [$clog2(COUNT_LIMIT)-1:0] o_Count);
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      o_Count <= 0;
    end
    else if (i_Inc && o_Count != COUNT_LIMIT-1) begin
      o_Count <= o_Count + 1;
    end
    else if (i_Dec && o_Count != 0) begin
      o_Count <= o_Count - 1;
    end
    // Techinically don't need this else cuz 
    // a register naturally holds its value
    else begin
      o_Count <= o_Count;
    end
  end
endmodule
