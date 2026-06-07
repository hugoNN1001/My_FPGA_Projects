`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 04:51:55 PM
// Design Name: 
// Module Name: Clock_480p
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 25.2MHz pixel clock generation 480p using MMCM primitive 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Purposes: 
// 640x480p60 screen moden requires 
// 800 x 525 x60 = 25,200,000
// This code generate a 25.2MHz clock using the MMCM  
module Clock_480p(
  input wire logic i_sysclk,             // system clock (100MHz)
  input wire logic i_rst,                // reset
  output logic o_clk_pix,           // pixel clock
  output logic o_clk_pix_locked     // pixel clock locked?
  );
  
  localparam CLKIN1_PERIOD = 10.0;  // CLKIN1_PERIOD (100MHz)
  localparam MULT_MASTER = 31.5;    // master clock multiplier (2.000-64.000 in increments of 0.125)
  localparam DIV_MASTER = 5;        // master cock divider (1-106), divides
  localparam DIV0 = 25;             // pixel clock divider
         
  logic feedback;         // Internal clock feedback
  logic locked_unsynced;  // unsynced lock signal
  // Output clock from raw MMCM primitive needs to be pulled onto dedicated clock distribution networks
  logic clk_pix_unbuf;     // unbuffered pixel clock     
  
  MMCME2_BASE #(
    // MMCM Attributes (Table 3-7 User Guide - UG472)
    .CLKIN1_PERIOD(CLKIN1_PERIOD),
    // CLKFBOUT_MULT_F, CLKOUT_DIVIDE_F, and DIVCLK_DIVIDE determine output frequency
    .CLKFBOUT_MULT_F(MULT_MASTER),
    .DIVCLK_DIVIDE(DIV_MASTER),
    .CLKOUT0_DIVIDE_F(DIV0)
    ) MMCME2_BASE_inst (
      // MMCM Ports (Table 3-5 User Guide - UG472)
      .CLKIN1(i_sysclk),          // General clock input
      .RST(i_rst),                // Reset
      .CLKOUT0(clk_pix_unbuf),    // Output clock - o_clk_pix
      .LOCKED(locked_unsynced),   // pixel clock locked?
      .CLKFBOUT(feedback),        // internal feedback
      .CLKFBIN(feedback)          // internal feedback
    );
  
  // Explicitly buffer output pixel clock  
  BUFG bufg_clk(.I(clk_pix_unbuf), .O(o_clk_pix));
  
  // Sync output lock signal to pixel clock
  logic locked_sync_0;
  
  always_ff @(posedge o_clk_pix) begin
    if (i_rst) begin
      // To clean up initial 'X' states in simulation
      locked_sync_0 <= 0;
      o_clk_pix_locked <= 0;
    end
    else begin
      locked_sync_0 <= locked_unsynced;
      o_clk_pix_locked <= locked_sync_0;
    end
  end
endmodule


