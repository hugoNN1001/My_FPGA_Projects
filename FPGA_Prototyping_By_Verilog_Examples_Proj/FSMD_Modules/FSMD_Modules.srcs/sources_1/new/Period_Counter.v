`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2026 03:54:16 PM
// Design Name: 
// Module Name: Period_Counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module measures the period of a periodic input waveform
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Period_Counter(
  input clk, rst,
  input input_wave,
  // The output period in milliseconds
  output [5:0] period,
  output done_tick);
  
  // FSM states enumeration
  localparam [1:0] idle = 2'b00,
                   waite = 2'b01,
                   count = 2'b10,
                   done = 2'b11;
  
  // signal declaration
  reg [1:0] state_reg, state_next;
endmodule
