`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2025 02:59:32 PM
// Design Name: 
// Module Name: Demux_1_To_4_TB
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
`timescale 1ns / 1ps

module Demux_1_To_4_TB();
    
    reg r_Data = 1'b1;
    reg r_Sel0 = 1'b0;
    reg r_Sel1 = 1'b0;
    wire w_Out0, w_Out1, w_Out2, w_Out3;
    
    Demux_1_To_4 UUT (
        .i_Data(r_Data),
        .i_Sel0(r_Sel0),
        .i_Sel1(r_Sel1),
        .o_Out0(w_Out0),
        .o_Out1(w_Out1),
        .o_Out2(w_Out2),
        .o_Out3(w_Out3));
    
    // Takes input integer and drives select inputs
    task set_select(input [1:0] sel);
        #1;
        r_Sel1 = sel[1];
        r_Sel0 = sel[0];
        #1;
    endtask
    
    initial begin
        set_select(0);
        #1;
        assert (w_Out0);
        assert (!w_Out1);
        assert (!w_Out2);
        assert (!w_Out3);
        
        
        set_select(1);
        #1;
        assert (!w_Out0);
        assert (w_Out1);
        assert (!w_Out2);
        assert (!w_Out3);
        
        
        set_select(2);
        #1;
        assert (!w_Out0);
        assert (!w_Out1);
        assert (w_Out2);
        assert (!w_Out3);
        
        
        set_select(3);
        #1;
        assert (!w_Out0);
        assert (!w_Out1);
        assert (!w_Out2)
        assert (w_Out3); 
        
        $finish();
    end     
    
endmodule
