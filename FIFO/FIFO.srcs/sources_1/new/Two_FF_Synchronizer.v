`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2026 11:53:24 AM
// Design Name: 
// Module Name: 2FF_Synchronizer
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


module Two_FF_Synchronizer #(parameter N = 8) (
  input i_clk,
  input i_rst_n,
  input [N-1:0] i_in,
  output [N-1:0] o_out
  );
  
  (* ASYNC_REG = "TRUE" *) reg [N-1:0] r_ff1,
                                       r_ff2;
  
  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      r_ff1 <= 0;
      r_ff2 <= 0;
    end
    else begin
      r_ff1 <= i_in;
      r_ff2 <= r_ff1;
    end
  end
  
  assign o_out = r_ff2;
endmodule
