`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2026 07:04:10 PM
// Design Name: 
// Module Name: LED_Banner
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


module LED_Banner_Tester(
  input i_Clk,
  input i_Rst,
  input i_En,
  input i_Dir,  // 1: rotate right; 0: rotate left
  input [9:0] i_Sw, // Takes 10 BCD numbers as inputs
  output [6:0] o_7Segment,
  output [3:0] o_AN);
  
  localparam CLK_FREQ = 100_000_000;
  localparam TARGET_FREQ = 2; 
  localparam COUNT = CLK_FREQ / TARGET_FREQ;
  
  // Separating the inputs
  // There are 10 BCD inputs but 14 are created to create the "slide window" effect
  // BCD_num = _  _  _  _  0  1  2  3  4  5   6  7   8    9   _   _   _   _
  //          [0][1][2][3][4][5][6][7][8][9][10][11][12][13][14][15][16][17]
  wire [3:0] BCD_num [17:0];
  
  genvar i;
  generate
    for (i = 0; i < 18; i = i + 1) begin : ARRAY_SIGN
      if (i < 4)
        assign BCD_num[i] = 4'b0000;
      else if (i < 14) 
        assign BCD_num[i] = {3'b000, i_Sw[i-4]};
      else 
        assign BCD_num[i] = 4'b0000;
    end
  endgenerate
  
  // Pad the ramaining spots with zeros to create the "slide window" effect
  
  // Trasition counter
  reg [$clog2(COUNT)-1:0] r_trans_counter;
  reg r_trans_tick;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      r_trans_counter <= 0;
      r_trans_tick <= 1'b0;
    end
    
    if (r_trans_counter == COUNT - 1) begin
      r_trans_counter <= 0;
      r_trans_tick <= 1'b1;
    end
    else begin
      r_trans_counter <= r_trans_counter + 1;
      r_trans_tick <= 1'b0;
    end
  end
  //////////////////////////////
  
  reg [3:0] in0, in1, in2, in3;
  reg [3:0] En;
  
  Display_Mux Display_Mux0 (
  .i_Clk(i_Clk),
  .in0(in0), // rightmost LED
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .i_DP_en(4'b0000), // choose which decimal point to show, active high
  .i_En(En), // choose which LED to show up, active high
  .o_7Segment(o_7Segment),
  .o_DP(),
  .o_AN(o_AN));
  
  reg [4:0] r_offset;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      if (!i_Dir) begin
        // Rotate left
        r_offset <= 5'd0;
      end
      else begin
        // Rotate right
        r_offset <= 5'd14;
      end
    end 
    else if (r_trans_tick && i_En) begin 
      if (!i_Dir) begin
        // Rotate left
        r_offset <= (r_offset == 5'd14) ? 5'd0 : r_offset + 1'b1;
      end 
      else begin
        // Rotate right
        r_offset <= (r_offset == 5'd0) ? 5'd14 : r_offset - 1'b1;
      end
    end
  end
  
  always @(*) begin
      // The r_offset value below is the value sampled before it's incremented
      // Safeguard against r_offset + n exceeds 17
      in0 = BCD_num[r_offset];
      in1 = (r_offset + 1 > 17) ? BCD_num[r_offset + 1 - 18] : BCD_num[r_offset + 1];
      in2 = (r_offset + 2 > 17) ? BCD_num[r_offset + 2 - 18] : BCD_num[r_offset + 2];
      in3 = (r_offset + 3 > 17) ? BCD_num[r_offset + 3 - 18] : BCD_num[r_offset + 3];
      
    if (!i_Dir) begin
      // Rotate left
      case (r_offset)
        5'd11: En = 4'b1110;
        5'd12: En = 4'b1100;
        5'd13: En = 4'b1000;
        5'd14: En = 4'b0000;
        default: En = 4'b1111;
      endcase
    end
    else begin
      // Rotate right
      case (r_offset) 
        5'd3: En = 4'b0111;
        5'd2: En = 4'b0011;
        5'd1: En = 4'b0001;
        5'd0: En = 4'b0000;
        default: En = 4'b1111;
      endcase
    end 
  end
endmodule

//----------XDC----------
//## This file is a general .xdc for the Basys3 rev B board
//## To use it in a project:
//## - uncomment the lines corresponding to used pins
//## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

//## Clock signal
//set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports i_Clk]
//create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_Clk]


//## Switches
//# sw[2:0]
//set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {i_Rst}]
//set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {i_En}]
//set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {i_Dir}]
//# sw[12:3]
//set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {i_Sw[0]}]
//set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {i_Sw[1]}]
//set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {i_Sw[2]}]
//set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {i_Sw[3]}]
//set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {i_Sw[4]}]
//set_property -dict { PACKAGE_PIN V2    IOSTANDARD LVCMOS33 } [get_ports {i_Sw[5]}]
//set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports {i_Sw[6]}]
//set_property -dict { PACKAGE_PIN T2    IOSTANDARD LVCMOS33 } [get_ports {i_Sw[7]}]
//set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports {i_Sw[8]}]
//set_property -dict { PACKAGE_PIN W2    IOSTANDARD LVCMOS33 } [get_ports {i_Sw[9]}]
//#set_property -dict { PACKAGE_PIN U1    IOSTANDARD LVCMOS33 } [get_ports {sw[13]}]
//#set_property -dict { PACKAGE_PIN T1    IOSTANDARD LVCMOS33 } [get_ports {sw[14]}]
//#set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports {sw[15]}]


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


//## Configuration options, can be used for all designs
//set_property CONFIG_VOLTAGE 3.3 [current_design]
//set_property CFGBVS VCCO [current_design]

//## SPI configuration mode options for QSPI boot, can be used for all designs
//set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
//set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
//set_property CONFIG_MODE SPIx4 [current_design]
