`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2026 06:53:16 PM
// Design Name: 
// Module Name: Early_Detection_Debounce_Filter_TB
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


module Early_Detection_Debounce_Filter_TB();
  reg r_Clk;
  reg r_Rst;
  reg r_Level;
  wire w_Debouned;
  
  Early_Detection_Debounce_Filter UUT (
  .i_Clk(r_Clk),
  .i_Rst(r_Rst),
  .i_Level(r_Level),  // switch level
  .o_Debounced(w_Debounced));
  
  // Create a 10ns-period clock
  always #5 r_Clk = !r_Clk;
  
  initial begin
    r_Clk = 0;
    @(negedge r_Clk);
    
    // RESET
    r_Rst = 1;
    @(negedge r_Clk);
    r_Rst = 0;
    @(negedge r_Clk);
    
    // Start at zero
    r_Level = 0;
    #100;

    // --- RISING EDGE BOUNCE (The Press) ---
    r_Level = 1; #50;   // Initial strike
    r_Level = 0; #20;   // Bounce off
    r_Level = 1; #100;  // Strike again
    r_Level = 0; #40;   // Bounce off
    r_Level = 1; #200;  // Strike again
    r_Level = 0; #10;   // Tiny bounce
    r_Level = 1;        // Finally settled High
    
    // Hold for longer than your 20ms DEBOUNCE_LIMIT
    // 20ms = 20,000,000ns
    #25_000_000; 

    // --- FALLING EDGE BOUNCE (The Release) ---
    r_Level = 0; #100;  // Initial release
    r_Level = 1; #50;   // Spring back contact
    r_Level = 0; #80;   // Release again
    r_Level = 1; #20;   // Tiny spring back
    r_Level = 0;        // Finally settled Low
    
    #1000;
    $finish;
  end
endmodule
