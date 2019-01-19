module  scope (	input logic [7:0] keycode,
				input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
                input [9:0]  DrawX, DrawY,       // Current pixel coordinates
                input logic [9:0] X_MOVE_right_r, X_MOVE_left_r, Y_MOVE_down_r, Y_MOVE_up_r,
                input logic [9:0] X_center_before_r,
                input logic [9:0] Y_center_before_r,
                output logic is_scope,             // Whether current pixel belongs to scope or background
			    output logic [9:0] scope_X_Pos, scope_Y_Pos, scope_Draw_X, scope_Draw_Y,
                //output logic [8:0] LEDG,
                input logic is_light
              );
    
    parameter [9:0] scope_X_Center=320;  // Center position on the X axis
    parameter [9:0] scope_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] scope_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] scope_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] scope_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] scope_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] scope_X_Step=20;      // Step size on the X axis
    parameter [9:0] scope_Y_Step=20;      // Step size on the Y axis
    parameter [9:0] scope_Size=64;        // scope size
    
    logic [9:0] scope_X_Pos_in, scope_Y_Pos_in; 
    logic w_on, s_on, a_on, d_on;
    logic [9:0] X_center, Y_center;
    logic light_past;
    int DistX, DistY, Size;
    assign DistX = DrawX - scope_X_Pos;
    assign DistY = DrawY - scope_Y_Pos;
    assign Size = scope_Size;
	assign X_center = scope_X_Max - X_center_before_r * 2;
    assign Y_center = Y_center_before_r * 2;
    
    assign w_on =  (~Y_MOVE_up_r[9]) && Y_MOVE_down_r[9];
    assign s_on =  (~Y_MOVE_down_r[9]) && Y_MOVE_up_r[9];
    assign a_on = (~X_MOVE_right_r[9]) && X_MOVE_left_r[9];
    assign d_on = (~X_MOVE_left_r[9]) && X_MOVE_right_r[9];

  	
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update scope position and motion
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            scope_X_Pos <= scope_X_Center;
            scope_Y_Pos <= scope_Y_Center;
            light_past <= 0;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            scope_X_Pos <= scope_X_Pos_in;
            scope_Y_Pos <= scope_Y_Pos_in;
            light_past <= is_light;
        end
        // By defualt, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
		begin
        /*
        if ((X_center > scope_X_Min) && (X_center < scope_X_Max) && is_light)
            scope_X_Pos_in =  X_center;
        else
            scope_X_Pos_in = scope_X_Pos;

        if ((Y_center > scope_Y_Min) && (Y_center < scope_Y_Max) && is_light)
            scope_Y_Pos_in = Y_center;
        else
            scope_Y_Pos_in = scope_Y_Pos;
        */
        
        
        if ((light_past == 0) && (is_light == 1))
            begin
            scope_Y_Pos_in = scope_Y_Pos;
            end
		else if (w_on && ((scope_Y_Pos - Y_MOVE_up_r * 3) > scope_Y_Min) && ((scope_Y_Pos - Y_MOVE_up_r * 3) < scope_Y_Max ) && is_light &&  Y_MOVE_up_r > 1)
			begin
			scope_Y_Pos_in = scope_Y_Pos - Y_MOVE_up_r * 3;		
			end	 	 
		else if(s_on && ((scope_Y_Pos + Y_MOVE_down_r * 3) < scope_Y_Max) && ((scope_Y_Pos + Y_MOVE_down_r * 3) > scope_Y_Min) && is_light && Y_MOVE_down_r > 1)
			begin
			scope_Y_Pos_in = scope_Y_Pos + Y_MOVE_down_r * 3;		
			end
		else
			scope_Y_Pos_in = scope_Y_Pos;


        if ((light_past == 0) && (is_light == 1))
            begin
            scope_X_Pos_in = scope_X_Pos;
            end
		else if(a_on && ((scope_X_Pos - X_MOVE_right_r * 3) > scope_X_Min) && ((scope_X_Pos - X_MOVE_right_r * 3) < scope_X_Max) && is_light && X_MOVE_right_r > 1)
			begin
			scope_X_Pos_in = scope_X_Pos - X_MOVE_right_r * 3;		
			end	 
		else if(d_on && ((scope_X_Pos + X_MOVE_left_r * 3) < scope_X_Max) && ((scope_X_Pos + X_MOVE_left_r * 3) > scope_X_Min) && is_light && X_MOVE_left_r > 1)
			begin
			scope_X_Pos_in = scope_X_Pos + X_MOVE_left_r * 3;		
			end
		else
			scope_X_Pos_in = scope_X_Pos;
        

		if ( DistX <= scope_Size && DistX >= 0  && DistY <= scope_Size && DistY >= 0) 
			begin
			is_scope = 1'b1;
			scope_Draw_X = DistX;
			scope_Draw_Y = DistY;
			end	
		else
			begin
			is_scope = 1'b0;
			scope_Draw_X = 1'b0;
			scope_Draw_Y = 1'b0;
			end
    end
    
endmodule

