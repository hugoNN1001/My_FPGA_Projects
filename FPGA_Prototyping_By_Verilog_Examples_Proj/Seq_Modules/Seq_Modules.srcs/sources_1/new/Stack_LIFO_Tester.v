`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2026 03:33:51 PM
// Design Name: 
// Module Name: Stack_LIFO_Tester
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

// 4-bit wide, 2^2=4 address spaces
module Stack_LIFO_Tester #(parameter N = 4, W = 2) (
  input i_Clk,
  input i_Rst,
  input i_Push,
  input i_Pop,
  input [N-1:0] i_Push_Data,
  output wire [N-1:0] o_Pop_Data,
  output o_Full,
  output o_Empty);
  
  wire w_debounced_push;
  Debounce_Filter Debounce_Push(
  .i_Clk(i_Clk),
  .i_BouncyBtn(i_Push),
  .o_DebouncedBtn_Level(),
  .o_DebouncedBtn_Pulse(w_debounced_push)
  );
  
  wire w_debounced_pop;
  Debounce_Filter Debounce_Pop(
  .i_Clk(i_Clk),
  .i_BouncyBtn(i_Pop),
  .o_DebouncedBtn_Level(),
  .o_DebouncedBtn_Pulse(w_debounced_pop)
  );
  
  // 4-bit wide, 2^2=4 address spaces
  Stack_LIFO #(.N(N), .W(W)) UUT (
  .i_Clk(i_Clk),
  .i_Rst(i_Rst),
  .i_Push(w_debounced_push),
  .i_Pop(w_debounced_pop),
  .i_Push_Data(i_Push_Data),
  .o_Pop_Data(o_Pop_Data),
  .o_Full(o_Full),
  .o_Empty(o_Empty));
endmodule

//----------XDC----------
//## Clock signal
//set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports i_Clk]
//create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_Clk]

//## Switches
//#sw[0]
//set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {i_Rst}]
//#sw[4:1]
//set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {i_Push_Data[0]}]
//set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {i_Push_Data[1]}]
//set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {i_Push_Data[2]}]
//set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {i_Push_Data[3]}]

//## LEDs
//#led[3:0]
//set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {o_Pop_Data[0]}]
//set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {o_Pop_Data[1]}]
//set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {o_Pop_Data[2]}]
//set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {o_Pop_Data[3]}]
//#led[15:14]
//set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports {o_Empty}]
//set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports {o_Full}]

//##Buttons
//#btnL
//set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports i_Pop]
//#btnR
//set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports i_Push]

//## Configuration options, can be used for all designs
//set_property CONFIG_VOLTAGE 3.3 [current_design]
//set_property CFGBVS VCCO [current_design]

//## SPI configuration mode options for QSPI boot, can be used for all designs
//set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
//set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
//set_property CONFIG_MODE SPIx4 [current_design]