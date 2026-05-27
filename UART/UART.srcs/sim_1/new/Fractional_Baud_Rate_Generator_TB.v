`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 09:41:42 PM
// Design Name: 
// Module Name: Fractional_Baud_Rate_Generator
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


module Fractional_Baud_Rate_Generator();
  
  reg clk = 0;
  
  wire rx_en;
  wire tx_en;
  
  Baud_Rate_Generator DUT (
    .i_clk (clk),
    .o_rx_en (rx_en),
    .o_tx_en (tx_en)
  );
  
  always #50 clk = ~clk;
  
  initial begin
    #150000;
    $finish;
  end
endmodule
