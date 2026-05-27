`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 12:24:42 PM
// Design Name: 
// Module Name: Ethernet_MAC_TX_TB
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


module Ethernet_MAC_TX_TB();
  
  reg         i_clk,
              i_rst_n,
              i_mii_tx_clk,
              s_axis_tvalid,
              s_axis_tlast;
  reg [7:0]   s_axis_tdata;
  
  wire        o_mii_tx_en,
              s_axis_tready,
              o_fifo_overflow,
              o_fifo_underflow;
  wire [7:0]  o_mii_txd;
       
  Ethernet_MAC_TX UUT(
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_mii_tx_clk(i_mii_tx_clk),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tlast(s_axis_tlast),
    .o_mii_tx_en(o_mii_tx_en),
    .o_mii_txd(o_mii_txd),
    .s_axis_tready(s_axis_tready),
    .o_fifo_overflow(o_fifo_overflow),
    .o_fifo_underflow(o_fifo_underflow)
    );
  
  // tvalid asserted means valid data is sitting on the input bus right now.
  // Pause and wait for next rising clk edge so UUT can look at the signals we just set up.
  // Wait if FIFO is full (s_axis_tready = 0).
  // Synchronize to next rising clk edge then de-assert s_axis_valid.
  task axis_send(input [7:0] tdata, input tlast);
  begin
    s_axis_tvalid = 1;
    s_axis_tdata = tdata;
    s_axis_tlast = tlast;
    @(posedge i_clk);
    while (!s_axis_tready) @(posedge i_clk);
    s_axis_tvalid = 0;
  end
  endtask
  
  // System clock = 100MHz (10ns)
  always #5 i_clk = ~i_clk;
  
  // MII clock 25MHz for 100Mbps Ethernet (40ns)
  always #20 i_mii_tx_clk = ~i_mii_tx_clk;
  
  initial begin
    // Initialize inputs
    i_clk = 0;
    i_rst_n = 0;
    i_mii_tx_clk = 0;
    s_axis_tvalid = 0;
    s_axis_tlast = 0;
    s_axis_tdata = 0;
    
    @(posedge i_clk);
    $monitor ("At time=%0t, UUT.state = %d", $time, UUT.state);
    
    // Reset
    @(posedge i_clk);
    i_rst_n = 0;
    @(posedge i_clk);
    i_rst_n = 1;
    
    axis_send(8'hAA, 1'b0);
    axis_send(8'hBB, 1'b0);
    axis_send(8'hCC, 1'b0);
    axis_send(8'hDD, 1'b1);
    
    
    
    // Wait for the whole transmission to pass through
    // Preamble(14 clks) + SFD(2 clks) + Data(8 clks) + FCS(8 clks) + IPG(96 clks)
    // = 128 clks
    #(128 * 40);
    
    
    $finish;
  end
  
  initial begin
    $dumpfile("max_tx_sim_dump.vcd");
    $dumpvars(0, Ethernet_MAC_TX_TB.UUT);
  end
  
//  assert_preamble_state: assert property (
//    @
endmodule
