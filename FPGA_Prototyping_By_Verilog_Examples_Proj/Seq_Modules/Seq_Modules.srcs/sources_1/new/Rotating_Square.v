`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2026 10:55:20 AM
// Design Name: 
// Module Name: Rotating_Square
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

// An XDC file is included at the end for verification on the prototyping board
// The switches are debounced so expect some jitter
module Rotating_Square(
  input i_Clk,
  input i_Rst,
  input i_En,
  input i_CW,
  output wire [6:0] o_7Segment,
  output reg [3:0] o_AN
  );
  
  localparam F = 100_000_000;  // main clock frequency
  
  // There are 8 states so 3 bits are used
  reg [2:0] state_reg, state_next;
  
  localparam U3 = 3'd0, U2 = 3'd1, U1 = 3'd2, U0 = 3'd3, 
             L0 = 3'd4, L1 = 3'd5, L2 = 3'd6, L3 = 3'd7;
  
  // Counter logic
  reg [$clog2(F/2)-1:0] r_counter;
  reg r_tick;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      r_counter <= 0;
      r_tick <= 1'b0;
    end
    else if (i_En) begin
      if (r_counter == (F/2 - 1)) begin
        // Squares move every half a second
        r_counter <= 0;
        r_tick <= 1'b1;
      end
      else begin
        r_counter <= r_counter + 1;
        r_tick <= 1'b0;
      end
    end
    else begin
      r_counter <= r_counter;
      r_tick <= 1'b0;
    end
  end
  
  // FSM sequential logic
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      state_reg <= U3;
    end
    else if (r_tick) begin
      state_reg <= state_next;
    end
    // Else don't do anything, state_reg stays the same
    // This won't create a latch as this is sequential logic
  end
  
  // Next-state logic
  always @(*) begin
    if (i_CW) begin
      state_next = state_reg + 1;
    end
    else begin
      state_next = state_reg - 1;
    end
  end
  
  // Output logic
  reg [6:0] r_square_code;
  
  always @(*) begin
    case (state_reg)
      U3: begin r_square_code = 7'b1100011; o_AN = 4'b0111; end
      U2: begin r_square_code = 7'b1100011; o_AN = 4'b1011; end
      U1: begin r_square_code = 7'b1100011; o_AN = 4'b1101; end
      U0: begin r_square_code = 7'b1100011; o_AN = 4'b1110; end
      
      L3: begin r_square_code = 7'b0011101; o_AN = 4'b0111; end
      L2: begin r_square_code = 7'b0011101; o_AN = 4'b1011; end
      L1: begin r_square_code = 7'b0011101; o_AN = 4'b1101; end
      L0: begin r_square_code = 7'b0011101; o_AN = 4'b1110; end
      default: begin r_square_code = 7'b0000000; o_AN = 4'b1111; end // default: all off
    endcase
  end
  
  assign o_7Segment[0] = ~r_square_code[6];
  assign o_7Segment[1] = ~r_square_code[5];
  assign o_7Segment[2] = ~r_square_code[4];
  assign o_7Segment[3] = ~r_square_code[3];
  assign o_7Segment[4] = ~r_square_code[2];
  assign o_7Segment[5] = ~r_square_code[1];
  assign o_7Segment[6] = ~r_square_code[0];

endmodule

//----------XDC----------
//## Clock signal
//set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports i_Clk]
//create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_Clk]

//## Switches
//# sw[0]
//set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {i_CW}]
//# sw[1]
//set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {i_En}]
//# sw[2]
//set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {i_Rst}]

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