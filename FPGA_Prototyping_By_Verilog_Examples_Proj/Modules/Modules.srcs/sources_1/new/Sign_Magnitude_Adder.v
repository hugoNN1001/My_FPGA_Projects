`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2025 10:57:54 AM
// Design Name: 
// Module Name: Sign_Magnitude_Adder
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


module Sign_Magnitude_Adder #(parameter N = 4) (
  input [N-1:0] a, b,
  output reg [N:0] sum);
  
  wire [N-2:0] mag_a, mag_b;
  reg [N-2:0] mag_max, mag_min;
  reg sign_max, sign_min;
  reg [N-1:0] temp_sum; // Used as the sum for mag_max + mag_min
  
  // Assign magnitude
  assign mag_a = a[N-2:0];
  assign mag_b = b[N-2:0];
  
  always @(*) begin
    if (mag_a > mag_b) begin
      mag_max = mag_a;
      mag_min = mag_b;
      sign_max = a[N-1];
      sign_min = b[N-1];
    end 
    else begin
      mag_max = mag_b;
      mag_min = mag_a;
      sign_max = b[N-1];
      sign_min = a[N-1];
    end
    
    temp_sum = (sign_max == sign_min) ? 
          {1'b0, mag_max} + {1'b0, mag_min} : 
          {1'b0, mag_max} - {1'b0, mag_min};
          
    if (temp_sum == 0) begin
      // Prevent negative 0 conditioni, i.e. 1001 (-1) + 0001 (+1) = 0
      sum = 0;
    end
    else begin
      sum = {sign_max, temp_sum};
    end
  end
endmodule
