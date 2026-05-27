`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2026 04:54:08 PM
// Design Name: 
// Module Name: Enhanced_Stopwatch
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

// Display format M.SS.D, where D represents 0.1s
//                              SS represents seconds (0-59)
//                              M represents minutes (0-9)                                
module Enhanced_Stopwatch(
  input i_Clk,
  input i_Clr,
  input i_Go,
  input i_Up, // 1: counting up; 0: counting down
  output [3:0] M, S1, S0, D);
  
  localparam DVSR = 10_000_000; // 10,000,000 clk cycles = 0.1s
  // $clog2(10_000_000) = 24: number of bits to hold DVSR
  
  // Basys 3 has a 100MHz clock
  // ms_tick is set every DVSR clk cycles (every 0.1s)
  // Every 0.1s increment the 0.1s timer (d0_tick)
  // Every time d0_tick hits 10 increment the 1s timer (d1_tick)
  
  // ms counter
  reg [23:0] ms_reg;
  reg [23:0] ms_next;
  wire ms_tick;
  
  // 0.1s counter
  reg [3:0] D_reg;
  reg [3:0] D_next;
  wire D_en;
  wire D_tick;
  
  // 1s counter
  reg [3:0] S0_reg;
  reg [3:0] S0_next;
  wire S0_en;
  wire S0_tick;
  
  // 10s counter
  reg [2:0] S1_reg; // only needs to hold 0-5
  reg [2:0] S1_next;
  wire S1_en;
  wire S1_tick;

  // 1-minute counter
  reg [3:0] M_reg;
  reg [3:0] M_next;
  wire M_en;
  
  // Main sequential logic
  always @(posedge i_Clk) begin
    ms_reg <= ms_next;
    D_reg <= D_next;
    S0_reg <= S0_next;
    S1_reg <= S1_next;
    M_reg <= M_next;
  end
  
  // Next-state logic
  
  always @(*) begin
    // Default: keep current value
    ms_next = ms_reg;
    D_next = D_reg;
    S0_next = S0_reg;
    S1_next = S1_reg;
    M_next = M_reg;
    
    if (i_Clr) begin
      ms_next = 0;
      D_next = 0;
      S0_next = 0;
      S1_next = 0;
      M_next = 0;
    end
    else begin
      if (i_Go) begin
        // It doesn't matter whether we're counting up or down
        // ms_reg will still advance
        ms_next = (ms_reg == DVSR-1) ? 0 : ms_reg + 1;
      end
      if (D_en) begin
        D_next = (i_Up) ? ((D_reg == 9) ? 0 : D_reg + 1) : ((D_reg == 0) ? 9 : D_reg - 1);
      end
      if (S0_en) begin
        S0_next = (i_Up) ? ((S0_reg == 9) ? 0 : S0_reg + 1) : ((S0_reg == 0) ? 9 : S0_reg - 1);
      end
      if (S1_en) begin
        S1_next = (i_Up) ? ((S1_reg == 5) ? 0 : S1_reg + 1) : ((S1_reg == 0) ? 5 : S1_reg - 1);
      end
      if (M_en) begin
        M_next = (i_Up) ? ((M_reg == 9) ? 0 : M_reg + 1) : ((M_reg == 0) ? 9 : M_reg - 1);
      end
    end
  end
  
  assign ms_tick = (i_Go && (ms_reg == DVSR-1));
  assign D_tick = D_en  && ((i_Up && D_reg == 9)  || (!i_Up && D_reg == 0));
  assign S0_tick = S0_en  && ((i_Up && S0_reg == 9)  || (!i_Up && S0_reg == 0));
  assign S1_tick = S1_en  && ((i_Up && S1_reg == 5)  || (!i_Up && S1_reg == 0));
  
  assign D_en = ms_tick;
  assign S0_en = D_tick;
  assign S1_en = S0_tick;
  assign M_en = S1_tick; 
  
  // Output logic
  assign D = D_reg;
  assign S0 = S0_reg;
  assign S1 = S1_reg;
  assign M = M_reg;
endmodule
