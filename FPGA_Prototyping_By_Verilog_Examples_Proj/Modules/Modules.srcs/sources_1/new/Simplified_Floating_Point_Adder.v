`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2025 01:23:16 PM
// Design Name: 
// Module Name: Simplified_Floating_Point_Adder
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


module Simplified_Floating_Point_Adder(
  input sign1, sign2,
  input [3:0] exp1, exp2,
  input [7:0] frac1, frac2,
  
  output sign_out,
  output [3:0] exp_out,
  output [7:0] frac_out);
  
  // Signal declaration
  // b: bigger, s: smaller, a: aligned, n: normalised
  reg signb, signs;
  reg [3:0] expb, exps, expn;
  reg [7:0] fracb, fracs, fraca, fracn;
  reg [3:0] exp_diff;
  reg [8:0] sum, sum_norm;  // Additional carry bit in sum
  reg [3:0] num_lead0s;
  
  
  always @(*) begin
    // Stage: sort to find the largest number
    if ({exp1, frac1} > {exp2, frac2}) begin
      signb = sign1;
      signs = sign2;
      expb = exp1;
      exps = exp2;
      fracb = frac1;
      fracs = frac2;
    end
    else begin
      signb = sign2;
      signs = sign1;
      expb = exp2;
      exps = exp1;
      fracb = frac2;
      fracs = frac1;
    end
    
    // Stage 2: align smaller number
    // Shifting the whole number right n bits is the same as
    // dividing by 2^n.
    // Here the fractional part is shifted right exp_diff bits,
    // which compensates the increase in the exponential part.
    exp_diff = expb - exps; // expb and exps are both unsigned so they don't need to follow the signed rule
    fraca = fracs >> exp_diff;
    
    // Stage 3: add/subtract
    if (signb == signs) begin
      sum = {1'b0, fracb} + {1'b0, fraca};
    end
    else begin
      sum = {1'b0, fracb} - {1'b0, fraca};
    end
    
    // 4rd stage: normalise
    // Case: leading 0's (normalised represenation means MSB of frac (sum[7]) = 1 )
    if (sum[7]) begin
      num_lead0s = 0; 
      // The reason num_lead0s = 0 here is because the fractional part is structured as
      // {sum[8].sum[7]sum[6]etc.}
    end
    else if (sum[6]) begin
      num_lead0s = 1;
    end
    else if (sum[5]) begin
      num_lead0s = 2;
    end
    else if (sum[4]) begin
      num_lead0s = 3;
    end
    else if (sum[3]) begin
      num_lead0s = 4;
    end
    else if (sum[2]) begin
      num_lead0s = 5;
    end
    else if (sum[1]) begin
      num_lead0s = 6;
    end
    else begin
      num_lead0s = 7;
    end
    
    sum_norm = sum << num_lead0s; // sum of the fractional part
    
    // Case: with carry-out bit
    if (sum[8]) begin
      // adding 1 to exp and shifting frac right by 1 bit
      // compensate each other to keep the number the same
      expn = expb + 1;
      fracn = sum[8:1];   
    end
    else if (num_lead0s > expb) begin // Too small to normalise, set to 0
      // expb is the current working exponent before normalisaion.
      // It is the limit to how many bits we can shift the 
      // frac part left
      expn = 0;
      fracn = 0;
    end 
    else begin
      expn = expb - num_lead0s;
      fracn = sum_norm;
    end
  end
  
  // Output
  assign sign_out = signb;
  assign exp_out = expn;
  assign frac_out = fracn;
endmodule
