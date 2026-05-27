`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2026 02:09:17 PM
// Design Name: 
// Module Name: Fib
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Calculate the the n index in the Fibonacci sequence. Note n starts at 0.
// Implemented using FSMD
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Fib(
  input clk, rst,
  input [4:0] i,
  input start,
  output reg ready, done_tick,
  output [19:0] f);
  
  // FSM state enumeration
  localparam [1:0] idle = 2'b00,
                   op = 2'b01,
                   done = 2'b10;
  
  // State declaration
  reg [1:0] state_reg, state_next;
  reg [19:0] t0_reg, t0_next;
  reg [19:0] t1_reg, t1_next;
  reg [4:0] n_reg, n_next;
         
  // FSM state transition
  always @(posedge clk) begin
    if (rst) begin
      state_reg <= idle;   
      t0_reg <= 20'd0;
      t1_reg <= 20'd0;
      n_reg <= 5'd0;
    end
    else begin
      state_reg <= state_next;   
      t0_reg <= t0_next;
      t1_reg <= t1_next;
      n_reg <= n_next;
    end
  end
  
  // FSM control path
  always @(*) begin
    // Default:
    state_next = state_reg;   
    t0_next = t0_reg;
    t1_next = t1_reg;
    n_next = n_reg;
    ready = 1'b0;
    done_tick = 1'b0;
    
    case(state_reg) 
      idle: begin
        ready = 1'b1;
        if (start) begin
          t0_next = 20'd0;
          t1_next = 20'd1;
          n_next = i;
          state_next = op;  
        end
      end
      op: begin
        if (n_reg == 0) begin
          t1_next = 20'd0;
          state_next = done;
        end
        else if (n_reg == 1) begin
          state_next = done;
        end
        else begin
          t0_next = t1_reg;
          t1_next = t1_reg + t0_reg;
          n_next = n_reg - 1;
        end
      end
      done: begin
        done_tick = 1'b1;
        state_next = idle;
      end
      default: state_next = idle;
    endcase
  end
  
  // Output
  assign f = t1_reg;            
endmodule
