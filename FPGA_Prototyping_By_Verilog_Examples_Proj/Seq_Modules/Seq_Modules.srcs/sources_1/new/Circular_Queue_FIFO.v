`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2026 02:49:57 PM
// Design Name: 
// Module Name: Circular_Queue_FIFO
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

// Read is like "remove out of FIFO"
// The code is divided into a register file (array_reg) 
// and FIFO controller (2 ptrs + 2 flags)
// The next-state logic examines the wr and rd signal and
// takes actions accordingly.
module Circular_Queue_FIFO 
  #(
    parameter N = 8, // number of bits in a word
              W = 4  // number of address bits
   )
   (
    input i_Clk, i_Rst,
    input wr, rd,
    input [N-1:0] wr_data,
    output empty, full,
    output [N-1:0] rd_data
    );
    
    reg [N-1:0] array_reg [2**W-1:0];
    reg [W-1:0] wr_ptr_reg, wr_ptr_next, wr_ptr_succ; 
    reg [W-1:0] rd_ptr_reg, rd_ptr_next, rd_ptr_succ;
    reg full_reg, full_next;
    reg empty_reg, empty_next;
    
    // Write Operation
    always @(posedge i_Clk) begin
      if (wr & !full_reg) begin
        array_reg[wr_ptr_reg] <= wr_data;
      end
    end
    
    // FIFO control logic
    // Register for read and write pointers
    always @(posedge i_Clk or posedge i_Rst) begin
      if (i_Rst) begin
        wr_ptr_reg <= 0;
        rd_ptr_reg <= 0;
        full_reg <= 1'b0;
        empty_reg <= 1'b1;
      end
      else begin
        wr_ptr_reg <= wr_ptr_next;
        rd_ptr_reg <= rd_ptr_next;
        full_reg <= full_next;
        empty_reg <= empty_next;
      end
    end
    
    // Next-state logic for read & write pointers
    always @(*) begin
      // Successive pointer values
      wr_ptr_succ = wr_ptr_reg + 1;
      rd_ptr_succ = rd_ptr_reg + 1;
      
      // Default: points and flags keep their values
      wr_ptr_next = wr_ptr_reg;
      rd_ptr_next = rd_ptr_reg;
      full_next = full_reg;
      empty_next = empty_reg;
      
      case ({wr,rd})
        // 2'b00:
          // no op
        2'b01:  // read only
          if (!empty_reg) begin
            rd_ptr_next = rd_ptr_succ;
            full_next = 1'b0;
            if (rd_ptr_succ == wr_ptr_reg) begin
              empty_next = 1'b1;
            end
          end
        2'b10:  // write only
          if (!full_reg) begin
            wr_ptr_next = wr_ptr_succ;
            empty_next = 1'b0;
            if (wr_ptr_succ == rd_ptr_reg) begin
              full_next = 1'b1;
            end
          end
        2'b11: begin  // read & write
          wr_ptr_next = wr_ptr_succ;
          rd_ptr_next = rd_ptr_succ;
        end
      endcase  
    end
    
    // Output logic
    assign empty = empty_reg;
    assign full = full_reg;
    assign rd_data = array_reg[rd_ptr_reg];
endmodule
