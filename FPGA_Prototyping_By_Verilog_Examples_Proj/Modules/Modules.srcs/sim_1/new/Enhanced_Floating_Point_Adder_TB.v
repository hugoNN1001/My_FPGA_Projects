`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/02/2026 07:34:56 AM
// Design Name: 
// Module Name: Enhanced_Floating_Point_Adder_TB
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


module Enhanced_Floating_Point_Adder_TB();
  // Inputs
  reg [12:0] i_Num1, i_Num2;
  
  // Outputs
  wire [12:0] o_Sum;
  
  Enhanced_Floating_Point_Adder UUT (
  .i_Num1(i_Num1),
  .i_Num2(i_Num2),
  .o_Sum(o_Sum));
  
  task check_result (input string test_name, input [12:0] expected);
    begin
      #10;  // Wait for combinational logic to settle
      if (o_Sum == expected) begin
        $display("[PASS] %s | Input: %b, %b | Output: %b", test_name, i_Num1, i_Num2, o_Sum);
      end
      else begin
        $display("[FAIL] %s | Input: %b, %b | Output: %b (Expected: %b)", test_name, i_Num1, i_Num2, o_Sum, expected);
      end
    end
  endtask 
  
  initial begin
    $display("Starting Floating Point Adder Tests (Format: 0.f * 2^e)");
    $display("Format: [12]=Sign, [11:8]=Exp, [7:0]=Frac (Explicit 0.MSB)");
    $display("------------------------------------------------------------------");  
  
    // TEST 1: Simple Addition (Carry Out to Exponent) ---
    // 0.1000... * 2^8 + 0.1000... * 2^8 
    // Math: 0.5 * 256 + 0.5 * 256 = 128 + 128 = 256
    // Result: 1.000... * 2^8 -> Normalize -> 0.1000... * 2^9 (Value 256)
    i_Num1 = 13'b0_1000_10000000; 
    i_Num2 = 13'b0_1000_10000000;
    check_result("Carry Out Logic (0.1+0.1=1.0->0.1*2^exp+1)", 13'b0_1001_10000000);
    
    // TEST 2: Alignment and Simple Sum ---
    // 0.1000... * 2^8 + 0.0100... * 2^8 (which is 0.1 * 2^7 in norm format)
    // Math: 128 + 64 = 192
    // Result: 0.1100... * 2^8 (Value 192)
    i_Num1 = 13'b0_1000_10000000; 
    i_Num2 = 13'b0_0111_10000000;
    check_result("Alignment & Addition", 13'b0_1000_11000000);
    
    // TEST 3: Tie-to-Even (Round DOWN) ---
    // Fraction is even (ends in 0). Remainder is exactly 0.5 LSB.
    // i_Num2 will be shifted right by 8 bits -> G=1, R=0, S=0
    i_Num1 = 13'b0_1010_10101000;
    i_Num2 = 13'b0_0010_10000000;
    check_result("Tie-to-Even (Down)", 13'b0_1010_10101000);
    
    //  TEST 4: Tie-to-Even (Round UP) ---
    // Fraction is odd (ends in 1). Remainder is exactly 0.5 LSB.
    // i_Num2 will be shifted right by 8 bits -> G=1, R=0, S=0
    i_Num1 = 13'b0_1001_10100001; 
    i_Num2 = 13'b0_0001_10000000; 
    check_result("Tie-to-Even (Up)", 13'b0_1001_10100010);

    // TEST 5: Cancellation & Normalization (Shift Left) ---
    // 0.10000000 * 2^7 - 0.11111111 * 2^6
    // Math: 64 - 63.75 = 0.25
    // Result: 10000000_0000 = 01111111_100 = 00000000_100
    // => num_lead0s = 8 > exp (7) => o_Sum = 0
    i_Num1 = 13'b0_0111_10000000; 
    i_Num2 = 13'b1_0110_11111111; 
    check_result("Cancellation (Shift Left)", 13'b0_0000_00000000);

    // TEST 6: Subtraction leading to Zero ---
    i_Num1 = 13'b0_1110_11110000; 
    i_Num2 = 13'b1_1110_11110000;
    check_result("Full Subtraction to Zero", 13'b0_0000_00000000);
    
    // TEST 7: Rounding Overflow
    // Fraction 1111_1111 + rounding bit = carry out to exponent
    i_Num1 = 13'b0_0111_11111111; // 0.11111111 * 2^7
    i_Num2 = 13'b0_0011_10000000; // Small value that forces a round up
    check_result("Rounding Overflow", 13'b0_1000_10000100);        
    
    $display("Tests Completed.");
    $finish;
  end
endmodule
