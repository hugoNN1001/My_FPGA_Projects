`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2026 08:49:56 PM
// Design Name: 
// Module Name: Binary_To_BCD_Tester
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

// 2-digit Binary_To_BCD_Tester 
// Can represent numbers 0-15 in BCD (2 digits)
// Note: Debouncing is not implemented
module Binary_To_BCD_Tester  #(parameter N = 4) (
  input i_Clk,
  input i_Rst,
  input [N-1:0] i_Binary_Num,
  output [6:0] o_7Segment,
  output [3:0] o_AN);
  
  // Function to divide and that the ceiling value
  function integer ceil_div;
    input integer dividend;
    input integer divisor;
    begin
      // Algo to divide and take the ceiling value
      ceil_div = (dividend + divisor - 1) / divisor;
    end
  endfunction 
  
  wire [4*ceil_div(N,3)-1:0] w_BCD;
  
  Binary_To_BCD #(.N(N)) UUT (
  .i_Rst(i_Rst),
  .i_Binary_Num(i_Binary_Num),
  .o_BCD(w_BCD));
  
  Display_Mux_wo_DP Display_Mux_wo_DP0 (
  .i_Clk(i_Clk),
  .in0(w_BCD[3:0]), // hard-coded
  .in1(w_BCD[7:4]), // hard-coded
  .in2(), 
  .in3(),
  .i_En(4'b0011),
  .o_7Segment(o_7Segment),
  .o_AN(o_AN));
endmodule
