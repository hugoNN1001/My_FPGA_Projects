module State_Machine_Game #(parameter COUNT_LIMIT = 1_000_000, 
                                      GAME_LIMIT = 6) (
  input i_Clk,
  input i_Rst,
  
  input i_Switch_1,
  input i_Switch_2,
  input i_Switch_3,
  input i_Switch_4,
  output reg [3:0] o_Score, // current score to be displayed on 7-segment display
                            // also len of pattern on current level
                            // 0 - 1 LED
                            // 1 - 2 LEDs
                            // 2 - 3 LEDs
                            // etc.
                            // max is GAME_LIMIT - 1
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4
//  output reg o_LED_5,
//  output reg o_LED_6,
//  output reg o_LED_7,
//  output reg o_LED_8,
//  output reg o_LED_9,
//  output reg o_LED_10
);
  
  // State enumeration
  localparam START = 3'd1;
  localparam PATTERN_OFF = 3'd0;
  localparam PATTERN_SHOW = 3'd2;
  localparam WAIT_PLAYER = 3'd3;
  localparam INCR_SCORE = 3'd4;
  localparam LOSER = 3'd5;
  localparam WINNER = 3'd6;
  
  // Count and Toggle
  wire w_Count_And_Toggle_En; 
  reg [2:0] r_Curr_State;
  assign w_Count_And_Toggle_En = (r_Curr_State == PATTERN_OFF ||
                                  r_Curr_State == PATTERN_SHOW);
         
  wire w_Toggle;
                        
  Count_And_Toggle #(.COUNT_LIMIT(COUNT_LIMIT)) Count_And_Toggle_Inst
  (.i_Clk(i_Clk),
  .i_Enable(w_Count_And_Toggle_En),
  .o_Toggle(w_Toggle));
  
  reg r_Toggle_d; // w_Toggle delayed by 1 clk cycle
  
  always @(posedge i_Clk) begin
    r_Toggle_d <= w_Toggle;
  end
  
  // Generates [GAME_LIMIT*2]-bit wide random data
  localparam LFSR_BITS = GAME_LIMIT*2;
  wire [LFSR_BITS-1:0] w_LFSR_Data;
  
  LFSR #(.NUM_BITS(LFSR_BITS)) LFSR_Inst 
  (.i_Clk(i_Clk),
   .o_LFSR_Data(w_LFSR_Data),
   .o_LFSR_Done());  // leave unconnected
   
   // Register in the LFSR to r_Pattern when game starts
  // Each 2-bits of LFSR is one value for r_Pattern 2D Array
  localparam PATTERN_LEN = GAME_LIMIT;
  reg [1:0] r_Pattern[PATTERN_LEN-1:0];
  genvar i;
  // i is a compile_time constant (not runtime)
  
  // Generate a pattern for one game when current state is START
  generate
    for (i = 0; i < PATTERN_LEN; i = i+1) begin : GEN_PATTERN
      always @(posedge i_Clk) begin
        if (r_Curr_State == START) begin
          r_Pattern[i] <= w_LFSR_Data[i*2+1:i*2];
          // Synthesis 'unrolls' this loop before runtime
        end
      end
    end
  endgenerate
  
  // Create registers to enable falling edge detection
  // Create delayed versions of each switch signal
  reg r_Switch_1_d, r_Switch_2_d, r_Switch_3_d, r_Switch_4_d;
  // Reg to indicate all switches are turned off (will be 0 if any switch
  // see a RE)
  reg r_Switch_FE;
  // Tells which switch just saw a FE (0: LED1, 1: LED2, etc.)
  reg [1:0] r_Switch_ID;
  
  always @(posedge i_Clk) begin
    r_Switch_1_d <= i_Switch_1;
    r_Switch_2_d <= i_Switch_2;
    r_Switch_3_d <= i_Switch_3;
    r_Switch_4_d <= i_Switch_4;
    
    if (r_Switch_1_d & !i_Switch_1) begin
      r_Switch_FE <= 1'b1;
      r_Switch_ID <= 0; // LED1
    end
    
    else if (r_Switch_2_d & !i_Switch_2) begin
      r_Switch_FE <= 1'b1;
      r_Switch_ID <= 1; // LED2
    end
    
    else if (r_Switch_3_d & !i_Switch_3) begin
      r_Switch_FE <= 1'b1;
      r_Switch_ID <= 2; // LED3
    end
    
    else if (r_Switch_4_d & !i_Switch_4) begin
      r_Switch_FE <= 1'b1;
      r_Switch_ID <= 3; // LED4
    end
    
    else begin
      // Get these two regs ready for the next FE
      r_Switch_FE <= 1'b0;
      r_Switch_ID <= 0; // default, when no FE detected
    end
  end
  
  reg [$clog2(GAME_LIMIT)-1:0] r_Index; // index of current patter on current level
  
  always @(posedge i_Clk or posedge i_Rst) begin
    if (i_Rst) begin
