`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2026 01:36:25 PM
// Design Name: 
// Module Name: Dual_Edge_Detector_Mealy
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


module Dual_Edge_Detector_Mealy(
  input i_Clk,
  input i_Rst, 
  input i_Level,
  output reg o_Edge);
  
  // States enumeration
  localparam zero = 1'b0,
             one = 1'b1;
  
  // Signal declarations
  reg state_reg, state_next;
  
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
          o_Edge = 1'b1;
          state_next = one;
        end  
      end
      one: begin
        if (!i_Level) begin
          o_Edge = 1'b1;
          state_next = zero;        
        end
      end
      default: state_next = zero;  
    endcase 
  end           
  
endmodule
