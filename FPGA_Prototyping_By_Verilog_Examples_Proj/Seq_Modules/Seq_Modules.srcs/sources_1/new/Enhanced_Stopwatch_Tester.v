`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2026 11:42:49 AM
// Design Name: 
// Module Name: Enhanced_Stopwatch_Tester
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


module Enhanced_Stopwatch_Tester(
  input i_Clk,
  input i_Clr,
  input i_Go,
  input i_Up, // 1: counting up; 0: counting down
  output [6:0] o_7Segment,
  output [3:0] o_AN,
  output o_DP);
  
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
  
  wire [3:0] M, S1, S0, D;
  
  Enhanced_Stopwatch UUT(
  .i_Clk(i_Clk),
  .i_Clr(debounced_clr),
  .i_Go(r_Go_Toggle),
  .i_Up(i_Up), // 1: counting up; 0: counting down
  .M(M), 
  .S1(S1), 
  .S0(S0), 
  .D(D));
  
  Display_Mux Display_Mux0 (
  .i_Clk(i_Clk),
  .in0(D), // rightmost LED
  .in1(S0),
  .in2(S1),
  .in3(M),
  .i_DP_en(4'b1010), // choose which decimal point to show, active high
  .i_En(4'b1111), // choose which LED to show up, active high
  .o_7Segment(o_7Segment),
  .o_DP(o_DP),
  .o_AN(o_AN));
endmodule

//----------XDC----------
//## Clock signal
//set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports i_Clk]
//create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_Clk]


//## Switches
//# sw[0]
//set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {i_Up}]

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

//##Buttons
//#btnC
//set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports i_Clr]
//#btnU
//set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports i_Go]

//## Configuration options, can be used for all designs
//set_property CONFIG_VOLTAGE 3.3 [current_design]
//set_property CFGBVS VCCO [current_design]

//## SPI configuration mode options for QSPI boot, can be used for all designs
//set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
//set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
//set_property CONFIG_MODE SPIx4 [current_design]
