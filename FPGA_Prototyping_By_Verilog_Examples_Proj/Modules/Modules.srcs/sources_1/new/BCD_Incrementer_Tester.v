`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2025 07:24:22 PM
// Design Name: 
// Module Name: BCD_Incrementer_Tester
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


module BCD_Incrementer_Tester(
  input i_Clk,
  input i_Rst,
  input i_En_Btn,
  output [6:0] o_7Segment,
  output [3:0] o_AN);
  
  wire En_Btn_Edge;
  
  Debounce_Filter Debounce_Filter0 (
    .i_Clk(i_Clk),
    .i_BouncyBtn(i_En_Btn),
    .o_DebouncedBtn_Level(),
    .o_DebouncedBtn_Pulse(En_Btn_Edge)
    );
    
  wire [3:0] Digit_0, Digit_1, Digit_2;
  
  BCD_Incrementor BCD_Incrementor0 (
  .i_Clk(i_Clk),
  .i_Rst(i_Rst),
  .i_En_Btn(En_Btn_Edge),
  .o_Digit_0(Digit_0),
  .o_Digit_1(Digit_1),
  .o_Digit_2(Digit_2));
  
  Display_Mux_wo_DP Display_Mux_wo_DP0(
  .i_Clk(i_Clk),
  .in0(Digit_0), 
  .in1(Digit_1), 
  .in2(Digit_2), 
  .in3(4'd0),
  .i_En(4'b0111),
  .o_7Segment(o_7Segment),
  .o_AN(o_AN));
endmodule

//----------XDC----------

//# Clock signal
//set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports i_Clk]
//create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_Clk]

//##7 Segment Display
//set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[0]}]
//set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[1]}]
//set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[2]}]
//set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[3]}]
//set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[4]}]
//set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[5]}]
//set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[6]}]

//set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {o_AN[0]}]
//set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {o_AN[1]}]
//set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {o_AN[2]}]
//set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {o_AN[3]}]

//##Buttons
//set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports i_En_Btn]
//set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports i_Rst]

//----------XDC----------