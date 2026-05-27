`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2026 02:07:23 PM
// Design Name: 
// Module Name: Parking_Lot_Counter
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


module Parking_Lot_Counter(
  input i_Clk,
  input i_Rst,
  input i_LS_A, i_LS_B,
  output [6:0] o_7Segment,
  output [3:0] o_AN);
  
  wire w_Enter, w_Exit;
  
  Parking_Lot_FSM Parking_Lot_FSM0(
  .i_Clk(i_Clk),
  .i_Rst(i_Rst),
  .i_LS_A(i_LS_A), 
  .i_LS_B(i_LS_B), // LS: light sensor
  .o_Enter(w_Enter), 
  .o_Exit(w_Exit)
  );
  
  Display_Mux_wo_DP Display_Mux_wo_DP0 (
  .i_Clk(),
  .in0(), 
  .in1(), 
  .in2(), 
  .in3(),
  .i_En(),
  .o_7Segment(),
  .o_AN());
endmodule
