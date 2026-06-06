`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 11:57:25 AM
// Design Name: 
// Module Name: UART_RX
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


module UART_RX(
  input i_clk,
  input i_rx_en,
  input i_rx_serial,
  input i_rst,
  output o_rx_dv,
  output [7:0] o_rx_byte
  );
  
  // State declaration
  localparam RX_IDLE = 2'b00;
  localparam RX_START_BIT = 2'b01;
  localparam RX_DATA_BITS = 2'b10;
  localparam RX_STOP_BIT = 2'b11;
  
  reg [2:0] r_bit_index;
  
  reg [1:0] r_rx_state;
  reg r_rx_serial_ff1;
  reg r_rx_serial_ff2;
  
  reg [7:0] r_rx_byte;
  reg [2:0] r_rx_index;
  // Oversampling rate = 16 so there are 16 RX samples in 1 TX bit length
  reg [3:0] r_sample_cnt;
  reg r_rx_dv;
  
  reg [1:0] r_vote_count;
  // This is the bit voted
  reg r_voted_bit;
  
  // Double-flopping incoming data so it can be used in UART RX clock domain
  always @(posedge i_clk) begin
    r_rx_serial_ff1 <= i_rx_serial;
    r_rx_serial_ff2 <= r_rx_serial_ff1;
  end
  
  wire w_rx_serial = r_rx_serial_ff2;
  
  always @(posedge i_clk) begin
    if (i_rst) begin
      r_rx_dv <= 0;
      r_rx_byte <= 0;
      r_sample_cnt <= 0;
      r_bit_index <= 0;
      r_rx_state <= RX_IDLE;
    end
    else begin
      case (r_rx_state)
        
        // ---------------- RX_IDLE ----------------
        RX_IDLE: begin
          r_rx_dv <= 0;
           
          if (w_rx_serial == 0) begin
            // This is the START bit
            r_vote_count <= 0;
            r_sample_cnt <= 0; 
            r_rx_state <= RX_START_BIT;
          end
          else begin
          end
        end
        
        // ---------------- RX_START_BIT ----------------
        RX_START_BIT: begin
          // Sample to see if this is actually a START bit
          if (i_rx_en) begin
            r_sample_cnt <= r_sample_cnt + 1;
            
            if (r_sample_cnt >= 7 && r_sample_cnt <= 9) begin
              r_vote_count <= r_vote_count + w_rx_serial;
            end
            else if (r_sample_cnt == 10) begin
              r_voted_bit <= (r_vote_count >= 2);
            end
            else if (r_sample_cnt == 15) begin
              // Move on to receive data bits if this was actually a START bit
              r_rx_state <= (r_voted_bit == 0) ? RX_DATA_BITS : RX_IDLE;
              r_sample_cnt <= 0;
              r_vote_count <= 0;
            end   
            else begin
            end  
          end
        end
        
        // ---------------- RX_DATA_BITS ----------------
        RX_DATA_BITS: begin
          if (i_rx_en) begin
            r_sample_cnt <= r_sample_cnt + 1;
            
            if (r_sample_cnt >= 7 && r_sample_cnt <= 9) begin
              r_vote_count <= r_vote_count + w_rx_serial;
            end
            else if (r_sample_cnt == 10) begin
              r_voted_bit <= (r_vote_count >= 2);
            end
            else if (r_sample_cnt == 15) begin
              r_bit_index <= r_bit_index + 1;
              
              if (r_bit_index <= 7) begin
                r_rx_byte[r_bit_index] <= r_voted_bit; 
                r_sample_cnt <= 0;
                r_vote_count <= 0;
                if (r_bit_index == 7) begin
                  r_rx_state <= RX_STOP_BIT;
                  r_sample_cnt <= 0;
                  r_vote_count <= 0;
                end
              end
            end
            else begin
            end
          end
        end
        
        // ---------------- RX_STOP_BIT ----------------
        RX_STOP_BIT: begin
          if (i_rx_en) begin
            r_sample_cnt <= r_sample_cnt + 1;
            
            if (r_sample_cnt >= 7 && r_sample_cnt <= 9) begin
              r_vote_count <= r_vote_count + w_rx_serial;
            end
            else if (r_sample_cnt == 10) begin
              r_voted_bit <= (r_vote_count >= 2);
            end
            else if (r_sample_cnt == 15) begin
              r_rx_dv <= (r_voted_bit == 1) ? 1 : 0;
              r_rx_state <= RX_IDLE;
              r_vote_count <= 0;
            end
            else begin
            end
          end
        end
        
        default: r_rx_state <= RX_IDLE;  
      endcase
    end
    
  end
  
  assign o_rx_dv = r_rx_dv;
  assign o_rx_byte = r_rx_byte;
  
endmodule
