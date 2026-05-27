`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2025 06:24:32 PM
// Design Name: 
// Module Name: Priority_Encoder_16
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


module Priority_Encoder #(parameter WIDTH = 16)(
  input [WIDTH-1:0] in,
  output reg [$clog2(WIDTH)-1:0] priority_bit,
  output reg valid);
  
  integer i;
  reg [$clog2(WIDTH)-1:0] curr_priority_bit;
    
  always @(*) begin 
    // The default of curr_priority_bit is 0
    curr_priority_bit = 0;
    valid = 0;
    
    for (i=0; i < WIDTH; i=i+1) begin
      if (in[i]) begin
        curr_priority_bit = i;
        valid = 1;
      end
    end
    
    priority_bit = curr_priority_bit;
  end
endmodule
