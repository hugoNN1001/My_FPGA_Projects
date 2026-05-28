`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2026 03:15:31 PM
// Design Name: 
// Module Name: Transmitter
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


module Transmitter(
  input i_clk,
  // To be provided externally
  // Trigger to start transmission
  input i_tx_dv,
  // baud rate clock (9600) from Baud_Rate_Genrator, not the system block (10MHz)
  input i_tx_clk,
  input i_tx_rst_n,
  input [7:0] i_tx_byte,
  // o_tx_out is the current bit that is transmitted on the line
  output reg o_tx_serial,
  output reg o_tx_active,
  output reg o_tx_done
  );
  
  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA = 2'b10;
  localparam STOP = 2'b11;
  
  reg [1:0] r_tx_state;
  // Used to buffer incoming data
  reg [7:0] r_tx_byte;
  reg [2:0] r_tx_bit_index;
  
  // State transisition
  always @(posedge i_clk or negedge i_tx_rst_n) begin
    if (i_tx_rst_n) begin 
      r_tx_state <= IDLE;   
    end
    else begin
      case (r_tx_state)
        IDLE: begin
          o_tx_serial <= 1'b1;
          o_tx_active <= 1'b0;
          o_tx_done <= 1'b0;
          r_tx_bit_index <= 3'd0;
          
          if (i_tx_dv) begin
            r_tx_byte <= i_tx_byte;
            o_tx_active <= 1'b1;
            r_tx_state <= START;
          end 
          else begin
            r_tx_state <= IDLE;
          end  
        end
        
        START: begin
          // Send start bit
          o_tx_active <= 1'b1;
          
          if (i_tx_clk) begin            
            o_tx_serial <= 1'b0; 
            r_tx_state <= DATA; 
          end
        end
          
        DATA: begin
          // Send data bits
          o_tx_active <= 1'b1;
          
          if (i_tx_clk) begin
            o_tx_serial <= r_tx_byte[r_tx_bit_index];
            
            if (r_tx_bit_index == 3'd7) begin
              r_tx_state <= STOP;
            end
            else begin
              r_tx_bit_index <= r_tx_bit_index + 1;
            end
          end
        end
          
        STOP: begin
          // Send stop bit
          o_tx_active <= 1'b1;
          
          if (i_tx_clk) begin
            o_tx_serial <= 1'b1;
            o_tx_done <= 1'b1;
            r_tx_state <= IDLE;
          end
        end
        
        default: r_tx_state <= IDLE;
      endcase
    end 
  end
endmodule
