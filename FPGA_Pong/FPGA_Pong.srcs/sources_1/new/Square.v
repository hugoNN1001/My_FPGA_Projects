`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 10:24:34 AM
// Design Name: 
// Module Name: Square
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
`default_nettype none

module Square(  
  input wire i_sysclk,
  input wire i_rst_n,
  output logic vga_hsync,
  output logic vga_vsync,
  output logic [3:0] vga_r,
  output logic [3:0] vga_g,
  output logic [3:0] vga_b
  );
  
  logic clk_pix, clk_pix_locked;
  
  Clock_480p Clock_Inst (
    .i_sysclk,
    .i_rst(!i_rst_n),
    .clk_pix,
    .clk_pix_locked
  );
  
  localparam CORW = 10;         // screen coordinate width in bits
  logic [CORW-1:0] sx, sy;
  logic hsync, vsync, data_en;
  
  Simple_480p Simple_480p_Inst (
    .clk_pix,
    .i_rst_pix(!i_rst_n),
    .sx,
    .sy,
    .hsync,
    .vsync,
    .data_en
  );
  
  // Define a square with screen coordinates
  logic square;
  always_comb begin
    square = (sx > 220 && sx < 420) && (sy > 140 && sy <340);
  end
  
  // Define colors for square and background
  logic [3:0] paint_r, paint_g, paint_b;
  always_comb begin
      paint_r = (square) ? 4'hF : 4'h1;
      paint_g = (square) ? 4'hF : 4'h3;
      paint_b = (square) ? 4'hF : 4'h7;
  end
  
  // Decide whether to display a color (do not display in blanking area)
  logic [3:0] display_r, display_g, display_b;
  always_comb begin
    display_r = (data_en) ? paint_r : 4'h0;
    display_g = (data_en) ? paint_g : 4'h0;
    display_b = (data_en) ? paint_b : 4'h0;
  end
  
  // VGA Pmod output
  always_ff @(posedge clk_pix) begin
    vga_hsync <= hsync;
    vga_vsync <= vsync;
    vga_r <= display_r;
    vga_g <= display_g;
    vga_b <= display_b;
  end
  
endmodule
