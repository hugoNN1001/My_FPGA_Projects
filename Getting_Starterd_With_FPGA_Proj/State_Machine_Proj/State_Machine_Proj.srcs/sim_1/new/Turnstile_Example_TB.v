`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2025 02:17:52 PM
// Design Name: 
// Module Name: Turnstile_Example_TB
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


module Turnstile_Example_TB();
  reg r_Clk = 1'b0, r_Rst = 1'b0, r_Coin = 1'b0, r_Push = 1'b0;
  wire w_Locked;
  
  Turnstile_Example UUT 
  (.i_Clk(r_Clk),
   .i_Rst(r_Rst),
   .i_Coin(r_Coin),
   .i_Push(r_Push),
   .o_Locked(w_Locked));
   
    always #1 r_Clk <= ~r_Clk;
   
    initial begin
      r_Rst <= 1'b1;
      #2;
      r_Rst <= 1'b0;
      #2;
      assert (w_Locked == 1'b1);
      
      #2;
      r_Coin <= 1'b1;
      #2;
      assert (w_Locked == 1'b0);
      
      #2;
      r_Push <= 1'b1;
      #2;
      assert (w_Locked == 1'b1);
      
      #2;
      r_Coin <= 1'b0;
      #2;
      assert (w_Locked == 1'b1);
      
      #2;
      r_Push <= 1'b0;
      #4;
      assert (w_Locked == 1'b1);
      
      $finish();
    end 
endmodule
