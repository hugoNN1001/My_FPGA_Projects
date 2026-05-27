module top (
    input i_Clk,
    input i_Btn_U,
    input i_Btn_R,
    input i_Btn_L,
    output o_LED_1,
    output o_LED_2,
    output o_LED_3);
    
    reg r_Btn_U = 1'b0;
    reg r_Btn_R = 1'b0;
    reg r_Btn_L = 1'b0;
    reg r_LED_1 = 1'b0;
    reg r_LED_2 = 1'b0;
    reg r_LED_3 = 1'b0;
    
    always @(posedge i_Clk) 
    begin
        if (i_Btn_U == 1'b1 && r_Btn_U == 1'b0)
        begin
            r_LED_1 = ~r_LED_1;
        end
        
        if (i_Btn_R  == 1'b1 && r_Btn_R == 1'b0)
        begin
            r_LED_2 = ~r_LED_2;
        end
        
        if (i_Btn_L == 1'b1 && r_Btn_L  == 1'b0)
        begin
            r_LED_3 = ~r_LED_3;
        end
        
        r_Btn_U <= i_Btn_U;
        r_Btn_R <= i_Btn_R;
        r_Btn_L <= i_Btn_L;
    end
    
    assign o_LED_1 = r_LED_1;
    assign o_LED_2 = r_LED_2;
    assign o_LED_3 = r_LED_3;
endmodule