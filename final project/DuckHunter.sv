

module DuckHunter( 
			 input               CLOCK_50,
             input                KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX3,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             inout PS2_CLK,
			 inout PS2_DAT,
             input  logic [9:0] X_MOVE_right_r, X_MOVE_left_r, Y_MOVE_down_r, Y_MOVE_up_r,
             output logic [8:0] LEDG,
             input  logic [9:0] X_center_before_r,
             input  logic [9:0] Y_center_before_r,
             output logic [9:0] X_scope,
             output logic [9:0] Y_scope,
             input  logic is_light,
             output logic [6:0] is_bullet,
             input  logic SET_SCOPE,
             output logic [2:0] LEDR
             );

    logic [3:0] is_score_1, is_score_10;
	logic Reset_h, Clk;
	logic [7:0] keycode;
	logic [9:0] DrawX, DrawY, Duck_Draw_X, Duck_Draw_Y, scope_X_Pos, scope_Y_Pos, scope_Draw_X, scope_Draw_Y;
    logic [9:0] Duck_Draw_X2, Duck_Draw_Y2;
	logic [4:0] randomNo;
	logic is_scope, is_duck, is_duck2, is_gameover, is_start, is_home;
    logic is_light_de;
	logic [4:0] score;
	logic [3:0] lives;
    assign X_scope = scope_X_Pos;
    assign Y_scope = scope_Y_Pos;
    assign LEDG[0] = is_light;
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY);        // The push buttons are active low
    end
    always_ff @ (posedge Clk) begin
        if(Reset_h)
            VGA_CLK <= 1'b0;
        else
            VGA_CLK <= ~VGA_CLK;
    end        

    Debounce deb0(
        .i_in(is_light),
        .i_clk(Clk),
        .o_debounced(is_light_de));

    VGA_controller vga_controller_instance(.Reset(Reset_h),
    									   .Clk(Clk),
    									   .VGA_HS(VGA_HS),
    									   .VGA_VS(VGA_VS),
    									   .VGA_CLK(VGA_CLK),
    									   .VGA_BLANK_N(VGA_BLANK_N),
    									   .VGA_SYNC_N(VGA_SYNC_N),
    									   .DrawX(DrawX),
    									   .DrawY(DrawY));
    
    scope scope_instance(.Reset(SET_SCOPE),
    	                 .frame_clk(VGA_VS),
    	                 .Clk(Clk),
    	                 .keycode(keycode),
    	                 .DrawX(DrawX),
    	                 .DrawY(DrawY),
    	                 .is_scope(is_scope),
    	                 .scope_X_Pos(scope_X_Pos),
    	                 .scope_Y_Pos(scope_Y_Pos),
    	                 .scope_Draw_X(scope_Draw_X), 
    	                 .scope_Draw_Y(scope_Draw_Y),
                         .X_MOVE_right_r(X_MOVE_right_r), 
                         .X_MOVE_left_r(X_MOVE_left_r), 
                         .Y_MOVE_down_r(Y_MOVE_down_r), 
                         .Y_MOVE_up_r(Y_MOVE_up_r),
                         .X_center_before_r(X_center_before_r),
                         .Y_center_before_r(Y_center_before_r),
                         //.LEDG(LEDG),
                         .is_light(is_light_de));
	 
	randomDuck duck_instance(.Reset(Reset_h),
		                     .frame_clk(VGA_VS),
		                     .keycode(keycode),
		                     .randomNo(randomNo),
		                     .Clk(Clk),
		                     .is_scope(is_scope),
		                     .DrawX(DrawX),
		                     .DrawY(DrawY),
		                     .scope_X_Pos(scope_X_Pos),
		                     .scope_Y_Pos(scope_Y_Pos),
		                     .is_duck(is_duck),
                             .is_duck2(is_duck2),
		                     .Duck_Draw_X(Duck_Draw_X),
		                     .Duck_Draw_Y(Duck_Draw_Y),
                             .Duck_Draw_X2(Duck_Draw_X2),
                             .Duck_Draw_Y2(Duck_Draw_Y2),
		                     .score(score),
		                     .lives(lives),
                             .is_gameover(is_gameover),
                             .is_start(is_start),
                             .is_light(is_light_de),
                             .is_score_1(is_score_1),
                             .is_score_10(is_score_10),
                             .is_home(is_home),
                             .bullet(is_bullet),
                             .LEDR(LEDR));
	 
	fibonacci_lfsr_nbit random1(.clk(Clk),
								.rst_n(Reset_h), 
								.data(randomNo));
    
    color_mapper color_instance(.is_scope(is_scope),
    							.is_duck(is_duck),
                                .is_duck2(is_duck2),
    							.DrawX(DrawX),
    							.DrawY(DrawY),
    							.Duck_Draw_X(Duck_Draw_X),
    							.Duck_Draw_Y(Duck_Draw_Y),
                                .Duck_Draw_X2(Duck_Draw_X2),
                                .Duck_Draw_Y2(Duck_Draw_Y2),
    							.scope_Draw_X(scope_Draw_X),
    							.scope_Draw_Y(scope_Draw_Y),
    							.lives(lives),
    							.VGA_R(VGA_R),
    							.VGA_G(VGA_G),
    							.VGA_B(VGA_B),
                                .is_gameover(is_gameover),
                                .is_start(is_start),
                                .is_score_1(is_score_1),
                                .is_score_10(is_score_10),
                                .is_home(is_home));

    keyboardRecv keyboard(.i_clk(PS2_CLK),			// PS2 clock (slower than 50MHz)
						  .i_rst(Reset_h),
					      .i_quick_clk(Clk),
     					  .i_data(PS2_DAT),			// PS2 data
						  .o_key(keycode));
    // Display keycode on hex display
    HexDriver hex_inst_0 (score, HEX0, HEX1);
	HexDriver hex_inst_2 (lives, HEX3);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
