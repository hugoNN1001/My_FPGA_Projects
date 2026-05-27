`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 05:29:16 PM
// Design Name: 
// Module Name: UART_Top
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


module UART_Top(
  input i_clk,
  input i_rst,
  input [7:0] i_tx_byte,
  input i_tx_dv,
  input i_rx_serial,
  output o_tx_active,
  output o_tx_done,
  output o_tx_serial,
  output o_rx_dv,
  output [7:0] o_rx_byte);
  
  wire w_rx_en;
  wire w_tx_en;
  Baud_Rate_Generator Baud_Rate_Generator_1 (
    .i_clk (i_clk),
    .o_rx_en (w_rx_en),
    .o_tx_en (w_tx_en)
  );
  
  UART_TX UART_TX_1(
  .i_clk (i_clk),
  .i_tx_dv (i_tx_dv),
  .i_tx_en (w_tx_en),
  .i_rst (i_rst),
  .i_tx_byte (i_tx_byte),
  .o_tx_serial (o_tx_serial),
  .o_tx_active (o_tx_active),
  .o_tx_done (o_tx_done)
  );
  
  UART_RX UART_RX_1(
  .i_clk (i_clk),
  .i_rx_en (w_rx_en),
  .i_rx_serial (i_rx_serial),
  .i_rst (i_rst),
  .o_rx_dv (o_rx_dv),
  .o_rx_byte (o_rx_byte)
  );
endmodule
