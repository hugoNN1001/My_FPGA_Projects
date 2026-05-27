`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 01:15:48 PM
// Design Name: 
// Module Name: Demux_1_To_4
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


module Demux_1_To_4(
    input i_Data,
    input i_Sel0,
    input i_Sel1,
    output o_Out0,
    output o_Out1,
    output o_Out2,
    output o_Out3
    );
    
    assign o_Out0 = !i_Sel0 & !i_Sel1 ? i_Data : 1'b0;
    assign o_Out1 = i_Sel0 & !i_Sel1 ? i_Data : 1'b0;
    assign o_Out2 = !i_Sel0 & i_Sel1 ? i_Data : 1'b0;
    assign o_Out3 = i_Sel0 & i_Sel1 ? i_Data : 1'b0;
    
endmodule
