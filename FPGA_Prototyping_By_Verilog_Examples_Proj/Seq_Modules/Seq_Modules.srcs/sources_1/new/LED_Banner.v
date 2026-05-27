`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2026 07:04:10 PM
// Design Name: 
// Module Name: LED_Banner
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


module LED_Banner(
  input i_Clk,
  input i_Rst,
  input i_En,
  input i_Dir,  // 1: rotate right; 0: rotate left
  input [39:0] i_BCD_Num, // Takes 10 BCD numbers as inputs
  output [6:0] o_7Segment,
  output [3:0] o_AN);
  
  localparam CLK_FREQ = 100_000_000;
  localparam TARGET_FREQ = 2; 
  localparam COUNT = CLK_FREQ / TARGET_FREQ;
  
  // Separating the inputs
  // There are 10 BCD inputs but 14 are created to create the "slide window" effect
  // BCD_num = _  _  _  _  0  1  2  3  4  5   6  7   8    9   _   _   _   _
  //          [0][1][2][3][4][5][6][7][8][9][10][11][12][13][14][15][16][17]
  wire [3:0] BCD_num [17:0];
  
  genvar i;
  generate
    for (i = 0; i < 18; i = i + 1) begin : ARRAY_SIGN
      if (i < 4)
        assign BCD_num[i] = 4'b0000;
      else if (i < 14) 
        assign BCD_num[i] = i_BCD_Num[(i-4)*4 +: 4];
      else 
        assign BCD_num[i] = 4'b0000;
    end
  endgenerate
  
  // Pad the ramaining spots with zeros to create the "slide window" effect
  
  // Trasition counter
  reg [$clog2(COUNT)-1:0] r_trans_counter;
  reg r_trans_tick;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      r_trans_counter <= 0;
      r_trans_tick <= 1'b0;
    end
    
    if (r_trans_counter == COUNT - 1) begin
      r_trans_counter <= 0;
      r_trans_tick <= 1'b1;
    end
    else begin
      r_trans_counter <= r_trans_counter + 1;
      r_trans_tick <= 1'b0;
    end
  end
  //////////////////////////////
  
  reg [3:0] in0, in1, in2, in3;
  reg [3:0] En;
  
  Display_Mux Display_Mux0 (
  .i_Clk(i_Clk),
  .in0(in0), // rightmost LED
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .i_DP_en(4'b0000), // choose which decimal point to show, active high
  .i_En(En), // choose which LED to show up, active high
  .o_7Segment(o_7Segment),
  .o_DP(),
  .o_AN(o_AN));
  
  reg [4:0] r_offset;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      if (!i_Dir) begin
        // Rotate left
        r_offset <= 5'd0;
      end
      else begin
        // Rotate right
        r_offset <= 5'd14;
      end
    end 
    else if (r_trans_tick && i_En) begin 
      if (!i_Dir) begin
        // Rotate left
        r_offset <= (r_offset == 5'd14) ? 5'd0 : r_offset + 1'b1;
      end 
      else begin
        // Rotate right
        r_offset <= (r_offset == 5'd0) ? 5'd14 : r_offset - 1'b1;
      end
    end
  end
  
  always @(*) begin
      // The r_offset value below is the value sampled before it's incremented
      // Safeguard against r_offset + n exceeds 17
      in0 = BCD_num[r_offset];
      in1 = (r_offset + 1 > 17) ? BCD_num[r_offset + 1 - 18] : BCD_num[r_offset + 1];
      in2 = (r_offset + 2 > 17) ? BCD_num[r_offset + 2 - 18] : BCD_num[r_offset + 2];
      in3 = (r_offset + 3 > 17) ? BCD_num[r_offset + 3 - 18] : BCD_num[r_offset + 3];
      
    if (!i_Dir) begin
      // Rotate left
      case (r_offset)
        5'd11: En = 4'b1110;
        5'd12: En = 4'b1100;
        5'd13: En = 4'b1000;
        5'd14: En = 4'b0000;
        default: En = 4'b1111;
      endcase
    end
    else begin
      // Rotate right
      case (r_offset) 
        5'd3: En = 4'b0111;
        5'd2: En = 4'b0011;
        5'd1: En = 4'b0001;
        5'd0: En = 4'b0000;
        default: En = 4'b1111;
      endcase
    end 
  end
endmodule
