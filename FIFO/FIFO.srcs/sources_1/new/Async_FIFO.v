  `timescale 1ns / 1ps
  //////////////////////////////////////////////////////////////////////////////////
  // Company: 
  // Engineer: 
  // 
  // Create Date: 05/18/2026 04:07:39 PM
  // Design Name: 
  // Module Name: Async_FIFO
  // Project Name: 
  // Target Devices: 
  // Tool Versions: 
  // Description: DEPTH should be a power of 2. Sickly overflow/underflow flag needs a hard reset 
  // to deassert. Once overflown/underflown, incoming write data are dropped and read data are garbage.
  // AF/AE flags are used for backpressure with a buffer size of 4, meaning AF will assert if 
  // wr_fifo_count >= DEPTH - 4 and AE will assert if rd_fifo_count <= 4.
  //   
  //
  // Dependencies: 
  // 
  // Revision:
  // Revision 0.01 - File Created
  // Additional Comments:
  // 
  //////////////////////////////////////////////////////////////////////////////////
  
  
  module Async_FIFO #(parameter WIDTH = 8,
                      parameter DEPTH = 64) 
    (
    // Write domain
    input                   i_wr_clk, 
    input                   i_wr_rstn, 
    input                   i_wr_en, 
    input [WIDTH-1:0]       i_data_in,
    output reg              o_overflow, o_AF,
    output                  o_full,
     
    // Read domain
    input                   i_rd_clk,
    input                   i_rd_rstn,
    input                   i_rd_en,
    output reg [WIDTH-1:0]  o_data_out,
    output reg              o_underflow, o_AE,
    output                  o_empty
    );
    
    localparam ADDR_W = $clog2(DEPTH);
    // One extra wrap bit for PTR_W to help with FULL/EMPTY detection
    localparam PTR_W = ADDR_W + 1;
    // Backpressure
    localparam AF_VAL = DEPTH - 4;
    localparam AE_VAL = 4;
    
    // DEPTH Legality Check
    initial begin
      if ((DEPTH & (DEPTH-1)) != 0) begin
        $error("DEPTH must be power of 2!");
      end
    end
    
    reg   [WIDTH-1:0]   fifo_mem [DEPTH-1:0];
    
    // ---------- Write Signal Declarations ---------- 
    // Pointers include one extra wrap bit
    reg   [PTR_W-1:0]   r_wr_ptr_bin = 0;
    wire  [PTR_W-1:0]   w_wr_ptr_gray,
                        w_wr_ptr_gray_sync,
                        // Synced binary read pointer converted from synced gray-coded read pointer
                        w_rd_ptr_bin_sync,
                        w_wr_fifo_count;
                        
    // ---------- Read Signal Declarations ----------  
    // Pointers include one extra wrap bit                      
    reg   [PTR_W-1:0]   r_rd_ptr_bin;
    wire  [PTR_W-1:0]   w_rd_ptr_gray,
                        w_rd_ptr_gray_sync,
                        // Synced binary write pointer converted from synced gray-coded write pointer
                        w_wr_ptr_bin_sync,
                        w_rd_fifo_count;
    
    // ---------- Write Operation ----------
    // Instantiate wr_bin2gray
    Bin2Gray #(.N(PTR_W)) wr_Bin2Gray_inst (
    .i_bin(r_wr_ptr_bin),
    .o_gray(w_wr_ptr_gray)
    );
    
    // Synchronize w_wr_ptr_gray to rd_clk domain
    Two_FF_Synchronizer #(.N(PTR_W)) Wr_Synchronizer_isnt(
      .i_clk(i_rd_clk),
      .i_in(w_wr_ptr_gray),
      .o_out(w_wr_ptr_gray_sync)
    );
    
    // Instantiate wr_Gray2Bin for BACKPRESSURE
    Gray2Bin #(.N(PTR_W)) wr_Gray2Bin_inst (
    .i_gray(w_rd_ptr_gray_sync),
    .o_bin(w_rd_ptr_bin_sync)
    );
    
    assign w_wr_fifo_count = r_wr_ptr_bin - w_rd_ptr_bin_sync;
    
    always @(posedge i_wr_clk or negedge i_wr_rstn) begin
      if (!i_wr_rstn) begin
        r_wr_ptr_bin <= 0;
        o_overflow <= 0;
        o_AF <= 0;
      end
      else begin
        // Calculate AF flag every clk cycle
        o_AF <= (w_wr_fifo_count >= AF_VAL);
        
        if (o_full && i_wr_en) begin
          o_overflow <= 1;
        end 
        else if (!o_full && i_wr_en) begin
          fifo_mem[r_wr_ptr_bin[ADDR_W-1:0]] <= i_data_in;
          r_wr_ptr_bin <= r_wr_ptr_bin + 1;
        end
      end
    end
    
    // ---------- Read Operation ----------                                        
    // Instantiate rd_Bin2Gray
    Bin2Gray #(.N(PTR_W)) rd_Bin2Gray_inst (
    .i_bin(r_rd_ptr_bin),
    .o_gray(w_rd_ptr_gray)
    );
    
    // Instantiate rd_Gray2Bin for BACKPRESSURE
    Gray2Bin #(.N(PTR_W)) rd_Gray2Bin_inst (
    .i_gray(w_wr_ptr_gray_sync),
    .o_bin(w_wr_ptr_bin_sync)
    );
    
    assign w_rd_fifo_count = w_wr_ptr_bin_sync - r_rd_ptr_bin;
    
    // Synchronize w_rd_ptr_gray to wr_clk domain
    Two_FF_Synchronizer #(.N(PTR_W)) Rd_Synchronizer_isnt (
      .i_clk(i_wr_clk),
      .i_in(w_rd_ptr_gray),
      .o_out(w_rd_ptr_gray_sync)
    );
    
    always @(posedge i_rd_clk or negedge i_rd_rstn) begin
      if (!i_rd_rstn) begin
        r_rd_ptr_bin <= 0;
        o_underflow <= 0;
        o_AE <= 0;
      end
      else begin
        // Calculate AE flag every clk cycle
        o_AE <= (w_rd_fifo_count <= AE_VAL);
        
        if (o_empty && i_rd_en) begin
          o_underflow <= 1;      
        end
        else if (!o_empty && i_rd_en) begin
          o_data_out <= fifo_mem[r_rd_ptr_bin[ADDR_W-1:0]];
          r_rd_ptr_bin <= r_rd_ptr_bin + 1;
        end
      end
    end
    
    // ---------- EMPTY & FULL detection ----------
    assign o_empty = (w_rd_ptr_gray == w_wr_ptr_gray_sync);
    // FULL is detected when write pointer is eactly one full cycle ahead of read pointer
    assign o_full = (w_wr_ptr_gray == {~w_rd_ptr_gray_sync[PTR_W-1:PTR_W-2],
                                        w_rd_ptr_gray_sync[PTR_W-3:0]});
    
    
  endmodule
