`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2025 06:57:38 PM
// Design Name: 
// Module Name: Math_Examples
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


module Math_Examples();
  reg unsigned [3:0] i1_u4, i2_u4, o_u4;
  reg signed   [3:0] i1_s4, i2_s4, o_s4;
  
  reg unsigned [4:0] o_u5, i2_u5;
  reg signed   [4:0] o_s5, i1_s5, i2_s5;
  reg unsigned [5:0] o_u6;
  
  reg unsigned [7:0] o_u8, i_u8;
  reg signed   [7:0] o_s8;
  
  initial begin
    // Unsigned + Unsigned = Unsigned (Rule #1 violation)
    // Output should be 5-bit long
    i1_u4 = 4'b1001; // dec 9
    i2_u4 = 4'b1011; // dec 11
    o_u4  = i1_u4 + i2_u4;
    $display("Ex01: %2d + %2d = %3d", i1_u4, i2_u4, o_u4);
    
    // Signed + Signed = Signed (Rule #1 violation)
    // Output should be 5-bit long
    i1_s4 = 4'b1001; // dec -7
    i2_s4 = 4'b1011; // dec -5
    o_s4  = i1_s4 + i2_s4;
    $display("Ex02: %2d + %2d = %3d", i1_s4, i2_s4, o_s4);

    // Unsigned + Unsigned = Unsigned (Rule #1 Fix)
    i1_u4 = 4'b1001; // dec 9
    i2_u4 = 4'b1011; // dec 11
    o_u5  = i1_u4 + i2_u4;
    $display("Ex03: %2d + %2d = %3d", i1_u4, i2_u4, o_u5);

    // Signed + Signed = Signed (Rule #1 fix)
    i1_s4 = 4'b1001; // dec -7
    i2_s4 = 4'b1011; // dec -5
    o_s5  = i1_s4 + i2_s4;
    $display("Ex04: %2d + %2d = %3d", i1_s4, i2_s4, o_s5);
    
    // Unsigned - Unsigned = Unsigned (bad)
    // Remember to use signed types for subtraction
    i1_u4 = 4'b1001; // dec 9
	  i2_u4 = 4'b1011; // dec 11
    o_u5  = i1_u4 - i2_u4;
    $display("Ex05: %2d - %2d = %3d", i1_u4, i2_u4, o_u5);
    
    // Signed - Signed = Signed (fix)
    i1_u4 = 4'b1001; // dec 9
    i2_u4 = 4'b1011; // dec 11
    i1_s5 = i1_u4;
    i2_s5 = i2_u4;
    o_s5  = i1_s5 - i2_s5;
    $display("Ex06: %2d - %2d = %3d", i1_s5, i2_s5, o_s5);
    
    // Unsigned * Unsigned = Unsigned (Rule #4 violation)
    // Output should be at least the sum of each input's size
    i1_u4 = 4'b1001; // dec 9
    i2_u4 = 4'b1011; // dec 11
    o_u4  = i1_u4 * i2_u4;
    $display("Ex07: %2d * %2d = %3d", i1_u4, i2_u4, o_u4);

    // Signed * Signed = Signed (Rule #4 violation)
    // Output should be at least the sum of each input's size
    i1_s4 = 4'b1000; // dec -8
    i2_s4 = 4'b0111; // dec 7
    o_s4  = i1_s4 * i2_s4;
    $display("Ex08: %2d * %2d = %3d", i1_s4, i2_s4, o_s4);
    
    // Unsigned * Unsigned = Unsigned (Rule #4 fix)
    i1_u4 = 4'b1001; // dec 9
    i2_u4 = 4'b1011; // dec 11
    o_u8  = i1_u4 * i2_u4;
    $display("Ex09: %2d * %2d = %3d", i1_u4, i2_u4, o_u8);
    
    // Signed * Signed = Signed (Rule #4 fix)
    i1_s4 = 4'b1000; // dec -8
    i2_s4 = 4'b0111; // dec 7
    o_s8  = i1_s4 * i2_s4;
    $display("Ex10: %2d * %2d = %3d", i1_s4, i2_s4, o_s8);
    
    // Multiplication by powers of 2 (by shifting left)
    // Note: shifitng left drops the MSB and maintains width/size
    i_u8 = 3;
    o_u8 = i_u8 << 1; // 3 * 2
    $display("Ex11: %d * 2 = %d", i_u8, o_u8);
    o_u8 = i_u8 << 2; // 3 * 4
    $display("Ex12: %d * 4 = %d", i_u8, o_u8);
    o_u8 = i_u8 << 4; // 3 * 16
    $display("Ex13: %d * 16 = %d", i_u8, o_u8);
    
    // Division by powers of 2 (by shifting right)
    // Note: shifitng right drops the LSB and maintains width/size
    i_u8 = 128;
    o_u8 = i_u8 >> 1; // 128 / 2
    $display("Ex14: %d / 2 = %d", i_u8, o_u8);
    o_u8 = i_u8 >> 2; // 128 / 4
    $display("Ex15: %d / 4 = %d", i_u8, o_u8);
    o_u8 = i_u8 >> 4; // 128 / 16
    $display("Ex16: %d / 16 = %d", i_u8, o_u8);
    
    // Numbers not cleanly divisible by powers of 2 
    // are rounded down to the nearest integer. 
    i_u8 = 15;
    o_u8 = i_u8 >> 1; // 15 / 2
    $display("Ex17: %d / 2 = %d", i_u8, o_u8);
    o_u8 = i_u8 >> 2; // 15 / 4
    $display("Ex18: %d / 4 = %d", i_u8, o_u8);
    o_u8 = i_u8 >> 3; // 15 / 8
    $display("Ex19: %d / 16 = %d", i_u8, o_u8);
    
    // Demonstrate: Modified Q Notation Examples
    // U3.1 + U4.0 = U4.1 (Rule #5 violation)
    i1_u4 = 4'b0011;
    i2_u4 = 4'b0011;
    o_u5  = i1_u4 + i2_u4;
    $display("Ex20: %2.3f + %2.3f = %2.3f", i1_u4/2.0, i2_u4, o_u5/2.0);
    
    // Convert U3.1 to U4.0
    // U4.0 + U4.0 = U5.0 (Rule #5 fix, using truncation)
    i1_u4 = 4'b0011;
    i2_u4 = 4'b0011;
    i1_u4 = i1_u4 >> 1; 
    o_u5  = i1_u4 + i2_u4;
    $display("Ex21: %2.3f + %2.3f = %2.3f", i1_u4, i2_u4, o_u5);
    // Truncation reduces precision since LSB is dropped when shifting right.
    // This is 1.0 + 3.0 = 4.0 instead of 1.5 + 3.0 = 4.5
    
    // Or Convert U4.0 to U4.1
    // U3.1 + U4.1 = U5.1 (Rule #5 fix, using expansion)
    i1_u4 = 4'b0011;
    i2_u4 = 4'b0011;
    i2_u5 = i2_u4 << 1; // resize 2nd input to be 5-bit wide
    o_u6  = i1_u4 + i2_u5;  // also resize
    $display("Ex22: %2.3f + %2.3f = %2.3f", i1_u4/2.0, i2_u5/2.0, o_u6/2.0);
    // Expansion doesn't reduce precision, 1.5 + 3.0 = 4.5
    
    // Multiplication with Decimals
    // U2.2 * U3.1 = U5.3
    i1_u4 = 4'b0101;
    i2_u4 = 4'b1011;
    o_u8  = i1_u4 * i2_u4;
    $display("Ex23: %2.3f * %2.3f = %2.3f", i1_u4/4.0, i2_u4/2.0, o_u8/8.0);
    
    // S2.2 * S4.0 = S6.2
    i1_s4 = 4'b0110;
    i2_s4 = 4'b1010;
    o_s8  = i1_s4 * i2_s4;
    $display("Ex24: %2.3f * %2.3f = %2.3f", i1_s4/4.0, i2_s4, o_s8/4.0);
        
    $finish();
  end
endmodule
