`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2026 02:58:16 PM
// Design Name: 
// Module Name: Binary_To_BCD_FSMD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 13-bit binary to BCD converter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Binary_To_BCD_FSMD(
  input clk, rst,
  input start,
  input [12:0] bin,
  output [3:0] bcd0, bcd1, bcd2, bcd3,
  output reg done_tick);
  
  // FSM states enumeration
  localparam [1:0] idle = 2'b00,
                   op = 2'b01,
                   done = 2'b10;
      
  // Signal declaration
  reg [1:0] state_reg, state_next;
  // Load bin parallely, shifted left serially
  reg [12:0] p2s_reg, p2s_next; 
  reg [3:0] bcd0_reg, bcd0_next;    
  reg [3:0] bcd1_reg, bcd1_next;  
  reg [3:0] bcd2_reg, bcd2_next;  
  reg [3:0] bcd3_reg, bcd3_next;
  // Hold each bcd digit that has been compared to 5
  wire [3:0] bcd0_comp, bcd1_comp, bcd2_comp, bcd3_comp;
  // Keep track of the number of operations
  reg [3:0] n_reg, n_next;
  reg ready;
              
  // FSM state transition
  always @(posedge clk) begin
    if (rst) begin
      state_reg <= idle;
      p2s_reg <= 0;
      bcd0_reg <= 0;
      bcd1_reg <= 0;
      bcd2_reg <= 0;
      bcd3_reg <= 0;
      n_reg <= 0;
    end
    else begin
      state_reg <= state_next;
      p2s_reg <= p2s_next;
      bcd0_reg <= bcd0_next;
      bcd1_reg <= bcd1_next;
      bcd2_reg <= bcd2_next;
      bcd3_reg <= bcd3_next;
      n_reg <= n_next;
    end
  end
  
  // FSM control path
  always @(*) begin
    // Default:
    state_next = state_reg;
    p2s_next = p2s_reg;
    bcd0_next = bcd0_reg;
    bcd1_next = bcd1_reg;
    bcd2_next = bcd2_reg;
    bcd3_next = bcd3_reg;
    n_next = n_reg;
    ready = 1'b0;
    done_tick = 1'b0;
    
    case (state_reg) 
      idle: begin
        ready = 1'b1;
        if (start) begin
          p2s_next = bin;
          bcd0_next = 0;
          bcd1_next = 0;
          bcd2_next = 0;
          bcd3_next = 0;
          state_next = op;
          n_next = 13;
        end
      end
      op: begin
        p2s_next = p2s_reg << 1;
        bcd0_next = {bcd0_comp[2:0], p2s_reg[12]};
        bcd1_next = {bcd1_comp[2:0], bcd0_comp[3]};
        bcd2_next = {bcd2_comp[2:0], bcd1_comp[3]};
        bcd3_next = {bcd3_comp[2:0], bcd2_comp[3]};
        n_next = n_reg - 1;
        
        if (n_next == 0) begin
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
  
  // Data path
  assign bcd0_comp = (bcd0_reg >= 5) ? bcd0_reg + 3 : bcd0_reg;
  assign bcd1_comp = (bcd1_reg >= 5) ? bcd1_reg + 3 : bcd1_reg;
  assign bcd2_comp = (bcd2_reg >= 5) ? bcd2_reg + 3 : bcd2_reg;
  assign bcd3_comp = (bcd3_reg >= 5) ? bcd3_reg + 3 : bcd3_reg;
  
  // Output
  assign bcd0 = bcd0_reg;
  assign bcd1 = bcd1_reg;
  assign bcd2 = bcd2_reg;
  assign bcd3 = bcd3_reg;
endmodule
