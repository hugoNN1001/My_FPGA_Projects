`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2026 07:19:36 PM
// Design Name: 
// Module Name: Debounce_Explicit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: The module starts at state zero, when the switch is pressed,
// the module enters state wait1 and waits until a counter decrements to 0,
// at which point the debounced output will be HIGH.
//
// When the module is at state one and the switch is released, the module enters
// state wait0 and waits until the counter decrements to 1, at which point 
// the debounced output will be LOW.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Debounce_Explicit(
  input clk, rst,
  input sw,
  output reg db_level, db_tick);
  
  // symbolic state declaration
  localparam [1:0]
               zero = 2'b00,
               wait0 = 2'b01,
               one = 2'b10,
               wait1 = 2'b11;
               
  // number of counter bits (2^N * 10ns =  10.5ms)
  localparam N = 20; 
  
  // signal declaration
  reg [1:0] state_reg, state_next;
  reg [N-1:0] counter_reg; 
  wire [N-1:0] counter_next;
  wire counter_zero;
  reg counter_load, counter_dec;
  
  // FSMD & counter state transition
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      state_reg <= zero;
      counter_reg <= 0;
    end
    else begin
      state_reg <= state_next;
      counter_reg <= counter_next;
    end
  end
  
  // FSMD data path
  assign counter_next = counter_load ? {N{1'b1}} :
                        counter_dec ? counter_reg - 1:
                                      counter_reg; 
  
  // status signal
  assign counter_zero = (counter_reg == 0);
  // FSMD control path
  always @(*) begin
    state_next = state_reg;
    db_tick = 1'b0;
    counter_dec = 1'b0;
    counter_load = 1'b0;
    
    case (state_reg) 
      zero: begin
        db_level = 1'b0;
        if (sw) begin
          counter_load = 1'b1;  // embedded RT: counterload = {N{1'b1}};
          state_next = wait1;
        end
      end
      wait1: begin
        db_level = 1'b0;
        if (sw) begin
          counter_dec = 1'b1;   // embedded RT: counter_next = counter_reg - 1;
          if (counter_zero) begin
            db_tick = 1'b1;
            state_next = one;
          end
        end
        else 
            state_next = zero;
      end
      one: begin
        db_level = 1'b1;
        if (!sw) begin
          counter_load = 1'b1;  // embedded RT: counterload = {N{1'b1}};
          state_next = wait0;
        end
      end
      wait0: begin
        db_level = 1'b1;
        if (!sw) begin
          counter_dec = 1'b1;  // embedded RT: counter_next = counter_reg - 1;
          if (counter_zero) begin
            state_next = zero;
          end
        end
        else 
          state_next = one;
      end
    endcase
  end
endmodule
