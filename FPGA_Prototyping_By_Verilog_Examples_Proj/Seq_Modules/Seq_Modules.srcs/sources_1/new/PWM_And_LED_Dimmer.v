`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2026 08:36:36 AM
// Design Name: 
// Module Name: PWM_And_LED_Dimmer
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

// The duty cycle is w/16
module PWM_And_LED_Dimmer(
  input i_Clk,
  input i_Rst,
  input [3:0] w,
  output o_Q);
  
  // Onboard oscillator is 100MHz (10ns)
  localparam T = 10;
  
  reg [3:0] Counter_reg;
  
  // Sequential logic
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      Counter_reg <= 0;
    end
    else begin
      Counter_reg <= Counter_reg + 1;
    end
  end

  // Output logic
  assign o_Q = (Counter_reg < w);
endmodule
