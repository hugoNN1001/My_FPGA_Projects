`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2026 03:46:30 PM
// Design Name: 
// Module Name: Heartbeat
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


module Heartbeat(
  input i_Clk,
  input i_Rst,
  output wire [6:0] o_7Segment,
  output reg [3:0] o_AN,
  output [2:0] LED);

  localparam CLK_FREQ = 100_000_000;
  localparam TARGET_FREQ = 1;
  localparam COUNT = CLK_FREQ / TARGET_FREQ;
  
  // State enumeration
  localparam S0 = 2'd0, S1 = 2'd1, S2 = 2'd2;
  
  // Counter logic
  reg [$clog2(COUNT)-1:0] r_counter;
  reg r_tick;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      r_counter <= 0;
      r_tick <= 1'b0;
    end
    else if (r_counter == COUNT-1) begin
      r_tick <= 1'b1;
      r_counter <= 0;
    end
    else begin
      r_counter <= r_counter + 1'b1;
      r_tick <= 1'b0;
    end
  end
  
  // Multiplexing logic
  
  // Multiplexing is required because two different o_7Segment have
  // to be ON at the same time
  
  // Bit 17 has a period of 2^(17+1) = 262,144 cycles
  // 262,144/100,000,000 = 2.6ms (period in ms)
  // 2.6 * 4 = 10.4ms
  // 1/ 10.4ms = 96Hz (refresh rate)
  reg [18:0] r_mult_counter = 0;
  wire [1:0] sel;
  
  assign sel = r_mult_counter[18:17];
  
  always @(posedge i_Clk) begin
    r_mult_counter <= r_mult_counter + 1'b1;
    // No need to reset r_nult_counter because it will auto wrap around
  end
  //--------------------
  
  // FSM sequential logic
  reg [1:0] state_reg;
  wire [1:0] state_next;
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      state_reg <= S0;
    end
    else if (r_tick) begin
      state_reg <= (state_reg == S2) ? S0 : state_next;
    end
    else begin
      state_reg <= state_reg;
    end
  end
  
  // Next-state logic
  assign state_next = state_reg + 1'd1;

  // Output logic
  reg [6:0] r_code;
  
  always @(*) begin
    // Default:
    r_code = 7'b0000000; 
    o_AN = 4'b1111;
    
    case (state_reg)
      S0: begin 
        case (sel)
          2'b00: begin r_code = 7'b0000000; o_AN = 4'b1111; end
          2'b01: begin r_code = 7'b0000110; o_AN = 4'b1101; end // left vertical bar
          2'b10: begin r_code = 7'b0110000; o_AN = 4'b1011; end // right vertical bar
          2'b11: begin r_code = 7'b0000000; o_AN = 4'b1111; end
        endcase
      end
      S1: begin 
        case (sel)
          2'b00: begin r_code = 7'b0000000; o_AN = 4'b1111; end
          2'b01: begin r_code = 7'b0110000; o_AN = 4'b1101; end // right vertical bar
          2'b10: begin r_code = 7'b0000110; o_AN = 4'b1011; end // left vertical bar
          2'b11: begin r_code = 7'b0000000; o_AN = 4'b1111; end
        endcase
      end
      S2: begin 
        case (sel)
          2'b00: begin r_code = 7'b0110000; o_AN = 4'b1110; end // right vertical bar
          2'b01: begin r_code = 7'b0000000; o_AN = 4'b1111; end
          2'b10: begin r_code = 7'b0000000; o_AN = 4'b1111; end
          2'b11: begin r_code = 7'b0000110; o_AN = 4'b0111; end // left vertical bar
        endcase
      end
    endcase
  end 
  
  assign o_7Segment = ~{r_code[0], r_code[1], r_code[2], 
                        r_code[3], r_code[4], r_code[5], 
                        r_code[6]};
  
  // For testing
  assign LED[0] = (state_reg == S0) ? 1'b1 : 1'b0;
  assign LED[1] = (state_reg == S1) ? 1'b1 : 1'b0;
  assign LED[2] = (state_reg == S2) ? 1'b1 : 1'b0;
endmodule

