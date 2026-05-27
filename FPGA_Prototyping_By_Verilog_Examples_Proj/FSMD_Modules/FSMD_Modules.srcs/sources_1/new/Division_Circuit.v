`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2026 10:54:00 PM
// Design Name: 
// Module Name: Division_Circuit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 4-bit unsigned integer division circuit
//      rh     rl
//     000|0  0000
// The first 3 bits of rh is the remainder from the last compare & subtract op
// The last bit of rh is the MSB of rl, which is similar to bringing down the 
// next digit of the dividend if that makes sense.  
//
// This is essentially a 'long division' machine
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Division_Circuit #(parameter W = 4) (
  input clk, rst,
  input start,
  input [W-1:0] dvsr, dvnd,
  output wire [W-1:0] quo, rmd,
  output reg ready, done_tick, div_by_zero_error);
  
  // FSM states enumeration
  localparam [1:0] idle = 2'b00,
                   op = 2'b01,  
                   done = 2'b10;                               
   
  // Signal declaration
  reg [1:0] state_reg, state_next;
  reg [W-1:0] dvsr_reg, dvsr_next;
  reg [W-1:0] rh_reg, rh_next;
  reg [W-1:0] rl_reg, rl_next;
  reg [W-1:0] n_reg, n_next;
  reg [W-1:0] temp_rmd;
                 
  // FSM state transition
  always @(posedge clk) begin
    if (rst) begin
      state_reg <= idle;
      rh_reg <= 0;
      rl_reg <= 0;
      dvsr_reg <= 0;
      n_reg <= 0; 
    end
    else begin
      state_reg <= state_next;
      rh_reg <= rh_next;
      rl_reg <= rl_next;
      dvsr_reg <= dvsr_next;
      n_reg <= n_next;
    end   
  end                
  
  // FSM control path
  always @(*) begin
    // Default:
    rh_next = rh_reg;
    rl_next = rl_reg;
    dvsr_next = dvsr_reg;
    n_next = n_reg;
    ready = 1'b0;
    done_tick = 1'b0;
    div_by_zero_error = 1'b0;
    
    case (state_reg) 
      idle: begin
        ready = 1'b1;
        if (dvsr == 0) begin
          div_by_zero_error = 1'b1;
          state_next = done;
        end
        else if (start) begin
          rh_next = 0;
          rl_next = dvnd;
          dvsr_next = dvsr;
          // keeps track of how many times op is repeating 
          // how many times shift left is performed
          n_next = W; 
          state_next = op;
        end
      end
      op: begin
        if ({rh_reg[W-2:0], rl_reg[W-1]} >= dvsr_reg) begin
          rh_next = {rh_reg[W-2:0], rl_reg[W-1]} - dvsr_reg;
          rl_next = {rl_reg[W-2:0], 1'b1};
        end
        else begin
          rh_next = {rh_reg[W-2:0], rl_reg[W-1]};
          rl_next = {rl_reg[W-2:0], 1'b0};
        end
        
        n_next = n_reg - 1;
        if (n_next == 0) begin  
          // e.g. for 1101, n_next = 0 for the last 1
          state_next = done;
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
  assign quo = rl_reg;
  assign rmd = rh_reg;                                                                                                                            
endmodule
