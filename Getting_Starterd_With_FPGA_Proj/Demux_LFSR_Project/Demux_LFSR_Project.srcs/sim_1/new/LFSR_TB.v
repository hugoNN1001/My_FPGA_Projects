`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2025 02:49:47 PM
// Design Name: 
// Module Name: LFSR_TB
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
// There are more checks that can be done with lfsr, below are just some
//////////////////////////////////////////////////////////////////////////////////


module LFSR_TB();

    parameter NUM_BITS = 24;
    
    reg r_Clk = 1'b0;
    always #2 r_Clk = ~r_Clk; 
    
    reg r_Enable = 1'b0;
    reg r_Seed_DV = 1'b0;
    reg [NUM_BITS-1:0] r_Seed_Data = 24'hACE123;
    
    // to check lfsr advances correctly
    reg [NUM_BITS-1:0] r_prev;
    
    wire [NUM_BITS-1:0] w_LFSR_Data;
    wire w_LFSR_Done;
    
    LFSR #(.NUM_BITS(NUM_BITS)) UUT
        (.i_Clk(r_Clk),
         .i_Enable(r_Enable),
         .i_Seed_DV(r_Seed_DV),
         .i_Seed_Data(r_Seed_Data),
         .o_LFSR_Data(w_LFSR_Data),
         .o_LFSR_Done(w_LFSR_Done));
        
    initial begin
        // CHECK SEED LOADS CORRECTLY
        r_Enable = 1'b1;
        r_Seed_DV = 1'b1;
        @(posedge r_Clk);
        #0;
        assert (w_LFSR_Data == r_Seed_Data)
            else $fatal("Seed load failed");
        
        r_Seed_DV = 1'b0;
        $display("Seed load OK");
        
        // CHECK LFSR ADVANCES
        r_prev = w_LFSR_Data;
        @(posedge r_Clk);
        #0;
        assert (w_LFSR_Data !== r_prev)
            else $fatal("LFSR did not advance");
        $display("LFSR advances");
        
        // CHECK LFSR HOLDS STATE WHEN DISABLED
        r_Enable = 1'b0;
        @(posedge r_Clk);
        r_prev = w_LFSR_Data;
        
        repeat (5) begin
            @(posedge r_Clk);
            assert (w_LFSR_Data == r_prev)
                else $fatal("LFST changed while disabled");
        end
        $display("LFSR holds state while disabled");

        $finish();
    end
    
    // CHECK LFSR NEVER REACHES FORBIDDEN STATE (ALL 1'S)
    always @(posedge r_Clk) begin
        assert(w_LFSR_Data != {NUM_BITS{1'b1}})
            else $fatal("LFSR entered all-ones forbidden state");
        $display("LFSR did not enter all-ones forbidden state");
    end
    
endmodule
