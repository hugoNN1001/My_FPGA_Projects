`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2025 04:24:40 PM
// Design Name: 
// Module Name: Multifunctional_Barrel_Shifter_TB
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


module Multifunctional_Barrel_Shifter_TB();

  reg [7:0] a = 8'b0;
  reg [2:0] amt = 3'b0;
  reg lr = 1; // left
  wire [7:0] y;
  
  Multifunctional_Barrel_Shifter UUT (
  .a(a),
  .amt(amt),
  .lr(lr),
  .y(y));
  
  initial begin
    #1;
    a = 8'b11010110;
    amt = 3'd3;
    lr = 1'b1;
    #1;
    assert (y == 8'b10110110) 
      else $fatal("Error");
      
    #1;
    a = 8'b11010110;
    amt = 3'd4;
    lr = 1'b0;
    #1;
    assert (y == 8'b01101101) 
      else $fatal("Error");
      
    $display("No Errors");
  end
endmodule
