`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 03:25:39 PM
// Design Name: 
// Module Name: simple_480p
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


module Simple_480p(
  input wire logic i_clk_pix,       // pixel clock
  input wire logic i_rst_pix,       // pixel reset
  output logic [9:0] o_sx,          // horizontal screen position
  output logic [9:0] o_sy,          // vertical screen position
  output logic o_hsync,             // horizontal sync
  output logic o_vsync,             // vertical sync
  output logic o_data_en);          // draw data enable
  
  // Horizontal timings
  parameter HA_END = 639;           // end of active pixels
  parameter HS_START = HA_END + 16; // start of sync after front porch
  parameter HS_END = HS_START + 96; // end of sync
  parameter LINE_END = 799;         // last pixel on line (after back porch)
  
  // Vertical timings
  parameter VA_END = 479;           // end of active pixcels
  parameter VS_START = VA_END + 10; // start of sync after front portch
  parameter VS_END = VS_START + 2;  // end of sync
  parameter FRAME_END = 524;        // last line on frame (after back porch)  
  
  always_comb begin
    o_hsync = ~(o_sx >= HS_START && o_sx < HS_END);  // active low
    o_vsync = ~(o_sy >= VS_START && o_sy < VS_END);  // active low
    o_data_en = (o_sx <= HA_END && o_sy <= VA_END);
  end  
  
  always_ff @(posedge i_clk_pix) begin
    if (i_rst_pix) begin
      o_sx <= 0;
      o_sy <= 0;
    end
    else if (o_sx == LINE_END) begin
      o_sx <= 0;
      o_sy <= (o_sy == FRAME_END) ? 0 : o_sy + 1; 
    end
    else begin
      o_sx <= o_sx + 1;
    end
  end
endmodule
