`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2026 07:22:50 PM
// Design Name: 
// Module Name: Prog_SQW_Gen
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


module Prog_SQW_Gen (
  input i_Clk,
  input i_Rst,
  input [3:0] m,  // ON time: m*100ns
  input [3:0] n,  // OFF time: n*100ns
  output wire o_Q                              
  );
  
  // Onboard oscillator is 100MHz (10ns)
  localparam T = 10;
  
  // Signal declaration
  reg Q_reg, Q_next;
  reg [3:0] Counter_10ns_reg, Counter_10ns_next;
  reg Counter_10ns_tick;
  reg [3:0] Counter_100ns_reg, Counter_100ns_next;
  
  // 10ns counter (increments every 10ns)
  
  
  // Sequential block
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      Q_reg <= 1'b0;
      Counter_10ns_reg <= 4'b0;
      Counter_10ns_tick <= 1'b0;
      Counter_100ns_reg <= 4'b0;
    end
    else begin
      Q_reg <= Q_next;
      Counter_10ns_reg <= Counter_10ns_next;
      Counter_100ns_reg <= Counter_100ns_next;
    end
  end
  
  // Next-state logic block
  always @(*) begin
    // 10ns counter logic
    if (Counter_10ns_reg == 9) begin
      Counter_10ns_next = 4'b0; 
      Counter_10ns_tick = 1'b1;
    end
    else begin
      Counter_10ns_next = Counter_10ns_reg + 1;
      Counter_10ns_tick = 1'b0;
    end
    // 10ns counter logic
    
    if (Counter_10ns_tick) begin
      if (Q_reg == 1'b0 && Counter_100ns_reg == n-1) begin
        Q_next = 1'b1;
        Counter_100ns_next = 4'b0;
      end 
      else if (Q_reg == 1'b1 && Counter_100ns_reg == m-1) begin
        Q_next = 1'b0;
        Counter_100ns_next = 4'b0;
      end
      else begin
        Counter_100ns_next = Counter_100ns_reg + 1;
      end
    end
    else begin
      Q_next = Q_reg;
      Counter_100ns_next = Counter_100ns_reg;
    end
  end
  
  // Output block
  assign o_Q = Q_reg;
endmodule
