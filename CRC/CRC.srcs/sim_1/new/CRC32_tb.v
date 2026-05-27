`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2026 07:51:17 PM
// Design Name: 
// Module Name: CRC32_tb
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


module CRC32_tb();

  reg clk = 0;
  reg rst_n = 0;
  reg init = 0;
  reg dv = 0;
  reg [7:0] data_in = 0;
  
  wire [31:0] crc_out;
  
  CRC32 UUT(
  .i_clk(clk),
  .i_rst_n(rst_n),
  .i_init(init),
  .i_dv(dv),
  .i_data_in(data_in),
  .o_crc_out(crc_out)
  );
  
  always #50 clk = ~clk;
  
  initial begin
    @(posedge clk);
    rst_n = 1;
    init = 1;
    @(posedge clk);
    init = 0;
    
    send_byte(8'h31); // '1'
    send_byte(8'h32); // '2'
    send_byte(8'h33); // '3'
    send_byte(8'h34); // '4'
    send_byte(8'h35); // '5'
    send_byte(8'h36); // '6'
    send_byte(8'h37); // '7'
    send_byte(8'h38); // '8'
    send_byte(8'h39); // '9'
    
    @(posedge clk);
    dv = 0;

    assert (crc_out === 32'hCBF43926)
      $display("[ASSERT PASSED] CRC matches IEEE 802.3 standard: 0x%h", crc_out);
    else 
      $error("[ASSERT FAILED] Expected 0xCBF43926, but UUT produced 0x%h", crc_out);
    
    @(posedge clk);
    $finish(2);
  end
  
  // Task to send a byte
  task send_byte (input [7:0] data);
    begin
      @(posedge clk);
      dv = 1;
      data_in = data;
    end
  endtask
  
endmodule
