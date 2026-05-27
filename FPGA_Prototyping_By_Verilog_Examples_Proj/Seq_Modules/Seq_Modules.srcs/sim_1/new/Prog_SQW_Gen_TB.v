`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2026 07:24:54 AM
// Design Name: 
// Module Name: Prog_SQW_Gen_TB
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


module Prog_SQW_Gen_TB();
  
  // Main clock is 100MHz (T=10ns)
  localparam T = 10;
  
  reg i_Clk, i_Rst;
  reg [3:0] m, n;
  wire o_Q;
  
  Prog_SQW_Gen UUT (
  .i_Clk(i_Clk),
  .i_Rst(i_Rst),
  .m(m), // ON time: m*100ns
  .n(n), // OFF time: n*100ns
  .o_Q(o_Q));
  
  // Rising clk edge at 5ns, 15ns, 25ns, etc.
  initial i_Clk = 1'b0;
  always #(T/2) i_Clk = ~i_Clk;
  
  initial begin
    i_Rst = 1'b1;
    #(T);
    i_Rst = 1'b0;
  end
  
  initial begin
    @(negedge i_Rst);
    m = 2;
    n = 3;
    @(negedge i_Clk);
  end
endmodule
