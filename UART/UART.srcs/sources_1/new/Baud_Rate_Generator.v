`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2026 11:43:00 AM
// Design Name: 
// Module Name: Baud_Rate_Generator
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


module Baud_Rate_Generator(
  input i_clk,
  output reg o_rx_en,
  output reg o_tx_en
  );
  
  localparam SYS_CLK = 10_000_000;
  localparam BAUD_RATE = 9600;
  localparam OVERSAMPLING_RATE = 16;
  localparam TX_CLKS_PER_BIT = SYS_CLK/ BAUD_RATE;
  
  localparam DIV_NUM = SYS_CLK;
  localparam DIV_DEN = (BAUD_RATE * OVERSAMPLING_RATE);
  
  reg [$clog2(TX_CLKS_PER_BIT)-1:0] r_tx_counter = 0;
  
  reg [$clog2(SYS_CLK):0] r_cnt = 0;
  reg r_cnt_overflow;
  
  always @(posedge i_clk) begin    
    // RX baud rate generation
    r_cnt_overflow = (r_cnt + DIV_DEN >= DIV_NUM);
    
    if (r_cnt_overflow) begin
      o_rx_en <= 1'b1;
      r_cnt <= r_cnt + DIV_DEN - DIV_NUM;
    end 
    else begin
      o_rx_en <= 1'b0;
      r_cnt <= r_cnt + DIV_DEN;
    end 
    
    // TX baud rate generation
    if (r_tx_counter == TX_CLKS_PER_BIT - 1) begin
      r_tx_counter <= 1'b0;
      o_tx_en <= 1'b1;
    end else begin  
      r_tx_counter <= r_tx_counter + 1;
      o_tx_en <= 1'b0;
    end
  end
    
endmodule



