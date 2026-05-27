`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2025 08:21:25 AM
// Design Name: 
// Module Name: Decoder_3_to_8
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


module Decoder_3_to_8(
  input [2:0] in,
  input en,
  output [7:0] out);
  
  Decoder_2_to_4 Decoder_0 (.in(in[1:0]), .en(en & !in[2]), .out(out[3:0]));
  Decoder_2_to_4 Decoder_1 (.in(in[1:0]), .en(en & in[2]), .out(out[7:4]));
endmodule
