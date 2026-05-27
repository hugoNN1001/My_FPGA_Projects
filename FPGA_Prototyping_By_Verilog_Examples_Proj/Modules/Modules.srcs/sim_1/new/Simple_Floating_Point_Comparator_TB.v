`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2025 12:05:57 PM
// Design Name: 
// Module Name: Simple_Floating_Point_Comparator_TB
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


module Simple_Floating_Point_Comparator_TB(

    );
    
    reg [12:0] a, b;
    wire gt, lt, eq;
    
    Simple_Floating_Point_Comparator UUT (
    .a(a),
    .b(b),
    .gt(gt), 
    .lt(lt), 
    .eq(eq));
    
    initial begin
       // Test 1: Both Positive (a > b)
      #1;
      a = 13'b0_0010_10110001;
      b = 13'b0_0001_10110001;
      #2;
      assert (gt == 1 && lt == 0 && eq == 0)
        else $fatal("Error");
      
      // TEST 2: Both Negative (mag_a > mag_b means a < b)
      #1;
      a = 13'b1_0010_10110001;
      b = 13'b1_0010_10110000;
      #2;
      // Both a and b are negative, even if mag_a > mag_b by a bit, a < b
      assert (gt == 0 && lt == 1 && eq == 0)
        else $fatal("Error");
      
      // TEST 3: a Negative, b Positive (a < b)
      #1;
      a = 13'b1_0110_10110001;
      b = 13'b0_0011_11110001;
      #2;
      // As long as a is negative * b is positive, a < b
      assert (gt == 0 && lt == 1 && eq == 0)
        else $fatal("Error");
      
      // TEST 4: a Positive, b Negative (a > b)
      #1;
      a = 13'b0_0010_10100101;
      b = 13'b1_0111_10110001;
      #2;
      // As long as a is positive * b is negative, a > b
      assert (gt == 1 && lt == 0 && eq == 0)
        else $fatal("Error");
      
      // TEST 5: Equality (a = b)
      #1;
      a = 13'b1_0010_10100101;
      b = 13'b1_0010_10100101;
      #2;
      // a = b
      assert (gt == 0 && lt == 0 && eq == 1)
        else $fatal("Error");
        
      #1;
      $display("Successful!");
    end
endmodule
