`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2026 10:48:59 PM
// Design Name: 
// Module Name: Ethernet_MAC_TX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Note: Only need to capture CRC output at the end of each packet
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Ethernet_MAC_TX(
  input i_clk,
  input i_rst_n,
  input i_mii_tx_clk,
  input s_axis_tvalid,
  input [7:0] s_axis_tdata,
  input s_axis_tlast,
  output reg o_mii_tx_en,
  output o_mii_tx_er,
  output reg [3:0] o_mii_txd,
  output s_axis_tready,
  output o_fifo_overflow,
  output o_fifo_underflow
  );
  
  // State declaration
  localparam IDLE = 3'b000;
  localparam PREAMBLE = 3'b001;
  localparam SFD = 3'b010;
  localparam DATA = 3'b011;
  localparam FCS = 3'b100;
  localparam INTER_PACKET_GAP = 3'b101;
  
  // Declare preamble byte
  localparam [7:0] ETH_PRE = 8'h55;
  // A preable nibble is the lower and upper 4 bits of the original preamble
  localparam [3:0] ETH_PRE_NIBBLE = ETH_PRE[3:0];
  
  // Declare SFD byte
  localparam [7:0] ETH_SFD = 8'hD5;
  localparam [3:0] ETH_SFD_LOW = ETH_SFD[3:0];
  localparam [3:0] ETH_SFD_HIGH = ETH_SFD[7:4];
  
  localparam INTER_PACKET_GAP_LENGTH = 96;
  reg [$clog2(INTER_PACKET_GAP_LENGTH)-1:0] r_gap_counter = 0;
  
  reg [2:0] state, next_state;
  
  reg [3:0] r_preamble_counter = 0;
  // Declare r_sfd_counter as 2-bit wide so when it's 2 (binary 10) 
  // it doesn't get intepreted as 0 (binary 0)
  reg [1:0] r_sfd_counter = 0;
  // Counter to send o_mii_txd in two nibbles from output of FIFO (w_fifo_data_out)
  reg [2:0] r_mii_txd_nibble_counter = 0;
  
  // To enable reading from FIFO
  reg r_fifo_rd_en;
  
  // 9-bit long wire to hold data read from FIFO, to be split into
  // 2 o_mii_txd nibbles + 1 tlast bit
  // w_mii_txd_byte = {s_axis_tlast, s_mii_txd_low, s_mii_txd_high}
  wire [8:0] w_fifo_data_out;
  wire w_fifo_tlast = w_fifo_data_out[8];
  wire [3:0] s_mii_txd_low = w_fifo_data_out[3:0];
  wire [3:0] s_mii_txd_high = w_fifo_data_out[7:4];
  
  wire w_fifo_full;
  wire w_fifo_empty;
  
  // 9-bit wide FIFO to store {s_axis_tlast, s_axis_tdata}
  Async_FIFO #(.WIDTH(9),
               .DEPTH(64)) 
  Async_FIFO_Inst             
  (.i_wr_clk(i_clk), 
   .i_wr_rstn(i_rst_n), 
   .i_wr_en(s_axis_tvalid && s_axis_tready), 
   .i_data_in({s_axis_tlast, s_axis_tdata}),
   .o_overflow(o_fifo_overflow), 
   .o_AF(),
   .o_full(w_fifo_full),
   .i_rd_clk(i_mii_tx_clk),
   .i_rd_rstn(i_rst_n),
   .i_rd_en(r_fifo_rd_en),
   .o_data_out(w_fifo_data_out),
   .o_underflow(o_fifo_underflow), 
   .o_AE(),
   .o_empty(w_fifo_empty)
   );
   
  reg             r_crc32_init = 1'b0;
  reg             r_crc32_dv = 1'b0;
  // Shift register to hold w_crc32_out and transmit it in 4-bit nibbles
  reg   [31:0]    r_crc32_shift_reg;
  wire  [31:0]    w_crc32_out; 
    
  CRC32 CRC32_Inst (
  .i_clk(i_mii_tx_clk),
  .i_rst_n(i_rst_n),
  .i_init(r_crc32_init),
  .i_dv(r_crc32_dv),
  .i_data_in({s_mii_txd_high, s_mii_txd_low}),
  .o_crc_out(w_crc32_out)
  );
  
  always @(posedge i_mii_tx_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      state <= IDLE;
    end
    else begin
      state <= next_state;
    end
  end
  
  always @(*) begin
    case (state)
      IDLE: begin
        if (!w_fifo_empty) begin
          next_state = PREAMBLE;
        end
      end
      PREAMBLE: begin
        if (r_preamble_counter < 13) begin
          next_state = PREAMBLE;
        end
        else begin
          next_state = SFD;
        end
      end
      SFD: begin
        if (r_sfd_counter < 2) begin
          next_state = SFD;
        end
        else begin
          next_state = DATA;
        end
      end
      DATA: begin
        if (r_mii_txd_nibble_counter == 1 && w_fifo_tlast) begin
          next_state = FCS;
        end
        else begin
          next_state = DATA;
        end
      end
      FCS: begin
        if (r_mii_txd_nibble_counter < 7) begin
          next_state = FCS;
        end
        else begin
          next_state = INTER_PACKET_GAP;
        end
      end
      INTER_PACKET_GAP: begin
        if (r_gap_counter < INTER_PACKET_GAP_LENGTH) begin
          next_state = INTER_PACKET_GAP;
        end
        else if (!w_fifo_empty) begin
          next_state = PREAMBLE;
        end
        else begin
          next_state = IDLE;
        end
      end
      
      default: next_state = IDLE;
    endcase
  end
  
  // Output Logic
  always @(posedge i_mii_tx_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      o_mii_tx_en <= 0;
      o_mii_txd <= 4'b0000;
    end
    
    // IDLE
    else if (state == IDLE) begin
      o_mii_tx_en <= 0;
      o_mii_txd <= 4'b0000;
    end
    
    // PREAMBLE
    else if (state == PREAMBLE) begin
      o_mii_tx_en <= 1'b1;
      o_mii_txd <= ETH_PRE_NIBBLE;
      r_preamble_counter <= r_preamble_counter + 1;
    end
    
    // SFD
    else if (state == SFD) begin
      o_mii_tx_en <= 1'b1;
      o_mii_txd <= (r_sfd_counter == 1'b0) ? ETH_SFD_LOW : ETH_SFD_HIGH;
      r_sfd_counter <= r_sfd_counter + 1;
      // Reset r_preamble_counter from PREAMBLE
      r_preamble_counter <= 0;
      
      // Start to read from FIFO for DATA state
      r_fifo_rd_en <= (r_sfd_counter == 1'b0) ? 1'b1 : 1'b0;
      
      // Initialize CRC32 for DATA
      r_crc32_init <= (r_sfd_counter == 2'b00) ? 1'b1 : 1'b0; 
    end
    
    // DATA
    else if (state == DATA) begin 
      o_mii_tx_en <= 1'b1;
      
      if (r_mii_txd_nibble_counter == 0) begin
        // Send s_mii_txd_low
        o_mii_txd <= s_mii_txd_low;
        r_mii_txd_nibble_counter  <= r_mii_txd_nibble_counter + 1;
        r_fifo_rd_en <= 1'b0;
        // Enalbe r_crc32_dv here, crc calculation finish next clock cycle
        r_crc32_dv <= 1'b1;
      end
      else begin
        // send s_mii_txd_high
        o_mii_txd <= s_mii_txd_high;
        r_mii_txd_nibble_counter  <= 0;
        r_crc32_dv <= 1'b0;
        
        // If this is the last byte, don't enable reading from FIFO again.
        r_fifo_rd_en <= (!w_fifo_tlast);
      end
    end
    
    // FCS
    else if (state == FCS) begin
      o_mii_tx_en <= 1'b1;
      
      // Transmit CRC32 result out in 4-bit nibbles
      if (r_mii_txd_nibble_counter == 0) begin
        o_mii_txd <= w_crc32_out[3:0];
        r_crc32_shift_reg <= w_crc32_out >> 4;
      end
      else begin
        o_mii_txd <= r_crc32_shift_reg[3:0];
        r_crc32_shift_reg <= r_crc32_shift_reg >> 4;
      end
      
      // Increment nibble counter for next iteration
      // Note nibble counter is reset to 0 in DATA
      r_mii_txd_nibble_counter <= r_mii_txd_nibble_counter + 1;
      
      // Reset r_gap_counter;
      r_gap_counter <= 0;
    end
    
    // INTER_PACKET_GAP
    else if (state == INTER_PACKET_GAP) begin
      r_gap_counter <= r_gap_counter + 1;
      
      o_mii_tx_en <= 1'b0;
      o_mii_txd <= 4'b0000;
      r_preamble_counter <= 0;
      r_sfd_counter <= 0;
      r_mii_txd_nibble_counter <= 0;
      
      r_fifo_rd_en <= 0;
    end
    else begin
      // Catch-all for illegal states in case of SEU
      o_mii_tx_en <= 1'b0;
      o_mii_txd   <= 4'b0000;
    end
  end
  
  assign s_axis_tready = !w_fifo_full;
endmodule
