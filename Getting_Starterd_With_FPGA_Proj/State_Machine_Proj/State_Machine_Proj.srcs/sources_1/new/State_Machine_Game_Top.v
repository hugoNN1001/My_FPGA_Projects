`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 07:13:42 PM
// Design Name: 
// Module Name: State_Machine_Game_Top
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


module State_Machine_Game_Top #(parameter GAME_LIMIT = 9) (
  input i_Clk,
  input i_Rst,
  input i_Switch_1,
  input i_Switch_2,
  input i_Switch_3,
  input i_Switch_4,
  
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4,
//  output o_LED_5,
//  output o_LED_6,
//  output o_LED_7,
//  output o_LED_8,
//  output o_LED_9,
//  output o_LED_10,
  
  // 7-segment display
  output o_Segment_A,
  output o_Segment_B,
  output o_Segment_C,
  output o_Segment_D,
  output o_Segment_E,
  output o_Segment_F,
  output o_Segment_G,
  // 7-segment digit enables (anodes, active-low)
  output [3:0] o_AN
  );
  
  localparam DEBOUNCE_LIMIT = 1_000_000; // debounce for 10ms
  
  wire w_Debounced_Rst;
  Debounce_Filter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) Debounce_Rst_Inst
  (.i_Clk(i_Clk),
   .i_Bouncy(i_Rst),
   .o_Debounced_Level(w_Debounced_Rst),  // State_Machine_Game module looks for FE so level is used
   .o_Debounced_Pulse()); // leave unconnected
   
  wire w_Debounced_S1;
  Debounce_Filter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) Debounce_S1_Inst
  (.i_Clk(i_Clk),
   .i_Bouncy(i_Switch_1),
   .o_Debounced_Level(w_Debounced_S1),  // State_Machine_Game module looks for FE so level is used
   .o_Debounced_Pulse()); // leave unconnected
   
  wire w_Debounced_S2;
  Debounce_Filter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) Debounce_S2_Inst
  (.i_Clk(i_Clk),
   .i_Bouncy(i_Switch_2),
   .o_Debounced_Level(w_Debounced_S2),  // State_Machine_Game module looks for FE so level is used
   .o_Debounced_Pulse()); // leave unconnected
   
  wire w_Debounced_S3;
  Debounce_Filter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) Debounce_S3_Inst
  (.i_Clk(i_Clk),
   .i_Bouncy(i_Switch_3),
   .o_Debounced_Level(w_Debounced_S3),  // State_Machine_Game module looks for FE so level is used
   .o_Debounced_Pulse()); // leave unconnected
   
  wire w_Debounced_S4;
  Debounce_Filter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) Debounce_S4_Inst
  (.i_Clk(i_Clk),
   .i_Bouncy(i_Switch_4),
   .o_Debounced_Level(w_Debounced_S4),  // State_Machine_Game module looks for FE so level is used
   .o_Debounced_Pulse()); // leave unconnected

  localparam COUNT_LIMIT = 100_000_000;
     
  wire [3:0] w_Score;
  wire w_LED_1, w_LED_2, w_LED_3, w_LED_4, w_LED_5, w_LED_6, w_LED_7, w_LED_8;

  State_Machine_Game #(.COUNT_LIMIT(COUNT_LIMIT/4), // Make game faster, LEDs toggle twice/sec
                       .GAME_LIMIT(GAME_LIMIT))State_Machine_Game_Inst 
  (.i_Clk(i_Clk),
  .i_Rst(w_Debounced_Rst),
  .i_Switch_1(w_Debounced_S1),
  .i_Switch_2(w_Debounced_S2),
  .i_Switch_3(w_Debounced_S3),
  .i_Switch_4(w_Debounced_S4),
  .o_Score(w_Score),
  .o_LED_1(w_LED_1),
  .o_LED_2(w_LED_2),
  .o_LED_3(w_LED_3),
  .o_LED_4(w_LED_4)
//  .o_LED_5(w_LED_5),
//  .o_LED_6(w_LED_6),
//  .o_LED_7(w_LED_7),
//  .o_LED_8(w_LED_8),
//  .o_LED_9(w_LED_9),
//  .o_LED_10(w_LED_10)
  );
  
  wire w_Segment_A, w_Segment_B, w_Segment_C, w_Segment_D,
       w_Segment_E, w_Segment_F, w_Segment_G;
       
  Binary_To_7Segment Display_Inst 
  (.i_Clk(i_Clk),
  .i_Rst(w_Debounced_Rst),
  .i_Binary_Num(w_Score),
  .o_Segment_A(w_Segment_A),
  .o_Segment_B(w_Segment_B),
  .o_Segment_C(w_Segment_C),
  .o_Segment_D(w_Segment_D),
  .o_Segment_E(w_Segment_E),
  .o_Segment_F(w_Segment_F),
  .o_Segment_G(w_Segment_G));
  
  assign o_LED_1 = w_LED_1;
  assign o_LED_2 = w_LED_2;
  assign o_LED_3 = w_LED_3;
  assign o_LED_4 = w_LED_4;
//  assign o_LED_5 = w_LED_5;
//  assign o_LED_6 = w_LED_6;
//  assign o_LED_7 = w_LED_7;
//  assign o_LED_8 = w_LED_8;
//  assign o_LED_9 = w_LED_9;
//  assign o_LED_10 = w_LED_10;
  
  // No need to invert again, already done in 7-segment display module
  assign o_Segment_A = w_Segment_A;
  assign o_Segment_B = w_Segment_B;
  assign o_Segment_C = w_Segment_C;
  assign o_Segment_D = w_Segment_D;
  assign o_Segment_E = w_Segment_E;
  assign o_Segment_F = w_Segment_F;
  assign o_Segment_G = w_Segment_G;
  
  // 7-segment digit enables (anodes, active-low)
  assign o_AN = 4'b1110;
   
endmodule
