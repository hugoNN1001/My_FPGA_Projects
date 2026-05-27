`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2026 08:43:14 AM
// Design Name: 
// Module Name: FP_And_Signed_Int_Conversion_TB
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


module FP_And_Signed_Int_Conversion_TB();
  reg [12:0] i_FP;
  reg [7:0] i_Signed_Int;
  reg i_Mode;
  
  wire [12:0] o_FP;
  wire [7:0] o_Signed_Int;
  wire o_UF;
  wire o_OF;
  
  FP_And_Signed_Int_Conversion UUT(
  .i_FP(i_FP),
  .i_Signed_Int(i_Signed_Int),
  .i_Mode(i_Mode), // 1:FP->SI, 0: SI->FP
  .o_FP(o_FP),
  .o_Signed_Int(o_Signed_Int),
  .o_UF(o_UF),
  .o_OF(o_OF));
  
  initial begin
    // Test 1: positive FP -> SI
    #1;
    i_FP = 13'b0_0101_11011010; // 27.25
    i_Mode = 1'b1;
    #2;
    assert (o_Signed_Int == 8'd27) else
      // Should actually be 27.25 but got truncated (rounded towards zero)
      $fatal("Test 1 failed");
    
    // Test 2: negative FP -> SI
    #1;
    i_FP = 13'b1_0011_10111101; // -5.90625
    i_Mode = 1'b1;
    #2;
    assert (o_Signed_Int == -8'sd5) else
      // Should actually be 5.90625 but got truncated (rounded towards zero)
      $fatal("Test 2 failed");
      
    // Test 3: underflow
    #1;
    i_FP = 13'b1_0000_10111101; // 0.73828125
    i_Mode = 1'b1;
    #2;
    assert (o_UF == 1'b1 && 
            o_OF == 1'b0 &&
            o_Signed_Int == 8'sd0) else
      // Should actually be 5.90625 but got truncated (rounded towards zero)
      $fatal("Underflowing not working");
    
    // Test 4a: positive overflow
    #1;
    i_FP = 13'b0_1100_10111101; // 3024
    i_Mode = 1'b1;
    #2;
    assert (o_OF == 1'b1 && 
            o_UF == 1'b0 &&
            o_Signed_Int == 8'sd127) else
      // Should actually be 5.90625 but got truncated (rounded towards zero)
      $fatal("Positive overflow not working");
    
    // Test 4b: negative overflow
    #1;
    i_FP = 13'b1_1100_10111101; // -3024
    i_Mode = 1'b1;
    #2;
    assert (o_OF == 1'b1 && 
            o_UF == 1'b0 &&
            o_Signed_Int == -8'sd128) else
      // Should actually be 5.90625 but got truncated (rounded towards zero)
      $fatal("Negative overflow not working");
      
    // Test 5: positive SI -> FP
    #1;
    i_Signed_Int = 8'b0110_0111; // 103
    i_Mode = 1'b0;
    #2;
    assert (o_FP == 13'b0_0111_11001110) else
      $fatal("Test 5 failed");
    
    // Test 6: negative SI -> FP
    #1;
    i_Signed_Int = 8'b1111_0011; // -13
    i_Mode = 1'b0;
    #2;
    assert (o_FP == 13'b1_0100_11010000) else
      // i_Signed_Int_mag = 0000_1101
      // << 4 = 1101_0000;
      $fatal("Test 6 failed");
      
    // Test 7: -128 -> FP
    #1;
    i_Signed_Int = 8'b1000_0000; // -128
    i_Mode = 1'b0;
    #2;
    assert (o_FP == 13'b1_1000_10000000) else
      $fatal("Test 7 failed");
    
    $display ("All tests passed");
    $finish;
  end
endmodule
