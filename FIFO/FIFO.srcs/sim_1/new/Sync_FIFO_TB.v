`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 05:16:58 PM
// Design Name: 
// Module Name: Sync_FIFO_TB
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


module Sync_FIFO_TB();
  localparam WIDTH = 8;
  localparam DEPTH = 8;
  
  reg clk, rst_n;
  reg wr_en, rd_en;
  reg [WIDTH-1:0] data_in;
  
  wire [WIDTH-1:0] data_out;
  wire full, empty;
  
  integer i;
  
  Sync_FIFO #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
  ) DUT (
    .i_clk (clk), 
    .i_rst_n (rst_n), 
    .i_wr_en (wr_en), 
    .i_rd_en (rd_en),
    .i_data_in (data_in),
    .o_data_out (data_out),
    .o_full (full), 
    .o_empty (empty)
    );
  
  task write_data (input [WIDTH-1:0] d_in);
    begin
      @(posedge clk);
      wr_en = 1;
      data_in = d_in;
      @(posedge clk);
      wr_en = 0;
    end
  endtask  
  
  task read_data ();
    begin
      @(posedge clk);
      rd_en = 1;
      @(posedge clk) 
      rd_en = 0;
    end
  endtask
  
  
  always #50 clk = ~clk;

  initial begin
    clk = 0;
    @(posedge clk)
    rst_n = 0;
    @(posedge clk)
    rst_n = 1;
    
    // Test 1: fill up the FIFO to overflow then empty it to underflow
    i = 0;
    while (!full && i < 10) begin
      write_data(8'd2 ** i);
      i = i + 1;
    end
    i = 0;
    while (!empty && i < 10) begin
      read_data;
      i = i + 1;
    end
    
    @(posedge clk)
    rst_n = 0;
    @(posedge clk)
    rst_n = 1;
    
    // Test 2: simutaneous read & write
    for (i = 0; i < 3; i = i + 1) begin
      write_data(8'd2 ** i);
    end
    
    i = 0;
    while (i < 100) begin
      write_data(8'hAE);
      read_data;
    end
    
    
  end  
endmodule
