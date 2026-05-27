`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2025 07:34:47 AM
// Design Name: 
// Module Name: Demux_LFSR_Proj_Top
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


module Demux_LFSR_Proj_Top(
    input i_Clk,
    input i_Enable,
    input i_Seed_DV,
    input i_Switch1,
    input i_Switch2,
    output o_LED1,
    output o_LED2,
    output o_LED3,
    output o_LED4
    );
    
    wire w_Enable_Pulse;
    
    Debounce_Filter #(.DEBOUNCE_LIMIT(1_000_000)) Enable_Btn_Inst
    (.i_Clk(i_Clk),
    .i_BouncyBtn(i_Enable),
    .o_DebouncedBtn_Level(),
    .o_DebouncedBtn_Pulse(w_Enable_Pulse)
    );
    
    reg r_Enable = 1'b0;
    
    always @(posedge i_Clk) begin
        if (w_Enable_Pulse) begin
          r_Enable <= ~r_Enable;
        end 
    end
    
    parameter COUNT_LIMIT = 16_777_216;
    wire w_Toggle;
    
    Count_And_Toggle #(.COUNT_LIMIT(COUNT_LIMIT)) Count_And_Toggle_Inst
    (.i_Clk(i_Clk),
    .i_Enable(r_Enable),
    .o_Toggle(w_Toggle));
     
    reg r_Toggling_Signal = 1'b0;
     
    Demux_1_To_4 Demux_1_To_4_Inst
    (.i_Data(r_Toggling_Signal),
    .i_Sel0(i_Switch1),
    .i_Sel1(i_Switch2),
    .o_Out0(o_LED1),
    .o_Out1(o_LED2),
    .o_Out2(o_LED3),
    .o_Out3(o_LED4));
    
 
//    wire r_debounced_rst;
//    reg r_debounced_rst_d;
//    wire r_debounced_enable;
      
//    Debounce_Btn Debounce_Btn_Inst
//    (.i_Clk(i_Clk),
//    .i_BouncyBtn_U(i_Rst),
//    .i_BouncyBtn_C(i_Enable),
//    .o_DebouncedBtn_U(r_debounced_rst),
//    .o_DebouncedBtn_C(r_debounced_enable));
      
    always @(posedge i_Clk) begin
//        r_debounced_rst_d <= r_debounced_rst;
    // Set r_LFSR_Seed_DV = 1 and turn if off automatically
//        r_LFSR_Seed_DV <= r_debounced_rst & ~r_debounced_rst_d;  
    
//        if (r_debounced_enable) begin
//            r_LFSR_Enable <= 1'b1;
//            r_Toggling_Signal <= 1'b0;
//        end
    
        if (w_Toggle) begin
            r_Toggling_Signal <= ~r_Toggling_Signal;
        end 
    end 
endmodule
