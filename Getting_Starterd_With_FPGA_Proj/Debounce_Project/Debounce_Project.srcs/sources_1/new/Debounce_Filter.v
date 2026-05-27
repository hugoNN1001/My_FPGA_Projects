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
// Or look at it another way:
// Cllk runs from 0 to 100_000_000 cycles in 1s
// so in 10ms it will run from 0 to 1_000_000 
  module Debounce_Filter #(parameter DEBOUNCE_LIMIT = 1_000_000) (
    input i_Clk,
    input i_BouncyBtn,
    output o_DebouncedBtn_Level,
    output o_DebouncedBtn_Pulse
    );
    
    reg [$clog2(DEBOUNCE_LIMIT)-1:0] r_Count = 0; // a register to contain DEBOUNCE_LIMIT in binary
    reg r_Btn = 1'b0;
    
    // For rising edge detection
    reg r_Btn_d = 1'b0;
    
    always @(posedge i_Clk) begin
        // UP Button
        if (i_BouncyBtn != r_Btn && r_Count < DEBOUNCE_LIMIT-1) begin
            r_Count <= r_Count + 1;
        end
        else if (r_Count == DEBOUNCE_LIMIT-1) begin
            r_Btn <= i_BouncyBtn;
            r_Count <= 0;
        end
        else begin
            r_Count <= 0;
        end
     end
     
     always @(posedge i_Clk) begin
        r_Btn_d <= r_Btn;
     end

     assign o_DebouncedBtn_Level = r_Btn;
     // For rising edge detection
     // Output is a 1-clk-cycle pulse
     assign o_DebouncedBtn_Pulse = r_Btn & ~r_Btn_d;
     
endmodule
