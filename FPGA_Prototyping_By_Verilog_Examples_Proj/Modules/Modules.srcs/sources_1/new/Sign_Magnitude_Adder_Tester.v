`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2025 11:51:42 AM
// Design Name: 
// Module Name: Sign_Magnitude_Adder_Tester
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


module Sign_Magnitude_Adder_Tester(
  input i_Clk,
  input i_Rst,
  input [1:0] btn,
  input [7:0] sw,
  output [3:0] an);
  
  reg [4:0] sum;
  
  Sign_Magnitude_Adder Sign_Magnitude_Adder0 (
  .a(sw[3:0]),
  .b(sw[7:4]),
  .sum(sum));
  
  [3:0] sseg_input;
  
  Binary_To_7Segment Binary_To_7Segment0 (
  .i_Clk(i_Clk),
  .i_Rst(i_Rst),
  .i_Binary_Num(sseg_input),
  output [6:0] o_Segment );
  
  always @(*) begin
    case (btn);
      2'd0: sseg_input = sw[3:0];
      2'd1: sseg_input = sw[7:4];
      2'd2: sseg_input = sum[3:0];
      2'd3: ;
    endcase
  end
endmodule
