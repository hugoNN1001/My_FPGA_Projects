`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2025 08:32:57 AM
// Design Name: 
// Module Name: Decoder_4_to_16
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


module Decoder_4_to_16(
  input [3:0] in,
  input en,
  output [15:0] out);
  
  wire en0, en1, en2, en3;
  
  Decoder_2_to_4 Decoder_en (.in(in[3:2]), .en(en), .out({en3, en2, en1, en0}));
  Decoder_2_to_4 Decoder_0 (.in(in[1:0]), .en(en0), .out(out[3:0]));
  Decoder_2_to_4 Decoder_1 (.in(in[1:0]), .en(en1), .out(out[7:4]));
  Decoder_2_to_4 Decoder_2 (.in(in[1:0]), .en(en2), .out(out[11:8]));
  Decoder_2_to_4 Decoder_3 (.in(in[1:0]), .en(en3), .out(out[15:12]));
endmodule
