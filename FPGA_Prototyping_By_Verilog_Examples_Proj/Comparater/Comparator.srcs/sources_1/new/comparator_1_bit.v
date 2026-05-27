`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 06:33:42 PM
// Design Name: 
// Module Name: greater_than_circuit
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


module comparator_1_bit (
  input A, B,
  output lt, gt, eq
  );
  
  assign lt = (!A) & B;
  assign gt = A & (!B);
  assign eq = (A & B) | (!A & !B);
endmodule
