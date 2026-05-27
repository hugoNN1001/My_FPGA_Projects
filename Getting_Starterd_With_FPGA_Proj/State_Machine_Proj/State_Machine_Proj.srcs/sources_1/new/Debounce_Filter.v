`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2025 02:37:29 PM
// Design Name: 
// Module Name: Debounce_Filter
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

// 1 period = 1/f = 1/100Mhz = 10ns
// want to debounce for 10ms -> 10ms/10ns = 1,000,000
  module Debounce_Filter #(parameter DEBOUNCE_LIMIT = 1_000_000) (
    input i_Clk,
    input i_Bouncy,
    output o_Debounced_Level,
    output o_Debounced_Pulse
    );
    
    reg [$clog2(DEBOUNCE_LIMIT)-1:0] r_Count = 0; // a register to contain DEBOUNCE_LIMIT in binary
    reg r_State = 1'b0;
   
   // Double-flop i_Bouncy since it's an async input, might case metastability
   reg r_Bouncy_Sync1;
   reg r_Bouncy_Sync2;
   
   always @(posedge i_Clk) begin
      r_Bouncy_Sync1 <= i_Bouncy;
      r_Bouncy_Sync2 <= r_Bouncy_Sync1;
   end
   
    always @(posedge i_Clk) begin
        // UP Button
        if (r_Bouncy_Sync2 !== r_State && r_Count < DEBOUNCE_LIMIT-1) begin
            r_Count <= r_Count + 1;
        end
        else if (r_Count == DEBOUNCE_LIMIT-1) begin
            r_State <= r_Bouncy_Sync2;
            r_Count <= 0;
        end
        else begin
            r_Count <= 0;
        end
     end
     
     // For edge detection
    reg r_State_d = 1'b0;
    
    always @(posedge i_Clk) begin
      r_State_d <= r_State;
    end

     assign o_Debounced_Level = r_State;
     assign o_Debounced_Pulse = r_State & ~r_State_d;
endmodule
