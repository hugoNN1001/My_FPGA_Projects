`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2026 07:37:01 PM
// Design Name: 
// Module Name: Stopwatch
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


module Stopwatch(
  input i_Clk,
  input i_Clr,
  input i_Go,
  output [3:0] d2, d1, d0);
  
  localparam DVSR = 10_000_000; // 10,000,000 clk cycles = 0.1s
  // $clog2(10_000_000) = 24: number of bits to hold DVSR
  
  // Basys 3 has a 100MHz clock
  // ms_tick is set every DVSR clk cycles (every 0.1s)
  // Every 0.1s increment the 0.1s timer (d0_tick)
  // Every time d0_tick hits 10 increment the 1s timer (d1_tick)
  
  // Signal declaration
  reg [23:0] ms_reg;
  wire [23:0] ms_next;
  wire ms_tick;
  
  reg [3:0] d0_reg;
  wire [3:0] d0_next;
  wire d0_en;
  wire d0_tick;
  
  reg [3:0] d1_reg;
  wire [3:0] d1_next;
  wire d1_en;
  wire d1_tick;
  
  reg [3:0] d2_reg;
  wire [3:0] d2_next;
  wire d2_en;
  wire d2_tick;
  
  // Body
  // Register
  always @(posedge i_Clk) begin
    ms_reg <= ms_next;
    d0_reg <= d0_next;
    d1_reg <= d1_next;
    d2_reg <= d2_next;
  end
  
  // Next-state logic
  // 0.1s tick generator
  assign ms_next = (i_Clr || (ms_reg == DVSR-1 && i_Go)) ? 0 : 
            (i_Go) ? ms_reg + 1'b1 : ms_reg;
  assign ms_tick = (ms_reg == DVSR - 1) ? 1'b1 : 1'b0;
  
  // 0.1s counter
  assign d0_en = ms_tick;
  assign d0_next = (i_Clr || (d0_reg == 9 && d0_en)) ? 0 : 
            (d0_en) ? d0_reg + 1'b1 : d0_reg;
  assign d0_tick = (d0_reg == 9) ? 1'b1 : 1'b0;
  
  // 1s counter
  assign d1_en = ms_tick & d0_tick; // d0_tick alone will be ON for 0.1s (millions of clk cycles), ms_tick is only ON for 1 clk cycle
  assign d1_next = (i_Clr || (d1_reg == 9 && d1_en)) ? 0 : 
            (d1_en) ? d1_reg + 1'b1 : d1_reg;
  assign d1_tick = (d1_reg == 9) ? 1'b1 : 1'b0;
  
  // 1s counter
  // In a cascaded counter, a digit only increments if all the digits 
  // to its right at acurrently at their maximum value (9) and
  // the main counter (ms_tick) is firing
  assign d2_en = ms_tick & d0_tick & d1_tick; 
  
  assign d2_next = (i_Clr || (d2_reg == 9 && d2_en)) ? 0 : 
            (d2_en) ? d2_reg + 1'b1 : d2_reg;
  assign d2_tick = (d2_reg == 9) ? 1'b1 : 1'b0;
  
  // Output logic
  assign d0 = d0_reg;
  assign d1 = d1_reg;
  assign d2 = d2_reg;
  
endmodule
