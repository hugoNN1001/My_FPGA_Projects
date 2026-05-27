`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2025 10:39:59 AM
// Design Name: 
// Module Name: Dual_Priority_Encoder_TB
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


module Dual_Priority_Encoder_TB();
  reg [11:0] in;
  wire [3:0] first, second;
  
  Dual_Priority_Encoder UUT (
  .in(in),
  .first(first),
  .second(second));
  
  initial begin
    #1;
    in = 12'b000_100_000_010;
    #10;
    assert (first == 4'd8 && second == 4'd1) else
      $fatal("Error. Expected first = 9 and second = 2 but got first = %d and second = %d", first, second);
      
    #1;
    in = 12'b010_000_111_110;
    #10;
    assert (first == 4'd10 & second == 4'd5) else
      $fatal("Error. Expected first = 11 and second = 6 but got first = %d and second = %d", first, second);
    
    #1;
    $display("Successful!");
  end
endmodule
