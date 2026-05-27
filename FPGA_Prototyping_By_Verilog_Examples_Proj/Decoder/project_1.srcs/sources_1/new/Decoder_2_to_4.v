`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2025 08:05:51 AM
// Design Name: 
// Module Name: Decoder_2_to_4
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


module Decoder_2_to_4(
  input [1:0] in,
  input en,
  output [3:0] out);
  
  assign out[0] = en & (!in[0]) & (!in[1]);
  assign out[1] = en & (!in[0]) & in[1];
  assign out[2] = en & in[0] & (!in[1]);
  assign out[3] = en & in[0] & in[1];
  
  // Compact way
//  assign out = en ? (4'b0001 << in) : 4'b0000;
endmodule
