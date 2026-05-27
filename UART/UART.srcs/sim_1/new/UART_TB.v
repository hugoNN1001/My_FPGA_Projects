`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 06:47:29 PM
// Design Name: 
// Module Name: UART_TB
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


module UART_TB();

  reg clk = 0;
  reg rst = 1;
  
  reg [7:0] tx_byte;
  reg tx_dv;
  
  wire tx_active;
  wire tx_done;
  wire tx_serial;
  
  wire rx_dv;
  wire [7:0] rx_byte;
  
  UART_Top DUT (
    .i_clk (clk),
    .i_rst (rst),
    .i_tx_byte (tx_byte),
    .i_tx_dv (tx_dv),
    .i_rx_serial (tx_serial),
    .o_tx_active (tx_active),
    .o_tx_done (tx_done),
    .o_tx_serial (tx_serial),
    .o_rx_dv (rx_dv),
    .o_rx_byte (rx_byte)
  );
  
  always #50 clk = ~clk;
  
  initial begin
    repeat(2) @(posedge clk);
    rst = 0;
    repeat(2) @(posedge clk);
    
    tx_byte = 8'h48;
    tx_dv = 1;
    
    @(posedge clk); 
    tx_dv = 0;
    
    wait(tx_done);
    
    $display("RX received = %h", rx_byte);
     
    if (rx_byte == 8'h48) 
      $display("Pass");
    else 
      $display("Fail");
    
    wait(rx_dv);
    
    tx_byte = 8'h4E;
    
    @(posedge clk);
    tx_dv = 1;
    
    @(posedge clk); 
    tx_dv = 0;
    
    wait(tx_done);
    
    $display("RX received = %h", rx_byte);
     
    if (rx_byte == 8'h4E) 
      $display("Pass");
    else 
      $display("Fail");
    
    $stop;
  end
endmodule
