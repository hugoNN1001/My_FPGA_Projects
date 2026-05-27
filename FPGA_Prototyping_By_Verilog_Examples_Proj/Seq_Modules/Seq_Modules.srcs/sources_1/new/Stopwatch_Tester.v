`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2026 10:52:23 AM
// Design Name: 
// Module Name: Stopwatch_Tester
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


module Stopwatch_Tester(
  input i_Clk,
  input i_Clr,
  input i_Go,
  output [6:0] o_7Segment,
  output [3:0] o_AN,
  output o_DP
  );
  
  wire debounced_clr;
  
  Debounce_Filter Debounce_Clr(
  .i_Clk(i_Clk),
  .i_BouncyBtn(i_Clr),
  .o_DebouncedBtn_Level(),
  .o_DebouncedBtn_Pulse(debounced_clr)
  );
  
  wire debounced_go;
  reg r_Go_Toggle;
  
  Debounce_Filter Debounce_Go(
  .i_Clk(i_Clk),
  .i_BouncyBtn(i_Go),
  .o_DebouncedBtn_Level(),
  .o_DebouncedBtn_Pulse(debounced_go)
  );
  
  always @(posedge i_Clk) begin
    if (debounced_clr == 1'b1) begin
      r_Go_Toggle = 1'b0;
    end
    else if (debounced_go == 1'b1) begin
      r_Go_Toggle = ~r_Go_Toggle;
    end
  end
  
  wire [3:0] d2_out, d1_out, d0_out;
  
  Stopwatch Stopwatch0(
  .i_Clk(i_Clk),
  .i_Clr(debounced_clr),
  .i_Go(r_Go_Toggle),
  .d2(d2_out), 
  .d1(d1_out), 
  .d0(d0_out));
  
  Display_Mux Display_Mux0 (
  .i_Clk(i_Clk),
  .in0(d0_out), // rightmost LED
  .in1(d1_out),
  .in2(d2_out),
  .in3(),
  .i_DP_en(4'b0010), // choose which decimal point to show, active high
  .i_En(4'b0111), // choose which LED to show up, active high
  .o_7Segment(o_7Segment),
  .o_DP(o_DP),
  .o_AN(o_AN));
endmodule

//----------XDC----------
//## Clock signal
//set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports i_Clk]
//create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_Clk]

//## Seven Segment Display
//set_property -dict { PACKAGE_PIN W7 IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[0]}]
//set_property -dict { PACKAGE_PIN W6 IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[1]}]
//set_property -dict { PACKAGE_PIN U8 IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[2]}]
//set_property -dict { PACKAGE_PIN V8 IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[3]}]
//set_property -dict { PACKAGE_PIN U5 IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[4]}]
//set_property -dict { PACKAGE_PIN V5 IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[5]}]
//set_property -dict { PACKAGE_PIN U7 IOSTANDARD LVCMOS33 } [get_ports {o_7Segment[6]}]

//set_property -dict { PACKAGE_PIN V7 IOSTANDARD LVCMOS33 } [get_ports o_DP]

//## Anodes
//set_property -dict { PACKAGE_PIN U2 IOSTANDARD LVCMOS33 } [get_ports {o_AN[0]}]
//set_property -dict { PACKAGE_PIN U4 IOSTANDARD LVCMOS33 } [get_ports {o_AN[1]}]
//set_property -dict { PACKAGE_PIN V4 IOSTANDARD LVCMOS33 } [get_ports {o_AN[2]}]
//set_property -dict { PACKAGE_PIN W4 IOSTANDARD LVCMOS33 } [get_ports {o_AN[3]}]

//## Buttons
//set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports i_Clr] #btnC
//set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports i_Go] # btnU

//## Configuration options
//set_property CONFIG_VOLTAGE 3.3 [current_design]
//set_property CFGBVS VCCO [current_design]
