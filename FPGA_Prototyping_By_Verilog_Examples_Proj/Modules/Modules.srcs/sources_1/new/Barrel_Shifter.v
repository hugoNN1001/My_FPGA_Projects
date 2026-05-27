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


module Barrel_Shifter_R(
  input [7:0] a,
  input [2:0] amt,
  output wire [7:0] y);
  
//  always @(*) begin
//    case (amt)
//      3'd0: y = a;
//      3'd1: y = {a[0], a[7:1]};
//      3'd2: y = {a[1:0], a[7:2]};
//      3'd3: y = {a[2:0], a[7:3]};
//      3'd4: y = {a[3:0], a[7:4]};
//      3'd5: y = {a[4:0], a[7:5]};
//      3'd6: y = {a[5:0], a[7:6]};
//      3'd7: y = {a[6:0], a[7]};
//      default: y = a; // if invalid shift amt, do not shift
//    endcase
//  end
  
  // Alternatively, barrel shifting is performed in stages
  wire [7:0] s0, s1;
  
  // Stage 1: Rotate right 0 or 1 bit
  assign s0 = amt[0] ? {a[0], a[7:1]} : a;
  // Stage 2: Rotate right 0 or 2 bits
  assign s1 = amt[1] ? {s0[1:0], s0[7:2]} : s0;
  // stage 3: Rotate right 0 or 4 bits
  assign y = amt[2] ? {s1[3:0], s1[7:4]} : s1;
endmodule
