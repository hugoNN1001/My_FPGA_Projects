`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2025 07:14:38 PM
// Design Name: 
// Module Name: BCD_Incrementor
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


module BCD_Incrementor(
  input i_Clk,
  input i_Rst,
  input i_En_Btn,
  output [3:0] o_Digit_0, o_Digit_1, o_Digit_2
  );
  
  wire Digit_0_Carry_Out;
  
  BCD_Digit_Incrementor BCD_Digit_Incrementor_Digit_0 (
  .i_Clk(i_Clk),
  .i_Rst(i_Rst),
  .i_En(i_En_Btn),
  .o_Carry_Out(Digit_0_Carry_Out),
  .o_Digit(o_Digit_0));
  
  wire Digit_1_Carry_Out;
  
  BCD_Digit_Incrementor BCD_Digit_Incrementor_Digit_1 (
  .i_Clk(i_Clk),
  .i_Rst(i_Rst),
  .i_En(Digit_0_Carry_Out), // A carry out from the prev digit is the trigger for the next digit to increment
  .o_Carry_Out(Digit_1_Carry_Out),
  .o_Digit(o_Digit_1));
  
  wire Digit_2_Carry_Out;
  
  BCD_Digit_Incrementor BCD_Digit_Incrementor_Digit_2 (
  .i_Clk(i_Clk),
  .i_Rst(i_Rst),
  .i_En(Digit_1_Carry_Out),
  .o_Carry_Out(Digit_2_Carry_Out),
  .o_Digit(o_Digit_2));
  
endmodule
