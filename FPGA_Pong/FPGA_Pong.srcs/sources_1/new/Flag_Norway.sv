`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2026 07:18:31 PM
// Design Name: 
// Module Name: Flag_Norway
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

module Flag_Norway(
  input wire logic i_sysclk,              // System clock
  input wire logic i_rst_n,               // Active low reset
  output logic vga_hsync, vga_vsync,      // VGA HSYNC and VSYNC signals
  output logic [3:0] vga_r, vga_g, vga_b  // VGA RBG signals
  );
  
  // Screen mode: 640x480p       
  localparam SX_MAX  = 640;
  localparam SY_MAX = 480;
  
  // Instantiate 25.2MHz clock
  logic clk_pix;            // pixel clock (25.2MHz)
  logic clk_pix_locked;     // pix clock stable?
  Clock_480p Clock_Inst (
    .i_sysclk,      
    .i_rst(!i_rst_n),       
    .o_clk_pix(clk_pix),
    .o_clk_pix_locked(clk_pix_locked)
  );
  
  // Instantiate 
  localparam CORW = 10;           // width of screen coordinates (sx, sy)
  logic [CORW-1:0] sx, sy;        // Horizontal & vertical screen coordinates
  logic hsync, vsync;             // Are we in sync interval?
  logic data_en;                  // Are we in blanking interval?
  Simple_480p Simple_480p_Inst (
    .i_clk_pix(clk_pix),
    .i_rst_pix(!i_rst_n),
    .o_sx(sx),
    .o_sy(sy),
    .o_hsync(hsync),
    .o_vsync(vsync),
    .o_data_en(data_en)
  );
  
  // Flag information: https://www.crwflags.com/fotw/flags/no_fact.html
  // Proportion: 16:22
  // We will make flag fit as large as possible on the screen
  // Each unit is a 29x29 pix square
  localparam UNIT_SIZE = 29;
  // The whole flag is be 638x464
  localparam FLAG_W = 638;
  localparam FLAG_H = 464;
  // Offset the flag in the x and y direction so it's centered
  // Example X_OFFSET = (640-638)/2 = 1
  // It means the whole flag will be shifted 1 pixel to the right so it
  // remains centered
  localparam X_OFFSET = (SX_MAX - FLAG_W) / 2; 
  localparam Y_OFFSET = (SY_MAX - FLAG_H) / 2;  
  
  logic [3:0] paint_r, paint_g, paint_b;    // color signal for each pixel
  // Define color areas 
  always_comb begin
    
    // Check if we're in drawing area
    if ((sx >= X_OFFSET && sx < (FLAG_W + X_OFFSET)) &&
        (sy >= Y_OFFSET && sy < (FLAG_H + Y_OFFSET))) begin
      
      // Convert screen coordinates (sx/sy) into units
      // Ex: sx = 29 will be in unit 1 && sx = 30 will be in unit 2
      automatic int x_unit = (sx - X_OFFSET) / UNIT_SIZE;
      automatic int y_unit = (sy - Y_OFFSET) / UNIT_SIZE;
    
      case(y_unit)
        0,1,2,3,4,5: begin 
          case(x_unit) 
            0,1,2,3,4,5:                          begin paint_r = 4'hB; paint_g = 4'h0; paint_b = 4'h2; end // red
            6:                                    begin paint_r = 4'hF; paint_g = 4'hF; paint_b = 4'hF; end // white
            7,8:                                  begin paint_r = 4'h0; paint_g = 4'h2; paint_b = 4'h5; end // blue
            9:                                    begin paint_r = 4'hF; paint_g = 4'hF; paint_b = 4'hF; end // white
            10,11,12,13,14,15,16,17,18,19,20,21:  begin paint_r = 4'hB; paint_g = 4'h0; paint_b = 4'h2; end // red
            default:                              begin paint_r = 4'h0; paint_g = 4'h0; paint_b = 4'h0; end // black
          endcase
        end
        6: begin
          case(x_unit) 
            0,1,2,3,4,5,6:                          begin paint_r = 4'hF; paint_g = 4'hF; paint_b = 4'hF; end // white
            7,8:                                    begin paint_r = 4'h0; paint_g = 4'h2; paint_b = 4'h5; end // blue
            9,10,11,12,13,14,15,16,17,18,19,20,21:  begin paint_r = 4'hF; paint_g = 4'hF; paint_b = 4'hF; end // white
            default:                                begin paint_r = 4'h0; paint_g = 4'h0; paint_b = 4'h0; end // black
          endcase  
        end 
        7,8: begin
          paint_r = 4'h0; paint_g = 4'h2; paint_b = 4'h5; // blue
        end
        9: begin
          case(x_unit) 
            0,1,2,3,4,5,6:                          begin paint_r = 4'hF; paint_g = 4'hF; paint_b = 4'hF; end // white
            7,8:                                    begin paint_r = 4'h0; paint_g = 4'h2; paint_b = 4'h5; end // blue
            9,10,11,12,13,14,15,16,17,18,19,20,21:  begin paint_r = 4'hF; paint_g = 4'hF; paint_b = 4'hF; end // white
            default:                                begin paint_r = 4'h0; paint_g = 4'h0; paint_b = 4'h0; end // black
          endcase 
        end
        10,11,12,13,14,15: begin
          case(x_unit) 
            0,1,2,3,4,5:                          begin paint_r = 4'hB; paint_g = 4'h0; paint_b = 4'h2; end // red
            6:                                    begin paint_r = 4'hF; paint_g = 4'hF; paint_b = 4'hF; end // white
            7,8:                                  begin paint_r = 4'h0; paint_g = 4'h2; paint_b = 4'h5; end // blue
            9:                                    begin paint_r = 4'hF; paint_g = 4'hF; paint_b = 4'hF; end // white
            10,11,12,13,14,15,16,17,18,19,20,21:  begin paint_r = 4'hB; paint_g = 4'h0; paint_b = 4'h2; end // red
            default:                              begin paint_r = 4'h0; paint_g = 4'h0; paint_b = 4'h0; end // black
          endcase
        end
        default :                                 begin paint_r = 4'h0; paint_g = 4'h0; paint_b = 4'h0; end // black          
      endcase
    end
  end
  
  // Decide whether to display a color
  logic [3:0] display_r, display_g, display_b;
  always_comb begin
    display_r = (data_en) ? paint_r : 0;
    display_g = (data_en) ? paint_g : 0;
    display_b = (data_en) ? paint_b : 0;
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
