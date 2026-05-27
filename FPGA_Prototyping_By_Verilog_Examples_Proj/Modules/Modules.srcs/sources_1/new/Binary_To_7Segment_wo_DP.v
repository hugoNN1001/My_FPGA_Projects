`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 04:19:44 PM
// Design Name: 
// Module Name: Binary_To_7Segment
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: sync rst, Common anode: 0 - segment ON
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Binary_To_7Segment_wo_DP (
  input i_Clk,
  input i_Rst,
  input [3:0] i_Binary_Num,
  output [6:0] o_Segment
  );
  
  reg [6:0] r_Hex_Encoding;
  // a 6-bit number where the bit 0 - segment G
  //                          bit 1 - segment F
  //                          bit 2 - segment E
  //                          bit 3 - segment D
  //                          bit 4 - segment C
  //                          bit 5 - segment B
  //                          bit 6 - segment A
  
  always @(posedge i_Clk) begin // replace 
    if (i_Rst) begin
      r_Hex_Encoding <= 7'h00;
    end
    else begin
      case (i_Binary_Num)
        4'b0000 : r_Hex_Encoding <= 7'h7E;  // 7'b1111110
        4'b0001 : r_Hex_Encoding <= 7'h30;  // 7'b0110000
        4'b0010 : r_Hex_Encoding <= 7'h6D;  // 7'b1101101
        4'b0011 : r_Hex_Encoding <= 7'h79;  // 7'b1111001
        4'b0100 : r_Hex_Encoding <= 7'h33;  // 7'b0110011         
        4'b0101 : r_Hex_Encoding <= 7'h5B;  // etc.
        4'b0110 : r_Hex_Encoding <= 7'h5F;  
        4'b0111 : r_Hex_Encoding <= 7'h70;  
        4'b1000 : r_Hex_Encoding <= 7'h7F;  
        4'b1001 : r_Hex_Encoding <= 7'h7B;  
        4'b1010 : r_Hex_Encoding <= 7'h77;
        4'b1011 : r_Hex_Encoding <= 7'h1F;
        4'b1100 : r_Hex_Encoding <= 7'h4E;
        4'b1101 : r_Hex_Encoding <= 7'h3D;
        4'b1110 : r_Hex_Encoding <= 7'h4F;
        4'b1111 : r_Hex_Encoding <= 7'h47;
        default : r_Hex_Encoding <= 7'h00;
      endcase
    end
  end
  
  assign o_Segment[0] = ~r_Hex_Encoding[6];
  assign o_Segment[1] = ~r_Hex_Encoding[5];
  assign o_Segment[2] = ~r_Hex_Encoding[4];
  assign o_Segment[3] = ~r_Hex_Encoding[3];
  assign o_Segment[4] = ~r_Hex_Encoding[2];
  assign o_Segment[5] = ~r_Hex_Encoding[1];
  assign o_Segment[6] = ~r_Hex_Encoding[0];
  
endmodule 
