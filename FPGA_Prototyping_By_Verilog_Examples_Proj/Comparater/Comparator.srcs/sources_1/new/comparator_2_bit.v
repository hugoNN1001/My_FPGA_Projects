`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:10:51 PM
// Design Name: 
// Module Name: greater_than_4_bit
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


module comparator_2_bit (
  input [1:0] A, B,
  output lt, gt, eq
  );
  
  wire w_lt_LSB, w_lt_MSB;
  wire w_gt_LSB, w_gt_MSB;
  wire w_eq_LSB, w_eq_MSB;
  
  
  comparator_1_bit cmp_LSB (.A(A[0]), .B(B[0]), .lt(w_lt_LSB), .gt(w_gt_LSB), .eq(w_eq_LSB));
  comparator_1_bit cmp_MSB (.A(A[1]), .B(B[1]), .lt(w_lt_MSB), .gt(w_gt_MSB), .eq(w_eq_MSB));
  
  assign lt =  w_lt_MSB | (w_eq_MSB & w_lt_LSB);
  assign gt =  w_gt_MSB | (w_eq_MSB & w_gt_LSB);
  assign eq =  w_eq_MSB & w_eq_LSB;
  
endmodule
