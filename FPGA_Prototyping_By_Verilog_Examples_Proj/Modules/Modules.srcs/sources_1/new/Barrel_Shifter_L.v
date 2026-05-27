`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2025 06:28:57 PM
// Design Name: 
// Module Name: Barrel_Shifter
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


module Barrel_Shifter_L(
  input [7:0] a,
  input [2:0] amt,
  output wire [7:0] y);
  
  // Barrel shifting is performed in stages
  wire [7:0] s0, s1;
  
  // Stage 1: Rotate left 0 or 1 bit
  assign s0 = amt[0] ? {a[6:0], a[7]} : a;
  // Stage 2: Rotate left 0 or 2 bits
  assign s1 = amt[1] ? {s0[5:0], s0[7:6]} : s0;
  // stage 3: Rotate left 0 or 4 bits
  assign y = amt[2] ? {s1[3:0], s1[7:4]} : s1;
endmodule
