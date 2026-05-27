`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2025 03:59:25 PM
// Design Name: 
// Module Name: Multifunctional_Barrel_Shifter
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


module Multifunctional_Barrel_Shifter(
  input [7:0] a,
  input [2:0] amt,
  input lr,
  output reg [7:0] y);
  
  wire [7:0] rshift_out;
  wire [7:0] lshift_out;
  
  // Rotate right
  Barrel_Shifter_R Barrel_Shifter_R0 (
  .a(a),
  .amt(amt),
  .y(rshift_out));
  
  // Rotate left
  Barrel_Shifter_L Barrel_Shifter_L0 (
  .a(a),
  .amt(amt),
  .y(lshift_out));

  always @(*) begin
    if (lr) begin
      // Rotate left
      y = lshift_out;
    end
    else begin
      // Rotate right
      y = rshift_out;
    end
  end
  
endmodule
