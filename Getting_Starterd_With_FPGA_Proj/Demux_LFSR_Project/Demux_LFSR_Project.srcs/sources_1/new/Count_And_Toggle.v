`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2025 09:39:38 AM
// Design Name: 
// Module Name: Count_And_Toggle
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


module Count_And_Toggle #(parameter COUNT_LIMIT = 10)(
  input i_Clk,
  input i_Enable,
  output o_Toggle
  );
  
  reg [$clog2(COUNT_LIMIT)-1:0] r_Count = 0;
  reg r_Toggle = 1'b0;
  
  always @(posedge i_Clk) begin
    if (i_Enable) begin
      if (r_Count == 0) begin
        r_Count <= r_Count + 1;
      end
      else if (r_Count == COUNT_LIMIT-1) begin
        r_Toggle <= ~r_Toggle;
        r_Count <= 0;
      end
      else begin
        r_Count <= 0;
      end
    end
    else begin
      r_Count <= 0;
    end
  end  
endmodule
