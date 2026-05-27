`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 04:07:05 PM
// Design Name: 
// Module Name: bin2gray
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: There are two ways to code a bin2gray. The one
// implemented here synthesizes to only logic gates (as opposed
// to a shift register), leading to better efficiency.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Bin2Gray #(parameter N = 8) (
  input [N-1:0] i_bin,
  output [N-1:0] o_gray
  );
  
  genvar i;
  generate
    for (i = 0; i < N-1; i = i + 1) begin
      assign o_gray[i] = i_bin[i] ^ i_bin[i+1];
    end
  endgenerate
  
  assign o_gray[N-1] = i_bin[N-1];
endmodule
