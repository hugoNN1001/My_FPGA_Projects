`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2025 05:54:32 PM
// Design Name: 
// Module Name: Dual_Priority_Decoder
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


module Dual_Priority_Encoder(
  input [11:0] in,  // 12-bit reg signal
  output [3:0] first, second); // first and second priority signal);
  
  localparam WIDTH = 16;
  
  wire first_priority_valid;
  wire second_priority_valid;
  wire [15:0] first_bitmask;
  wire [11:0] in_wo_first;
  
  // Find the 1st priority bit
  Priority_Encoder #(.WIDTH(WIDTH)) Priority_Encoder0 (
  .in({4'b0000, in}),
  .priority_bit(first), // first is the priority bit in binary (if priority bit = 5, first = 101)
  .valid(first_priority_valid));
  
  // Turn first into a bit mask
  Decoder_4_to_16 Decoder0(
  .in(first),
  .en(first_priority_valid),
  .out(first_bitmask));
  
  // Then we want in but with the 1st priority bit OFF
  // We XOR in with first_bitmask
  assign in_wo_first = first_bitmask[11:0] ^ in;
  
  // Find the 2nd priority bit
  Priority_Encoder #(.WIDTH(WIDTH)) Priority_Encoder1 (
  .in({4'b0000, in_wo_first}),
  .priority_bit(second),
  .valid(second_priority_valid));
endmodule
