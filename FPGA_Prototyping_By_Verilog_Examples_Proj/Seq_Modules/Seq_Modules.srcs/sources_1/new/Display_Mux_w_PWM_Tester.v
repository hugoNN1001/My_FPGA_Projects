`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2026 10:08:23 AM
// Design Name: 
// Module Name: Display_Mux_w_PWM_Tester
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


module Display_Mux_w_PWM_Tester(
  input i_Clk,
  input [3:0] in0, in1, //// right to left LEDs
  input [3:0] i_Duty_Cycle,
  output [6:0] o_7Segment,
  output wire o_DP,
  output wire [3:0] o_AN);
  
  Display_Mux_w_PWM Display_Mux_w_PWM0 (
  .i_Clk(i_Clk),
  .in0(in0), .in1(in1), .in2(), .in3(), // right to left LEDs
  .i_DP_en(4'b0011), // choose which decimal point to show, active high
  .i_En(4'b0011), // choose which LED to show up, active high
  .i_Duty_Cycle(i_Duty_Cycle),
  .o_7Segment(o_7Segment),
  .o_DP(o_DP),
  .o_AN(o_AN));
endmodule

//----------XDC----------
//## Clock signal
//set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports i_Clk]
//create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_Clk]


//## Switches
//set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {i_Duty_Cycle[0]}]
//set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {i_Duty_Cycle[1]}]
//set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {i_Duty_Cycle[2]}]
//set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {i_Duty_Cycle[3]}]
//#set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {sw[4]}]
//#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {sw[5]}]
//#set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {sw[6]}]
//#set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {sw[7]}]
//set_property -dict { PACKAGE_PIN V2    IOSTANDARD LVCMOS33 } [get_ports {in0[0]}]
//set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports {in0[1]}]
//set_property -dict { PACKAGE_PIN T2    IOSTANDARD LVCMOS33 } [get_ports {in0[2]}]
//set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports {in0[3]}]
//set_property -dict { PACKAGE_PIN W2    IOSTANDARD LVCMOS33 } [get_ports {in1[0]}]
//set_property -dict { PACKAGE_PIN U1    IOSTANDARD LVCMOS33 } [get_ports {in1[1]}]
//set_property -dict { PACKAGE_PIN T1    IOSTANDARD LVCMOS33 } [get_ports {in1[2]}]
//set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports {in1[3]}]


//##7 Segment Display
//set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[0]}]
//set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[1]}]
//set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[2]}]
//set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[3]}]
//set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[4]}]
//set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[5]}]
//set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[6]}]

//set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports o_DP]

//set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {o_AN[0]}]
//set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {o_AN[1]}]
//set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {o_AN[2]}]
//set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {o_AN[3]}]

//## Configuration options, can be used for all designs
//set_property CONFIG_VOLTAGE 3.3 [current_design]
//set_property CFGBVS VCCO [current_design]

//## SPI configuration mode options for QSPI boot, can be used for all designs
//set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
//set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
//set_property CONFIG_MODE SPIx4 [current_design]