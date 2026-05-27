`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2026 11:58:17 AM
// Design Name: 
// Module Name: Enhanced_Floating_Point_Adder
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

// This module adds two simplied floating point numbers, num1 and num2
// It rounds to the nearest even
module Enhanced_Floating_Point_Adder(
  input [12:0] i_Num1, i_Num2,
  output reg [12:0] o_Sum);
  
  // Signal declaration
  // b: bigger, s: smaller, a: aligned, n: normalised
  reg signb, signs;
  reg [3:0] expb, exps, expn;
  reg [7:0] fracb, fracs;
  reg [10:0] fracb_a, fracs_a;
  reg [3:0] shift_amt;  // shift_amt = exp_diff = expb - expa
  reg [11:0] frac_sum; // frac_sum = sum(fracb_a,fracs_a) hence an additional carry bit
  reg [10:0] frac_sum_n; // the carry bit is removed
  reg [3:0] num_lead0s;
  reg [8:0] OF_reg; // used to capture the carry out bit for o_Sum
  
//  reg sign_out;    We'll just use sign_out = signb 
  reg [3:0] exp_out;
  reg [7:0] frac_out;
  
  always @(*) begin
    // Stage 1: sort to find the number with the larger magnitude
    if (i_Num1[11:0] > i_Num2[11:0]) begin // compare the magnitude
      signb = i_Num1[12];
      signs = i_Num2[12];
      expb = i_Num1[11:8];
      exps = i_Num2[11:8];
      fracb = i_Num1[7:0];
      fracs = i_Num2[7:0];
    end
    else begin
      signb = i_Num2[12];
      signs = i_Num1[12];
      expb = i_Num2[11:8];
      exps = i_Num1[11:8];
      fracb = i_Num2[7:0];
      fracs = i_Num1[7:0];
    end
    
    // Stage 2: Align smaller number
    // Shifting the whole number right n bits is the same as
    // dividing by 2^n.
    // Here the fractional part is shifted right exp_diff bits,
    // which compensates the increase in the exponential part.
    // The shifted bits are not dropped, they are used to round the sum
    shift_amt = expb - exps; 
    
    // Last 3 bits are G(guard), R(round), S(sticky)
    // G = 0.5, R = 0.25, S represents anything after
    fracb_a = {fracb, 3'b000};
    fracs_a = {fracs, 3'b000};
    
    case (shift_amt) // shift_amt = exp_diff = expb - expa
      4'd0:
        fracs_a = {fracs, 3'b000}; 
      4'd1: 
        fracs_a = {1'b0, fracs, 2'b00}; // G=fracs[0], R=0, S=0
      4'd2:
        fracs_a = {2'b00, fracs, 1'b0}; // G=fracs[1], R=fracs[0], S=0
      default: begin
        if (shift_amt < 9) begin  
          fracs_a[10:3] = fracs >> shift_amt;
          fracs_a[2] = fracs[shift_amt - 1]; // G
          fracs_a[1] = fracs[shift_amt - 2]; // R
          fracs_a[0] = |(fracs & ((1 << (shift_amt - 2)) - 1));
        end
        else if (shift_amt == 9) begin
          fracs_a[10:2] = 9'b0;
          fracs_a[1] = fracs[7]; // MSB is the second-last shifted out bit (R)
          fracs_a[0] = |(fracs[6:0]); // Everything else is Sticky
        end
        else begin
          // Sticky only, everything is past Round
          fracs_a = 11'b0;
          fracs_a[0] = |(fracs[7:0]);
        end
        
      end  
    endcase
    
    // Stage 3: add/subtract
    if (signb == signs) begin
      frac_sum = fracb_a + fracs_a; // fractional part of output sum
    end
    else begin
      frac_sum = fracb_a - fracs_a;
    end
    
    // Stage 4: normalization
    // Initialize defaults to avoid latches and handle "Total Zero"
    expn       = expb;
    frac_sum_n = 11'b0;
    
    if (frac_sum[11] == 1'b1) begin
      // Case 1: there is a carry out
      // Shift right by 1, increment the exponent
      // Update S bit that falls off
      frac_sum_n[10:1] = frac_sum[11:2]; //frac_sum[2] = G, which is now R, frac_sum[3] = LSB, which is now G
      frac_sum_n[0] = frac_sum[0] | frac_sum[1]; // new S = old S | R because if old S = 0 and R = 1 then new S = 1
      
      expn = expb + 1;
    end
    else begin
      // Case 2: leading 0's (normalised represenation means MSB of frac = 1 )
      if (frac_sum[10]) begin
        num_lead0s = 0; 
        // Note: frac_sum[11] is the carry-out bit, but in this else statement the frac_sum[11] = 0}
        // Note: normal representation here means frac_sum[10] = 1,  not frac_sum[11] = 1
      end
      else if (frac_sum[9]) begin
        num_lead0s = 1;
      end
      else if (frac_sum[8]) begin
        num_lead0s = 2;
      end
      else if ( frac_sum[7]) begin
        num_lead0s = 3;
      end
      else if (frac_sum[6]) begin
        num_lead0s = 4;
      end
      else if (frac_sum[5]) begin
        num_lead0s = 5;
      end
      else if (frac_sum[4]) begin
        num_lead0s = 6;
      end
      else if (frac_sum[3]) begin
        num_lead0s = 7;
      end
      else if (frac_sum[2]) begin
        num_lead0s = 8;
      end
      else if (frac_sum[1]) begin
        num_lead0s = 9;
      end
      else if (frac_sum[0]) begin
        num_lead0s = 10;
      end
      else begin
        num_lead0s = 0;  // frac_sum = 0 so num_lead0s isn't relevant anymore
      end
      
      if (frac_sum == 12'b0 || num_lead0s > expb) begin
        // Here, the sum is either 0 or is too small so it's FTZ (num_lead0s > expb case).   
        // Note: should add that it should stop shifting if num_lead0s = expb 
        // The exponent of 0 is reserved for special cases like subnormals  
        frac_sum_n = 11'b0; 
        expn = 4'b0; 
        signb = 1'b0; // not necessary the sign of the bigger number, 
                      // we just use sign_b as the sign for the final output  
      end
      else begin
        // Remember normal representation here means frac_sum[10] = 1,  not frac_sum[11] = 1
        frac_sum_n = frac_sum[10:0] << num_lead0s;  // Shift only the fractional part (not the carry)
        expn = expb - num_lead0s;
      end
    end
    
    // If Stage 4 flagged a zero/underflow, bypass rounding
    if (expn == 0 && frac_sum_n == 0) begin
      frac_out = 8'b0;
      exp_out  = 4'b0;
    end
      
    // Stage 5: Rounding
    else if (!frac_sum_n[2]) begin
      // G=0, round down
      OF_reg = 9'b0;  // No OF possible in this branch, added here to avoid a latch
      frac_out = frac_sum_n[10:3];
      exp_out = expn;  // to avoid a latch
    end
    else if (frac_sum_n[2] && (frac_sum_n[1] | frac_sum_n[0])) begin
      // G=1&&(R=1|S=1), round up
      OF_reg = frac_sum_n[10:3] + 1'b1;
      frac_out = OF_reg[7:0];
      exp_out = expn + OF_reg[8];
    end
    else begin // frac_sum_n[2] && !frac_sum_n[1] && !frac_sum_n[0]
      // Round to even
      OF_reg = frac_sum_n[3] ? frac_sum_n[10:3] + 1'b1 : frac_sum_n[10:3];
      frac_out = OF_reg[7:0];
      exp_out = expn + OF_reg[8];
    end
    
    o_Sum = {signb, exp_out, frac_out};
  end  
endmodule
