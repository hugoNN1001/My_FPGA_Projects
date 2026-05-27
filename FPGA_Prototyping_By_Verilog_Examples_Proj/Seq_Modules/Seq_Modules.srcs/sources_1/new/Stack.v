`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2026 02:21:46 PM
// Design Name: 
// Module Name: Stack
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


module Stack_LIFO #(parameter N = 8, W = 4) (
  input i_Clk,
  input i_Rst,
  input i_Push,
  input i_Pop,
  input [N-1:0] i_Push_Data,
  output wire [N-1:0] o_Pop_Data,
  output o_Full,
  output o_Empty);
  
  reg [N-1:0] stack [2**W-1:0];
  // Stack Pointer has 1 extra bit to detect full condition
  reg [W:0] SP;
  reg r_full;
  reg r_empty;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      // Set SP back to 0, old data in stack will be ignored and overwritten at some point
      // Does not clear the whole stack upon reset
      SP <= 0;
    end
    else if (i_Push && !r_full) begin
      stack[SP[W-1:0]] <= i_Push_Data;  // Ignore the 5th bit for memory write
      SP <= SP + 1;
    end
    else if (i_Pop && !r_empty) begin
      SP <= SP - 1;
    end
  end
  
  // Popped data is always available in o_Pop_Data
  assign o_Pop_Data = r_empty ? stack[0] : stack[SP[W-1:0]-1];
  
  always @(*) begin
    // Default:
    r_full = 1'b0;
    r_empty = 1'b0;
    
    if (SP == 2**W) begin
      r_full = 1'b1;
    end
    else if (SP == 0) begin
      r_empty = 1'b1;
    end
  end
  
  assign o_Full = r_full;
  assign o_Empty = r_empty;
endmodule
