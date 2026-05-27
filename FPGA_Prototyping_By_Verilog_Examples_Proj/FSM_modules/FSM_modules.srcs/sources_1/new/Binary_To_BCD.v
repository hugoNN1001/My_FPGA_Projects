`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2026 10:09:41 AM
// Design Name: 
// Module Name: Binary_To_BCD
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

// This module converts an N-bit binary number into its BCD equivalent
// used to display any binary numbers on a 7-segment display.
// It uses the double dabble algorithm (https://en.wikipedia.org/wiki/Double_dabble)
// The limit of 5 is chosen because 4 shifted left is 8, which is representable
// in BCD format, but 5 shifted left is 10, which is not representable.
// So if the number is 5, we add 3 so it's 8 and then shift left so it's 16 (1|0000),
// which will make the current BCD 0 and carry a 1 to the next BCD.
// Note: check first before shiting.
module Binary_To_BCD #(parameter N = 16) (
  input i_Rst,
  input [N-1:0] i_Binary_Num,
  output reg [4*ceil_div(N,3)-1:0] o_BCD);
  
  // Function to divide and that the ceiling value
  function integer ceil_div;
    input integer dividend;
    input integer divisor;
    begin
      // Algo to divide and take the ceiling value
      ceil_div = (dividend + divisor - 1) / divisor;
    end
  endfunction 
  
  // Create a sratch space of width N + 4*ceil(N/3) to perform double dabble
  // N to hold i_Binary_Num, 4*ceil(N/3) to hold o_BCD
  reg [N + 4*ceil_div(N,3)-1:0] r_Scratch_Space;
  
  // Define a loop variable
  integer i;
  integer j;
  
  // Perform double dabble
  always @(*) begin
    r_Scratch_Space = i_Binary_Num;
    
    for (i = 0; i < N; i = i+1) begin
      // Loop N times
      
      for (j = 0; j < ceil_div(N,3); j = j+1) begin
        // Loop X = ceil_div(N,3) = number of BCD digits out
        if (r_Scratch_Space[N+j*4 +: 4] >= 5) begin
          r_Scratch_Space[N+j*4 +: 4] = r_Scratch_Space[N+j*4 +: 4] + 3;
        end
        // This else block is not needed
        // else r_Scratch_Space[N+j*4 +: 4] = r_Scratch_Space[N+j*4 +: 4];
      end
      
      r_Scratch_Space = r_Scratch_Space << 1;
    end
    
    o_BCD = r_Scratch_Space[N + 4*ceil_div(N,3)-1:N];
  end
endmodule
