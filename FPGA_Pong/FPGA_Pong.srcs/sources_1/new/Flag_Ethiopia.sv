`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2026 10:03:06 PM
// Design Name: 
// Module Name: Flag_Ethiopia
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

module Flag_Ethiopia(
  input wire logic i_sysclk,
  input wire logic i_rst_n,
  output logic vga_hsync,   
  output logic vga_vsync,
  output logic [3:0] vga_r, vga_g, vga_b  // 4-bit VGA red, green, blue
  );
  
  logic clk_pix, clk_pix_locked;
  
    Clock_480p Clock_Inst (
      .i_sysclk,
      .i_rst(!i_rst_n),
      .o_clk_pix(clk_pix),
      .o_clk_pix_locked(clk_pix_locked)
    );
  
  localparam CORW = 10;         // screen coordinate width in bits
  logic [CORW-1:0] sx, sy;
  logic hsync, vsync, data_en;
  
  Simple_480p Simple_480p_Inst (
    .i_clk_pix(clk_pix),
    .i_rst_pix(!i_rst_n),
    .o_sx(sx),
    .o_sy(sy),
    .o_hsync(hsync),
    .o_vsync(vsync),
    .o_data_en(data_en)
  );
  
  // Define color for each region of the flag
  logic [3:0] paint_r, paint_g, paint_b;
  always_comb begin
    // 480/3=160 so each colar occupies 160 veritcal pixels
    if (sy < 160) begin
      // Green
      paint_r = 4'h0;
      paint_g = 4'h9;
      paint_b = 4'h3;
    end 
    else if (sy < 320) begin
      // Yellow
      paint_r = 4'hF;
      paint_g = 4'hE;
      paint_b = 4'h1;
    end
    else begin
      // Red
      paint_r = 4'hE;
      paint_g = 4'h1;
      paint_b = 4'h2;
    end
  end
  
  // Only display the color in active region
  logic [3:0] display_r, display_g, display_b;
  always_comb begin
    display_r = (data_en) ? paint_r : 4'h0;
    display_g = (data_en) ? paint_g : 4'h0;
    display_b = (data_en) ? paint_b : 4'h0;
  end
  
  // VGA Pmod Output
  always_ff @(posedge clk_pix) begin
    vga_hsync <= hsync;
    vga_vsync <= vsync;
    vga_r <= display_r;
    vga_g <= display_g;
    vga_b <= display_b;
  end
endmodule
