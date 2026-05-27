`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2026 03:29:00 PM
// Design Name: 
// Module Name: Early_Detection_Debounce_Filter
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

// Looking back this is like an FMSD project but the counter is just a regular
// sequential circuit without _reg and _next registers.
module Early_Detection_Debounce_Filter(
  input i_Clk,
  input i_Rst,
  input i_Level,  // switch level
  output reg o_Debounced);
  
  // Clock runs 2_000_000 in 20ms
  localparam DEBOUNCE_LIMIT = 2_000_000;
  
  // State enumeration
  localparam IDLE = 2'b00,
             PRESS_LOCK = 2'b01,
             HELD = 2'b10,
             RELEASE_LOCK = 2'b11;
             
  // Signal declaration
  reg [1:0] state_reg, state_next;
  // A register to contain DEBOUNCE_LIMIT in binary
  reg [$clog2(DEBOUNCE_LIMIT)-1:0] r_Count; 
  reg r_tick;
  
  // Counter logic
  reg r_Counter_En;
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      r_tick <= 0;
      r_Count <= 0;
    end
    else if (r_Counter_En) begin
      if (r_Count == DEBOUNCE_LIMIT-1) begin
        r_tick <= 1'b1;
        r_Count <= 0;
      end
      else begin
        r_tick <= 1'b0;
        r_Count <= r_Count + 1;
      end
    end
    else begin
      r_Count <= 0;
      r_tick <= 1'b0;
    end
  end
///////////////////////////////////////////

  always @(posedge i_Clk) begin
    if (i_Rst) begin
      state_reg <= IDLE;
    end
    else begin
      state_reg <= state_next;
    end
  end
  
  always @(*) begin
    // Default
    state_next = state_reg;
    o_Debounced = 1'b0; 
    r_Counter_En = 1'b0;

    case (state_reg)
      IDLE: begin
        // Waiting for press
        if (i_Level) begin
          // Register the first rising edge detected then wait for 20ms 
          o_Debounced = 1'b1;
          state_next = PRESS_LOCK;
        end
        // else block can be omitted
//        else begin
//          state_next = zero;
//        end
      end
      PRESS_LOCK: begin
        if (r_tick) begin
          // After 20ms
          r_Counter_En = 1'b0;
          o_Debounced = 1'b1; // if you don't see this to 1 it'll flicker to 0
          state_next = HELD;
        end
        else begin
          // Still counting to 20ms
          r_Counter_En = 1'b1;
          o_Debounced = 1'b1;
          state_next = PRESS_LOCK;
        end
      end
      HELD: begin
        // Waiting for release
        if (!i_Level) begin
          o_Debounced = 1'b0;
          state_next = RELEASE_LOCK;
        end
        else begin
          state_next = HELD;
          o_Debounced = 1'b1;
        end
      end
      RELEASE_LOCK: begin
        if (r_tick) begin
          // After 20ms
          r_Counter_En = 1'b0;
          o_Debounced = 1'b0; // if you don't set this to 0 it'll flicker to 1
          state_next = IDLE;
        end
        else begin
          // Still counting to 20ms
          r_Counter_En = 1'b1;
          o_Debounced = 1'b0;
          state_next = RELEASE_LOCK;
        end
      end
    endcase
  end
endmodule
