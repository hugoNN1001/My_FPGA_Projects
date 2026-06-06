`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 11:07:53 PM
// Design Name: 
// Module Name: Simple_480p_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Simulation Result:
// data_en resets at sx = 640 as expected
// hsync resets at sx = 655 as expected
// hsync sets at sx = 751 as expected
// sx reaches 799 then loops back to 0 as expected
// At that exact momemnt, sy increased to 1
// data_en resets when frame 479 enters horizontal blank interval
// then sets again at the end of frame 524.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Simple_480p_TB();
  
  parameter CLK_PIX_PERIOD = 39.6825;   // period = 1/25.2MHz
  
  logic clk_pix;
  logic rst_pix;
  logic [9:0] sx;
  logic [9:0] sy;
  logic hsync;
  logic vsync;
  logic data_en;
  
  Simple_480p DUT (
    .i_clk_pix(clk_pix),
    .i_rst_pix(rst_pix),     
    .o_sx(sx),         
    .o_sy(sy),       
    .o_hsync(hsync),          
    .o_vsync(vsync),             
    .o_data_en(data_en) 
  );
  
  always #(CLK_PIX_PERIOD/2) clk_pix = ~clk_pix;
  
  initial begin
    // Initialize input signals
    clk_pix = 0;  
    rst_pix = 1;
    #100;
    rst_pix = 0;
    
    // Simulate for 2 frames
    #34_000_000;
    $finish;     
  end
  
endmodule
