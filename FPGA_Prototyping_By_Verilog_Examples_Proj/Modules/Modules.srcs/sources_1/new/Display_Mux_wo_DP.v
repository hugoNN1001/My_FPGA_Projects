`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2025 11:54:21 AM
// Design Name: 
// Module Name: Display_Mux
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

// This module displays 4 binary numbers on 4 7-segment LEDs
// Use i_En to specify which LEDs should be turned on, e.g.
// i_En = 4'b0001 if the leftmost LED should be ON
module Display_Mux_wo_DP(
  input i_Clk,
  input [3:0] in0, in1, in2, in3,
  input [3:0] i_En,
  output [6:0] o_7Segment,
  output reg [3:0] o_AN);
  
  // Bit 17 has a period of 2^(17+1) = 262,144 cycles
  // 262,144/100,000,000 = 2.6ms (period in ms)
  // 2.6 * 4 = 10.4ms
  // 1/ 10.4ms = 96Hz (refresh rate)
  reg [18:0] counter = 0;
  wire [1:0] sel; 
  
  assign sel = counter [18:17];
  
  reg [3:0] binary_num;
  
  Binary_To_7Segment_wo_DP Binary_To_7Segment_wo_DP0 (
  .i_Clk(i_Clk),
  .i_Rst(1'b0),
  .i_Binary_Num(binary_num),
  .o_Segment(o_7Segment));
  
  always @(posedge i_Clk) begin
    if (counter == (2**19 - 1)) begin
      // Technically don't have to reset counter becase once it
      // hits the limit it will wrap around to 0.
      counter <= 0;
    end 
    else begin
      counter <= counter + 1;
    end
  end
  
  always @(*) begin
    case (sel)
      2'b00: begin
        binary_num = in0;
        o_AN = i_En[0] ? 4'b1110 : 4'b1111;  // right most LED
      end
      2'b01: begin
        binary_num = in1;
        o_AN = i_En[1] ? 4'b1101 : 4'b1111;
      end
      2'b10: begin 
        binary_num = in2;
        o_AN = i_En[2] ? 4'b1011 : 4'b1111;  
      end
      2'b11: begin 
        binary_num = in3;
        o_AN = i_En[3] ? 4'b0111 : 4'b1111;  // left most LED
      end
    endcase    
  end
endmodule
