`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 01:16:40 PM
// Design Name: 
// Module Name: Turnstile_Example
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


module Turnstile_Example(
  input i_Clk,
  input i_Rst,
  input i_Coin,
  input i_Push,
  output o_Locked
  );
  
  localparam LOCKED = 1'b0;
  localparam UNLOCKED = 1'b1;
  
  reg r_Curr_State;
  reg r_Next_State;
  
  // Sequential block
  always @(posedge i_Clk or posedge i_Rst) begin
    if (i_Rst) begin
      r_Curr_State <= LOCKED;
    end
    else begin
      r_Curr_State <= r_Next_State;
    end
  end
  
  // Combinational block
  always @(i_Coin or i_Push or r_Curr_State) begin
    r_Next_State <= r_Curr_State;
    // FSM holds its current state by default when
    // no transition condition is met
    // Let's say you're in UNLOCKED but i_Push = 0
    // so r_Next_State is not assigned.
    // That means the FPGA has to remember the previous 
    // state of r_Next_State => latch since this is a
    // combinational block with no memory
    // In other words, this assigment makes sure all
    // if-else conditions are convered.
    
    case (r_Curr_State)
      LOCKED:
        if (i_Coin) begin
          r_Next_State <= UNLOCKED;
        end
      UNLOCKED:
        if (i_Push) begin
          r_Next_State <= LOCKED;
        end
    endcase   
  end
  
  // Single always block approach (recommended)
//  always @(posedge i_Clk or posedge i_Rst) begin
//    if (i_Rst) begin
//      r_Curr_State <= LOCKED;
//    end
    
//    case (r_Curr_State)
//      LOCKED:
//        if (i_Coin) begin
//          r_Curr_State <= UNLOCKED;
//        end
//      UNLOCKED:
//        if (i_Push) begin
//          r_Curr_State <= LOCKED;
//        end
//    endcase
//  end
  
  assign o_Locked = (r_Curr_State == LOCKED);
endmodule
