`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2026 10:53:17 AM
// Design Name: 
// Module Name: Parking_Lot_Counter
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


module Parking_Lot_FSM(
  input i_Clk,
  input i_Rst,
  input i_LS_A, i_LS_B, // LS: light sensor
  output reg o_Enter, o_Exit
  );
  
  // States enumeration
  localparam IDLE = 3'b000,
             ENT_A = 3'b001,
             ENT_AB = 3'b010,
             ENT_B = 3'b011,
             EXT_A = 3'b100,
             EXT_AB = 3'b101,
             EXT_B = 3'b110;
  
  // Signal declarations
  reg [2:0] state_reg, state_next;
  // Lot can hold max 16 cars
  reg [3:0]r_No_Cars; 
  
  always @(posedge i_Clk) begin
    if (i_Rst) begin
      state_reg <= IDLE;
      r_No_Cars <= 4'b0;
    end
    else begin
      state_reg <= state_next;
    end
  end
  
  always @(*) begin
    // Default:
    state_next = state_reg; // remain same state
    o_Enter = 1'b0;
    o_Exit = 1'b0;
    
    case (state_reg) 
      IDLE: begin
        // Entering
        if      (i_LS_A & !i_LS_B)  state_next = ENT_A;  // moving forward
        // Exiting
        else if      (!i_LS_A & i_LS_B)  state_next = EXT_B;  // moving forward
        else if (!i_LS_A & !i_LS_B) state_next = state_reg;  // staying put 
      end
      
      // Entering
      ENT_A: begin
        if      (i_LS_A & i_LS_B)  state_next = ENT_AB;  // moving forward
        else if (!i_LS_A & !i_LS_B) state_next = IDLE;  // moving backward
        else if (i_LS_A & !i_LS_B) state_next = state_reg;  // staying put
      end
      ENT_AB: begin
        if      (!i_LS_A & i_LS_B)  state_next = ENT_B;  // moving forward
        else if (i_LS_A & !i_LS_B) state_next = ENT_A;  // moving backward
        else if (i_LS_A & i_LS_B) state_next = state_reg;  // staying put
      end
      ENT_B: begin
        if      (!i_LS_A & !i_LS_B) begin state_next = IDLE; o_Enter = 1'b1; r_No_Cars = r_No_Cars + 1; end  // moving forward
        else if (i_LS_A & i_LS_B) state_next = ENT_AB;  // moving backward
        else if (!i_LS_A & i_LS_B) state_next = state_reg;  // staying put
      end
      
      // Exiting
      EXT_B: begin
        if      (i_LS_A & i_LS_B) state_next = EXT_AB;  // moving forward
        else if (!i_LS_A & !i_LS_B) state_next = IDLE;  // moving backward
        else if (!i_LS_A & i_LS_B) state_next = state_reg;  // staying put
      end
      EXT_AB: begin
        if      (i_LS_A & !i_LS_B) state_next = EXT_A;  // moving forward
        else if (!i_LS_A & i_LS_B) state_next = EXT_B;  // moving backward
        else if (i_LS_A & i_LS_B) state_next = state_reg;  // staying put
      end
      EXT_A: begin
        if      (!i_LS_A & !i_LS_B) begin state_next = IDLE; o_Exit = 1'b1; r_No_Cars = r_No_Cars - 1; end  // moving forward
        else if (i_LS_A & i_LS_B) state_next = EXT_AB;  // moving backward
        else if (i_LS_A & !i_LS_B) state_next = state_reg;  // staying put
      end
    endcase
  end
endmodule
