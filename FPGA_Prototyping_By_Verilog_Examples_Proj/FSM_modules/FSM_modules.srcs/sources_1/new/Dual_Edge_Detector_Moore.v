`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2026 01:00:24 PM
// Design Name: 
// Module Name: Dual_Edge_Detector_Moore
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


module Dual_Edge_Detector_Moore(
  input i_Clk,
  input i_Rst, 
  input i_Level,
  output reg o_Edge);
  
  // States enumeration
  localparam zero = 2'b00,
             rising_edge = 2'b01,
             one = 2'b10,
             falling_edge = 2'b11;
  
  // Signal declarations
  reg [1:0] state_reg, state_next;
  
  always @(posedge i_Clk) begin
    if (i_Rst) 
      state_reg <= zero;
    else 
      state_reg <= state_next;
  end
  
  always @(*) begin
    // Default:
    state_next = state_reg; // same state
    o_Edge = 1'b0;
    
    case (state_reg)
      zero: begin
        if (i_Level) begin
          state_next = rising_edge;
        end  
      end
      rising_edge: begin
        o_Edge = 1'b1;
        
        if (i_Level) begin
          state_next = one;
        end
        else begin
          // move to zero if i_Level drops during rising_edge stage
          state_next = zero;  
        end
      end
      one: begin
        if (!i_Level) begin
          state_next = falling_edge;        
        end
      end
      falling_edge: begin
        o_Edge = 1'b1;
        
        if (!i_Level) begin
          state_next = zero;
        end
        else begin
          // move to one if i_Level sets during falling_edge stage
          state_next = one;  
        end
      end
      default: state_next = zero;  
    endcase 
  end           
  
endmodule
