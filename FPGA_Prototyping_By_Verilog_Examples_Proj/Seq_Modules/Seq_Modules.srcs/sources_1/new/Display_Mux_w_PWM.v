`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2026 09:30:46 AM
// Design Name: 
// Module Name: Display_Mux_w_PWM
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

// There are 2 frequencies present:
// Mux Freq: 1kHz
// PWN Freq: 100MHz/16 = 6.25Mhz
// This module works as follow:
// Display_Mux cycles through each digit at 1kHz,
// During the active time of each digit, it also turns ON and OFF at 6.25Mhz
// This works to the human eyes because the PWM Freq is much higher than the Mux Freq 
module Display_Mux_w_PWM (
  input i_Clk,
  input [3:0] in0, in1, in2, in3, //// right to left LEDs
  input [3:0] i_DP_en,  // choose which decimal point to show, active high
  input [3:0] i_En, // choose which LED to show up, active high
  input [3:0] i_Duty_Cycle,
  output [6:0] o_7Segment,
  output wire o_DP,
  output wire [3:0] o_AN);
  
  wire [3:0] raw_AN;
  wire raw_DP;
  
  Display_Mux Display_Mux0 (
  .i_Clk(i_Clk),
  .in0(in0), .in1(in1), .in2(in2), .in3(in3), // right to left LEDs
  .i_DP_en(i_DP_en), // choose which decimal point to show, active high
  .i_En(i_En), // choose which LED to show up, active high
  .o_7Segment(o_7Segment),
  .o_DP(raw_DP),
  .o_AN(raw_AN));
  
  wire PWM_sig;
  
  PWM_And_LED_Dimmer PWM_And_LED_Dimmer0 (
  .i_Clk(i_Clk),
  .i_Rst(1'b0),
  .w(i_Duty_Cycle),
  .o_Q(PWM_sig));
  
  assign o_AN = PWM_sig ? raw_AN : 4'b1111;
  
  assign o_DP = PWM_sig ? raw_DP : 1'b1;

endmodule
