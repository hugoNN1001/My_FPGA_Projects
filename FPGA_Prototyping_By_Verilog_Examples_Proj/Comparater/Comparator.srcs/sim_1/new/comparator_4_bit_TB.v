`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2025 08:57:05 PM
// Design Name: 
// Module Name: comparator_4_bit_TB
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


module comparator_4_bit_TB();
  reg [3:0] A, B;
  wire lt, gt, eq;
  
  comparator_4_bit UUT (
  .A(A),
  .B(B),
  .lt(lt),
  .gt(gt),
  .eq(eq));
  
  initial begin
    A = 4'd12;
    B = 4'd9;
    #1;
    assert (!lt & gt & !eq)
      else $fatal("Fatal Error");
    #1;
    
    A = 4'd7;
    B = 4'd7;
    #1;
    assert (!lt & !gt & eq)
      else $fatal("Fatal Error");
    #1;
    
    A = 4'd1;
    B = 4'd15;
    #1;
    assert (lt & !gt & !eq)
      else $fatal("Fatal Error");
    #1;
    
    $display("All good!");
    $finish;
  end
endmodule
