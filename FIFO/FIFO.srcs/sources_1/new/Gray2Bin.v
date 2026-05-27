`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2026 09:48:20 PM
// Design Name: 
// Module Name: Gray2Bin
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


module Gray2Bin #(parameter N = 8) (
  input [N-1:0]   i_gray,
  output [N-1:0]  o_bin
  );
  
  assign o_bin[N-1] = i_gray[N-1];
  
  genvar i;
  generate
    for (i = N-2; i >= 0; i = i - 1) begin
      assign o_bin[i] = o_bin[i+1] ^ i_gray[i];
    end
  endgenerate
endmodule
