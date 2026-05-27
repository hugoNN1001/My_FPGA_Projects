`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2025 09:49:54 AM
// Design Name: 
// Module Name: FIFO
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


module FIFO #(parameter WIDTH = 8,
              parameter DEPTH = 256) (
  input i_Clk,
  input i_Rst_L,
  
  // Write
  input i_Wr_DV,
  input [WIDTH-1:0] i_Wr_Data,
  input [$clog2(DEPTH)-1:0] i_AF_Level,
  output o_AF_Flag, // o_AF_Flag is high when there are MORE THAN DEPTH - i_AF_Level words in FIFO
  output o_Full,
  
  // Read
  input i_Rd_En,
  output o_Rd_DV,
  output reg [WIDTH-1:0] o_Rd_Data,
  input [$clog2(DEPTH)-1:0] i_AE_Level,
  output o_AE_Flag,
  output o_Empty
    );
    
  reg [$clog2(DEPTH)-1:0] r_Wr_Addr;
  reg [$clog2(DEPTH)-1:0] r_Rd_Addr;
  
  wire [WIDTH-1:0] w_Rd_Data;
  // RAM_2Port makes read data always available in its output.
  // Here we only want to output read data only when i_Rd_En is high 
  
  RAM_2Port #(.WIDTH(WIDTH), .DEPTH(DEPTH)) FIFO_Inst (
  // Write
  .i_Wr_Clk(i_Clk),
  .i_Wr_Addr(r_Wr_Addr),
  .i_Wr_DV(i_Wr_DV),
  .i_Wr_Data(i_Wr_Data),
  
  // Read
  .i_Rd_Clk(i_Clk),
  .i_Rd_Addr(r_Rd_Addr),
  .i_Rd_En(i_Rd_En),
  .o_Rd_DV(o_Rd_DV),
  .o_Rd_Data(w_Rd_Data)
  );
    
  reg [$clog2(DEPTH):0] r_Count; 
  // 1 more bit to hold r_Count because it starts 
  // from 0 (empty) and goes up to DEPTH (full)
  
  always @(posedge i_Clk or posedge i_Rst_L) begin
    // Reset
    if (i_Rst_L) begin
      r_Wr_Addr <= 0;
      r_Rd_Addr <= 0;
      r_Count   <= 0;
    end
    else begin
      // Write
      if (i_Wr_DV) begin
        if (r_Wr_Addr == DEPTH-1) begin
          r_Wr_Addr <= 0;
        end
        else begin
          r_Wr_Addr <= r_Wr_Addr + 1;
        end
      end
      
      // Read
      if (i_Rd_En) begin
        if (r_Rd_Addr == DEPTH-1) begin
          r_Rd_Addr <= 0;
        end
        else begin
          r_Rd_Addr <= r_Rd_Addr + 1;
        end
        
        o_Rd_Data <= w_Rd_Data;
      end
      
      // Keep track of the number of words in FIFO
      // r_Count decreases if only reading
      //         increases if only writing
      //         stays the same if reading & writing at once
      if (i_Rd_En & ~i_Wr_DV) begin
        if (r_Count != 0) begin
          r_Count <= r_Count - 1;
        end
      end  
      else if (i_Wr_DV & ~i_Rd_En) begin
        if (r_Count != DEPTH) begin
          r_Count <= r_Count + 1;
        end
      end
    end
  end
  
  // Assign flags
  assign o_Full = (r_Count == DEPTH) || (r_Count == DEPTH-1 && i_Wr_DV && !i_Rd_En);
  assign o_AF_Flag = (r_Count > DEPTH - i_AF_Level);
  assign o_Empty = (r_Count == 0) || (r_Count == 1 && i_Rd_En && !i_Wr_DV);
  assign o_AE_Flag = (r_Count < i_AE_Level);
  
  /////////////////////////////////////////////////////////////////////////////
  // ASSERTION CODE, NOT SYNTHESIZED (run this entire file but this section won't be translated
  // to hardware, only flags a error when there is one)
  // synthesis translate_off
  // Ensures that we never read from empty FIFO or write to full FIFO.
  always @(posedge i_Clk) begin
    if (r_Count == DEPTH && i_Wr_DV && !i_Rd_En) begin
      $error("Error! Writing Full FIFO");
    end
    
    if (r_Count == 0 && i_Rd_En && !i_Wr_DV) begin
      $error("Error! Reading Empty FIFO");
    end
  end
  // synthesis translate_on
  /////////////////////////////////////////////////////////////////////////////
endmodule
