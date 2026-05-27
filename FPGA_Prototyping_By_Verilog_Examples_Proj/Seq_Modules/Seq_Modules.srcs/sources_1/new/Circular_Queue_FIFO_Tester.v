`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2026 05:45:33 PM
// Design Name: 
// Module Name: Circular_Queue_FIFO_Tester
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


module Circular_Queue_FIFO_Tester #(parameter 
                                    N = 3,
                                    W = 2) 
  (
  input i_Clk,
  input i_Rst,
  input i_Wr, i_Rd,
  input [N-1:0] i_Wr_Data,
  output [N+1:0] o_LEDs // N LEDs for read data + 2 LEDs for the flags
  );
  
  wire debounced_rst;
  Debounce_Filter Debounce_Rst(
  .i_Clk(i_Clk),
  .i_BouncyBtn(i_Rst),
  .o_DebouncedBtn_Level(debounced_rst),
  .o_DebouncedBtn_Pulse()
  );
  
  wire debounced_wr;
  Debounce_Filter Debounce_Wr(
  .i_Clk(i_Clk),
  .i_BouncyBtn(i_Wr),
  .o_DebouncedBtn_Level(),
  .o_DebouncedBtn_Pulse(debounced_wr)
  );
  
  wire debounced_rd;
  Debounce_Filter Debounce_Rd(
  .i_Clk(i_Clk),
  .i_BouncyBtn(i_Rd),
  .o_DebouncedBtn_Level(),
  .o_DebouncedBtn_Pulse(debounced_rd)
  );

  Circular_Queue_FIFO  
  #(
  .N(N),
  .W(W)
  )
  Circular_Queue_FIFO_0 
  (
  .i_Clk(i_Clk), 
  .i_Rst(debounced_rst),
  .wr(debounced_wr), 
  .rd(debounced_rd),
  .wr_data(i_Wr_Data),
  .empty(o_LEDs[N]), 
  .full(o_LEDs[N+1]),
  .rd_data(o_LEDs[N-1:0]));
  
endmodule

//----------XDC----------
//## Clock signal
//set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports i_Clk]
//create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_Clk]

//## Switches
//set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {i_Wr_Data[0]}]
//set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {i_Wr_Data[1]}]
//set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {i_Wr_Data[2]}]

//## LEDs
//set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {o_LEDs[0]}]
//set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {o_LEDs[1]}]
//set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {o_LEDs[2]}]
//set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {o_LEDs[3]}]
//set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {o_LEDs[4]}]

//##Buttons
//# btnC
//set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports i_Rst]
//# btnL  
//set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports i_Rd]
//# btnR 
//set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports i_Wr] 


//## Configuration options, can be used for all designs
//set_property CONFIG_VOLTAGE 3.3 [current_design]
//set_property CFGBVS VCCO [current_design]

//## SPI configuration mode options for QSPI boot, can be used for all designs
//set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
//set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
//set_property CONFIG_MODE SPIx4 [current_design]
