`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 02:36:46 PM
// Design Name: 
// Module Name: FIFO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Note: A problem with putting the Read & Write operations in the same
// if clause with Reset,
//  if (!i_rst_n) begin
//    ...
//  end
//  else if (!o_full && i_wr_en) begin
//    ...
//  end 
//  else if (!o_empty && i_rd_en) begin
//    ...
//  end
// is that because the BRAM template does not have a reset input, so the
// compilier won't infer a BRAM, it infers thousands of FFs isntead. So we
// need to move the Write and Read operations out into their own always
// block.
// Doing this also allows us to remove the simultaneous Read & Write block
// as both the Read and Write block can execute independently and simultaneously
// on their own now. The current code below shows that.
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sync_FIFO #( parameter WIDTH = 8,
                    parameter DEPTH = 64)
  ( 
  input                   i_clk, 
                          i_rst_n, 
                          i_wr_en, 
                          i_rd_en,
  input       [WIDTH-1:0] i_data_in,
  output reg  [WIDTH-1:0] o_data_out,
  output                  o_full, 
                          o_empty
  );
  
  reg [WIDTH-1:0]         fifo_mem [DEPTH-1:0]; 
  reg [$clog2(DEPTH)-1:0] r_wr_ptr;
  reg [$clog2(DEPTH)-1:0] r_rd_ptr;
  reg [$clog2(DEPTH):0]   r_fifo_counter = 0;
  
  // Reset
  always @(posedge i_clk) begin
    if (!i_rst_n) begin 
      r_wr_ptr <= 0;  
      r_rd_ptr <= 0;
      r_fifo_counter <= 0;
    end
    else begin
      if (!o_full && i_wr_en) begin
        // Handle bookkeeping (pointer + counter) for Write
        r_wr_ptr <= r_wr_ptr + 1;
      end
      if (!o_empty && i_rd_en) begin
        // Handle bookkeeping (pointer + counter) for Read
        r_rd_ptr <= r_rd_ptr + 1;
      end
      
      if ((i_wr_en && !o_full) && !(i_rd_en && !o_empty)) begin
        // Pure Write Only
        r_fifo_counter <= r_fifo_counter + 1; 
      end
      else if (!(i_wr_en && !o_full) && (i_rd_en && !o_empty)) begin
        // Pure Read Only
        r_fifo_counter <= r_fifo_counter - 1; 
      end
      // If both are true (simultaneous) or both are false (idle), 
      // r_fifo_counter keeps its current value
    end  
  end
  
  // Write to memory
  always @(posedge i_clk) begin
    if (!o_full && i_wr_en) begin
      fifo_mem[r_wr_ptr] <= i_data_in;
    end
  end
  
  // Read to memory 
  always @(posedge i_clk) begin  
    if (!o_empty && i_rd_en) begin
      o_data_out <= fifo_mem[r_rd_ptr];
    end 
  end
  
  // Output flag
  assign o_full = (r_fifo_counter == DEPTH);
  assign o_empty = (r_fifo_counter == 0);
endmodule
