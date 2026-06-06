`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 05:59:51 PM
// Design Name: 
// Module Name: Clock_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Simulation Result:
// Takes 6000ns to lock
// Output frequency = 25.2MHz

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Clock_TB();

  parameter CLK_PERIOD = 10;    // sysclk period (100MHz)
  
  logic sysclk;
  logic rst;
  logic clk_pix;
  logic clk_pix_locked;
  
  Clock_480p DUT(
  .i_sysclk(sysclk),                // system clock (100MHz)
  .i_rst(rst),                      // reset
  .o_clk_pix(clk_pix),              // pixel clock
  .o_clk_pix_locked(clk_pix_locked) // pixel clock locked?
  );
  
  always #(CLK_PERIOD/2) sysclk = ~sysclk;
  
  initial begin
    sysclk = 0;
    rst = 1;
    #50;          // Hold rst for 50 clock cycles
    rst = 0;
    
    @(posedge DUT.o_clk_pix_locked);
    #7000;        // Simulate for 700 clock cycles
    $stop;  
  end
endmodule
