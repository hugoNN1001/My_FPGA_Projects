`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2025 04:27:41 PM
// Design Name: 
// Module Name: Debounce_Project_Top
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


module Debounce_Project_Top(
    input i_Clk,
    input i_Btn_U,
    input i_Btn_R,
    input i_Btn_L,
    output o_LED_1,
    output o_LED_2,
    output o_LED_3
    );
    
    wire w_DebouncedBtn_U;
    wire w_DebouncedBtn_R;
    wire w_DebouncedBtn_L;
    
    Debounce_Filter #(.DEBOUNCE_LIMIT(1_000_000)) Debounce_Filter_Inst
    (.i_Clk(i_Clk),
     .i_BouncyBtn_U(i_Btn_U),
     .i_BouncyBtn_R(i_Btn_R),
     .i_BouncyBtn_L(i_Btn_L),
     .o_DebouncedBtn_U(w_DebouncedBtn_U),
     .o_DebouncedBtn_R(w_DebouncedBtn_R),
     .o_DebouncedBtn_L(w_DebouncedBtn_L));
    
    module top (
    input i_Clk,
    input i_Btn_U,
    input i_Btn_R,
    input i_Btn_L,
    output o_LED_1,
    output o_LED_2,
    output o_LED_3);
endmodule
