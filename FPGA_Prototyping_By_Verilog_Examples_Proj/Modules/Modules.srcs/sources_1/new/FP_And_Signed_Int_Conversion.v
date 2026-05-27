`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2025 02:01:13 PM
// Design Name: 
// Module Name: FP_And_Signed_Int_Conversion
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


module FP_And_Signed_Int_Conversion(
  input [12:0] i_FP,
  input [7:0] i_Signed_Int,
  input i_Mode, // 1:FP->SI, 0: SI->FP
  output reg [12:0] o_FP,
  output reg [7:0] o_Signed_Int,
  output reg o_UF,
  output reg o_OF);
  
  // i_FP breakdown
  wire FP_sign = i_FP[12];
  wire [3:0] FP_exp = i_FP[11:8];
  wire [7:0] FP_frac = i_FP[7:0];
  
  // o_FP breakdown
  reg FP_sign_out;
  reg [3:0] FP_exp_out;
  reg [7:0] FP_frac_out;
  
  // SI breakdown
  wire Signed_Int_sign = i_Signed_Int[7];
  reg [7:0] Signed_Int_mag; 
  
  // FP_frac is 8-bit wide and can only be shifted by 7 bits max
  // e.g. 0.1000_0000 << 8 = 1000_0000 (-128)
  // so temp_shifting_reg is 15-bit wide
  reg [15:0] temp_shifting_reg;
  
  always @(*) begin
    // Assign these outputs so it won't create a latch
    o_UF = 1'b0;
    o_OF = 1'b0;
    o_FP = 13'd0;
    o_Signed_Int = 8'd0;
    
    if (i_Mode == 1'b1) begin
      // FP->SI mode
      if (FP_exp == 0) begin
        // FP is too small to be represted by a signed integer
        // -> underflow
        o_UF = 1'b1;
        o_Signed_Int = 8'd0;
      end 
      else if (FP_exp > 7) begin
        // FP is too large to be represented by an 8-bit signed integer,
        // which can hold 127 max, e.g. 0.1000_0000 (smallest, valid FP_frac) << 8
        // = 1000_0000 = 128
        // -> overflow
        o_OF = 1'b1;
        o_Signed_Int = (FP_sign) ? 8'b1000_0000 : 8'b0111_1111;
      end 
      else begin  
        temp_shifting_reg = {8'b0, FP_frac} << FP_exp; 
        // Take the whole number part
        if (FP_sign == 1'b0) begin
          // FP is positive
          o_Signed_Int = {temp_shifting_reg[15:8]};
        end else begin
          // FP is negative
//           o_Signed_Int = ~{1'b1, temp_shifting_reg[14:8]} + 1;
//           I want to mention this is not the correct because temp_shifting_reg[14:8]
//           is only 7-bit wide so it cannot represent 128, which is to de negated and add 1
//           to make it -128
          o_Signed_Int = ~temp_shifting_reg[15:8] + 1;
        end
      end
    end
    else begin
      // SI->FP mode  
      Signed_Int_mag = (Signed_Int_sign == 1'b0) ? {1'b0, i_Signed_Int[6:0]} : (~i_Signed_Int + 1);
          
      casez (Signed_Int_mag)
        8'b1???_????: begin
          FP_exp_out = 4'd8;
          FP_frac_out = Signed_Int_mag << 0;
        end
        8'b01??_????: begin
          FP_exp_out = 4'd7;
          FP_frac_out = Signed_Int_mag << 1;
        end
        8'b001?_????: begin
          FP_exp_out = 4'd6;
          FP_frac_out = Signed_Int_mag << 2;
        end
        8'b0001_????: begin
          FP_exp_out = 4'd5;
          FP_frac_out = Signed_Int_mag << 3;
        end
        8'b0000_1???: begin
          FP_exp_out = 4'd4;
          FP_frac_out = Signed_Int_mag << 4;
        end
        8'b0000_01??: begin
          FP_exp_out = 4'd3;
          FP_frac_out = Signed_Int_mag << 5;
        end
        8'b0000_001?: begin
          FP_exp_out = 4'd2;
          FP_frac_out = Signed_Int_mag << 6;
        end
        8'b0000_0001: begin
          FP_exp_out = 4'd1;
          FP_frac_out = Signed_Int_mag << 7;
        end
        default: begin
          FP_exp_out = 4'd0;
          FP_frac_out = 8'd0;
        end
      endcase
      
      if (Signed_Int_sign == 1'b0) begin
        // SI is positive
        FP_sign_out = 1'b0;
        o_FP = {FP_sign_out, FP_exp_out, FP_frac_out};
      end
      else begin
        // SI is negative
        FP_sign_out = 1'b1;
        o_FP = {FP_sign_out, FP_exp_out, FP_frac_out};
      end
    end
  end
endmodule