//      o_LED_5 <= 1'b0;
//      o_LED_6 <= 1'b0;
//      o_LED_7 <= 1'b0;
//      o_LED_8 <= 1'b0;
//      o_LED_9 <= 1'b0;
//      o_LED_10 <= 1'b0;
      r_Curr_State <= START;
    end
    else begin
      
      // Main state machine switch statement
      case (r_Curr_State) 
        START:
        begin 
          if (~i_Rst) begin
//            o_LED_6 <= 1'b1;
//            o_LED_5 <= 1'b0;
            r_Index <= 0;
            o_Score <= 0; // first level: o_Score = 0, pattern has 1 LED
            r_Curr_State <= PATTERN_OFF;
          end
        end
          
        PATTERN_OFF:
        begin
//          o_LED_7 <= 1'b1;
//          o_LED_8 <= 1'b0;
          if (r_Toggle_d & !w_Toggle) begin // if FE detected on w_Toggle
            r_Curr_State <= PATTERN_SHOW;
          end
        end
          
        PATTERN_SHOW:
        begin
//          o_LED_7 <= 1'b0;
//          o_LED_8 <= 1'b1;
          if (r_Toggle_d & !w_Toggle) begin // if FE detected on w_Toggle
            
            if (r_Index == o_Score) begin
              // if pattern show done 
              r_Index <= 0;
              r_Curr_State <= WAIT_PLAYER;
            end
            else begin 
              // if pattern show not done
              r_Index <= r_Index + 1;
              r_Curr_State <= PATTERN_OFF;
            end
          end
        end
         
        WAIT_PLAYER:
        begin
//          o_LED_9 <= 1'b1;
          if (r_Switch_FE) begin  // if any switches toggled
            if (r_Switch_ID == r_Pattern[r_Index] &&
                r_Index == o_Score) begin 
              // if correct switch toggled and end of pattern
              r_Index <= 0;
              r_Curr_State <= INCR_SCORE;
            end
            else if (r_Switch_ID != r_Pattern[r_Index]) begin
              // if wrong switch toggled
              r_Curr_State <= LOSER;
            end
            else begin
              // if correct switched toggled and not end of pattern
              r_Index <= r_Index + 1;
              r_Curr_State <= WAIT_PLAYER;  // put here to make it apparent, can be removed
            end
          end
        end
          
        INCR_SCORE: 
        begin
          // Notice we're only here for a single clk cycle
          // Could've put this logic in WAIT_PLAYER but didn't
          // want to make it 
          o_Score <= o_Score + 1;
          
          if (o_Score == (GAME_LIMIT-1)) begin
            r_Curr_State <= WINNER;
          end
          else begin
            r_Curr_State <= PATTERN_OFF;
          end
        end
          
        WINNER:
        begin
          // display '0xA' on 7-segment display, wait for new game
          o_Score <= 4'hA;
        end
        
        LOSER: 
        begin
          // display '0xF' on 7-segment display, wait for new game
          o_Score <= 4'hF;
        end
          
        default:
          r_Curr_State <= START;
      endcase    
    end
  end 
  
  // LEDs
  assign o_LED_1 = (r_Curr_State == PATTERN_SHOW && 
                    r_Pattern[r_Index] == 2'b00) ? 1'b1 : i_Switch_1;
  assign o_LED_2 = (r_Curr_State == PATTERN_SHOW && 
                    r_Pattern[r_Index] == 2'b01) ? 1'b1 : i_Switch_2;
  assign o_LED_3 = (r_Curr_State == PATTERN_SHOW && 
                    r_Pattern[r_Index] == 2'b10) ? 1'b1 : i_Switch_3;
  assign o_LED_4 = (r_Curr_State == PATTERN_SHOW && 
                    r_Pattern[r_Index] == 2'b11) ? 1'b1 : i_Switch_4;    
endmodule