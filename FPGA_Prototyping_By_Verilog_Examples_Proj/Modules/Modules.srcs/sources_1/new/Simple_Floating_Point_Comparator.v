`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2025 11:34:31 AM
// Design Name: 
// Module Name: Simple_Floating_Point_Comparator
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


module Simple_Floating_Point_Comparator(
  input [12:0] a, b,
  output reg gt, lt, eq);
  
  wire [11:0] mag_a = a[11:0];  //{exp_a, frac_a}
  wire [11:0] mag_b = b[11:0];  //{exp_b, frac_b}
  
  wire sign_a = a[12];
  wire sign_b = b[12];
  
  always @(*) begin
    if (sign_a == 0 && sign_b == 0) begin
      // Both a & b are positive
      gt = (mag_a > mag_b) ? 1 : 0;
      lt = (mag_a < mag_b) ? 1 : 0;
      eq = (mag_a == mag_b) ? 1 : 0;
    end
    else if (sign_a == 1 && sign_b == 0) begin
      // a is negative, b is positive
      gt = 0;
      lt = 1;
      eq = 0;
    end 
    else if (sign_a == 0 && sign_b == 1) begin
      // a is positive, b is negative
      gt = 1;
      lt = 0;
      eq = 0;
    end
    else begin
      // Both a & a are negative
      gt = (mag_a < mag_b) ? 1 : 0;
      lt = (mag_a > mag_b) ? 1 : 0;
      eq = (mag_a == mag_b) ? 1 : 0;
    end
  end
endmodule
