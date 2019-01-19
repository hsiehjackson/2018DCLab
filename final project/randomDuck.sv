
module  randomDuck (
					input logic [7:0] keycode,
					input logic [4:0] randomNo,
					input  logic is_light,
					input    Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk, is_scope,          // The clock indicating a new frame (~60Hz)
               		input [9:0]   DrawX, DrawY, scope_X_Pos, scope_Y_Pos,
               		output logic  is_duck, is_duck2, is_start, is_gameover, is_home,             // Whether current pixel belongs to scope or background
					output logic  [9:0] Duck_Draw_X, Duck_Draw_Y,
					output logic  [9:0] Duck_Draw_X2, Duck_Draw_Y2,
					output logic  [4:0] score,
					output logic  [3:0] is_score_1 , is_score_10,
					output logic  [3:0] lives,
					output logic  [6:0] bullet,
					output logic  [2:0] LEDR
              );
    

	 

	parameter [9:0] Duck_X_Center = 400;
	parameter [9:0] Duck_Y_Center=450;  
    parameter [9:0] Duck_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Duck_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Duck_X_Step=1;      // Step size on the X axis
    parameter [9:0] Duck_Y_Step=-1;      // Step size on the Y axis
    parameter [9:0] Duck_SizeX=80;        // Duck sizeX
	parameter [9:0] Duck_SizeY=64;        // Duck sizeY
    parameter [9:0] Duck_X_Center2 = 400;
	parameter [9:0] Duck_Y_Center2=450;  
    parameter [9:0] Duck_Y_Min2=0;       // Topmost point on the Y axis
    parameter [9:0] Duck_Y_Max2=479;     // Bottommost point on the Y axis
    parameter [9:0] Duck_X_Step2=1;      // Step size on the X axis
    parameter [9:0] Duck_Y_Step2=-1;      // Step size on the Y axis
    parameter [9:0] Duck_SizeX2=80;        // Duck sizeX
	parameter [9:0] Duck_SizeY2=64;        // Duck sizeY
    logic [9:0] Duck_X_Pos, Duck_X_Motion, Duck_Y_Pos;
	logic [9:0] Duck_Y_Motion = -1;
    logic [9:0] Duck_X_Pos_in, Duck_X_Motion_in, Duck_Y_Pos_in, Duck_Y_Motion_in;

    logic [9:0] Duck_X_Pos2, Duck_X_Motion2, Duck_Y_Pos2;
	logic [9:0] Duck_Y_Motion2 = -1;
    logic [9:0] Duck_X_Pos_in2, Duck_X_Motion_in2, Duck_Y_Pos_in2, Duck_Y_Motion_in2;


    logic shoot,shoot_start,shoot_gameover, shoot_dead, shoot_dead2;
    logic is_light_past;
    int DistX, DistY, SizeX, SizeY;
    int DistX2, DistY2, SizeX2, SizeY2;
    assign DistX = DrawX - Duck_X_Pos;
    assign DistY = DrawY - Duck_Y_Pos;
    assign SizeX = Duck_SizeX;
	assign SizeY = Duck_SizeY;

	assign DistX2 = DrawX - Duck_X_Pos2;
    assign DistY2 = DrawY - Duck_Y_Pos2;
    assign SizeX2 = Duck_SizeX2;
	assign SizeY2 = Duck_SizeY2;
	//assign spacebar_on = (keycode== 8'h29);
	assign shoot = (~is_light_past) && is_light;
	assign spacebar_on = shoot;
	//assign escape_on = (keycode==8'h76);
	//assign start_on = (keycode==8'h29);
	assign escape_on = shoot_gameover || keycode==8'h76;
	assign start_on = shoot_start || keycode==8'h29;
	assign LEDR[2] = shoot; // 17
	assign LEDR[1] = shoot_start; //16
	assign LEDR[0] = shoot_gameover; //15
	

	 
	logic [8:0] xmin1 = 50;
	logic [8:0] xmin2 = 150;
	logic [8:0] xmin3 = 250;
	 
    logic [8:0] xmax1 = 350;
	logic [8:0] xmax2 = 450;
	logic [8:0] xmax3 = 550;

	logic [8:0] count_min = 1;
	logic [8:0] count_max = 1;
    logic [8:0] count_min_in;
	logic [8:0] count_max_in;

	logic [8:0] count_min2 = 1;
	logic [8:0] count_max2 = 1;
    logic [8:0] count_min_in2;
	logic [8:0] count_max_in2;

	logic [8:0] Duck_X_Min = 100;
	logic [8:0] Duck_X_Max = 350;
	logic [8:0] Duck_X_Min2 = 100;
	logic [8:0] Duck_X_Max2 = 350;
	 //logic [8:0] Duck_X_Min_in, Duck_X_Max_in;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
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
		    Duck_X_Pos <= 320;
            Duck_Y_Pos <= 429;
			Duck_X_Motion <= 1;
            Duck_Y_Motion <= -1;

           	Duck_X_Pos2 <= 320;
            Duck_Y_Pos2 <= 429;
			Duck_X_Motion2 <= 1;
            Duck_Y_Motion2 <= -1;

			count_min <= 1;
			count_max <= 1;
			count_min2 <= 1;
			count_max2 <= 1;
			score <= 0;
			lives <= 0;
			bullet <= 0;
			is_light_past <= 1;
			is_gameover <= 0;
			is_start <= 1;
			is_home <= 0;
			is_score_1 <= 4'b1111;
			is_score_10 <= 4'b1111;
		end
 
		else if ( start_on == 1 && is_start == 1) // start game 
        begin
		    Duck_X_Pos <= 320;
            Duck_Y_Pos <= 429;
			Duck_X_Motion <= 1;
            Duck_Y_Motion <= -1;

           	Duck_X_Pos2 <= 320;
            Duck_Y_Pos2 <= 429;
			Duck_X_Motion2 <= 1;
            Duck_Y_Motion2 <= -1;
            
			count_min <= 1;
			count_max <= 1;
			count_min2 <= 1;
			count_max2 <= 1;
			score <= 0;
			lives <= 5;
			bullet <= 0;
			is_light_past <= is_light;
			is_gameover <= 0;
			is_start <= 0;
			is_home <= 1;
			is_score_1 <= 4'b0000;
			is_score_10 <= 4'b0000;
        end
        else if ( escape_on == 1 && is_start == 0)  // go to start page
        begin
		    Duck_X_Pos <= 320;
            Duck_Y_Pos <= 429;
			Duck_X_Motion <= 1;
            Duck_Y_Motion <= -1;

           	Duck_X_Pos2 <= 320;
            Duck_Y_Pos2 <= 429;
			Duck_X_Motion2 <= 1;
            Duck_Y_Motion2 <= -1;
            
			count_min <= 1;
			count_max <= 1;
			count_min2 <= 1;
			count_max2 <= 1;
			score <= 0;
			lives <= 5;
			bullet <= 0;
			is_light_past <= is_light;
			is_gameover <= 0;
			is_start <= 1;
			is_home <= 0;
			is_score_1 <= 4'b1111;
			is_score_10 <= 4'b1111;
        end
        else if (escape_on == 1 && is_gameover == 1) // go to start page
        begin
		    Duck_X_Pos <= 320;
            Duck_Y_Pos <= 429;
			Duck_X_Motion <= 1;
            Duck_Y_Motion <= -1;

           	Duck_X_Pos2 <= 320;
            Duck_Y_Pos2 <= 429;
			Duck_X_Motion2 <= 1;
            Duck_Y_Motion2 <= -1;
            
			count_min <= 1;
			count_max <= 1;
			count_min2 <= 1;
			count_max2 <= 1;
			score <= 0;
			lives <= 5;
			bullet <= 0;
			is_light_past <= is_light;
			is_gameover <= 0;
			is_start <= 1;
			is_home <= 0;
			is_score_1 <= 4'b1111;
			is_score_10 <= 4'b1111;
        end
        /*
        else if (start_on == 1 && is_gameover == 1) //
        begin
        	Duck_X_Pos <= 320;
			Duck_Y_Pos <= 429;
			Duck_X_Motion <= 1;
			Duck_Y_Motion <= -1;
			count_min <= 1;
			count_max <= 1;
			score <= 0;
			lives <= 5;
			bullet <= 0;
			is_light_past <= 1;
			is_gameover <= 0;
			is_start <= 0;
        end
        */
        else if (is_start == 1)
		begin
		    Duck_X_Pos <= 320;
            Duck_Y_Pos <= 429;
			Duck_X_Motion <= 1;
            Duck_Y_Motion <= -1;

           	Duck_X_Pos2 <= 320;
            Duck_Y_Pos2 <= 429;
			Duck_X_Motion2 <= 1;
            Duck_Y_Motion2 <= -1;
            
			count_min <= 1;
			count_max <= 1;
			count_min2 <= 1;
			count_max2 <= 1;
			score <= 0;
			lives <= 0;
			bullet <= 0;
			is_light_past <= is_light;
			is_gameover <= 0;
			is_start <= 1;
			is_home <= 0;
			is_score_1 <= 4'b1111;
			is_score_10 <= 4'b1111;
		end
		else if (is_gameover == 1)
        begin
		    Duck_X_Pos <= 320;
            Duck_Y_Pos <= 429;
			Duck_X_Motion <= 1;
            Duck_Y_Motion <= -1;

           	Duck_X_Pos2 <= 320;
            Duck_Y_Pos2 <= 429;
			Duck_X_Motion2 <= 1;
            Duck_Y_Motion2 <= -1;
            
			count_min <= 1;
			count_max <= 1;
			count_min2 <= 1;
			count_max2 <= 1;
			score <= 0;
			lives <= 0;
			bullet <= bullet;
			is_light_past <= is_light;
			is_gameover <= 1;
			is_start <= 0;
			is_home <= 1;
			is_score_1 <= is_score_1;
			is_score_10 <= is_score_10;
        end
        else if (lives == 0)
        begin
		    Duck_X_Pos <= 320;
            Duck_Y_Pos <= 429;
			Duck_X_Motion <= 1;
            Duck_Y_Motion <= -1;

           	Duck_X_Pos2 <= 320;
            Duck_Y_Pos2 <= 429;
			Duck_X_Motion2 <= 1;
            Duck_Y_Motion2 <= -1;
            
			count_min <= 1;
			count_max <= 1;
			count_min2 <= 1;
			count_max2 <= 1;
			score <= score;
			lives <= 5;
			bullet <= bullet;
			is_light_past <= is_light;
			is_gameover <= 1;
			is_start <= 0;
			is_home <= 1;
			is_score_1 <= is_score_1;
			is_score_10 <= is_score_10;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Duck_X_Pos <= Duck_X_Pos_in;
            Duck_Y_Pos <= Duck_Y_Pos_in;
			Duck_X_Motion <= Duck_X_Motion_in;
            Duck_Y_Motion <= Duck_Y_Motion_in;
			count_min <= count_min_in;
			count_max <= count_max_in;
			if (score>=15 & score >=0)
			begin
				Duck_X_Pos2 <= Duck_X_Pos_in2;
	            Duck_Y_Pos2 <= Duck_Y_Pos_in2;
				Duck_X_Motion2 <= Duck_X_Motion_in2;
	            Duck_Y_Motion2 <= Duck_Y_Motion_in2;
				count_min2 <= count_min_in2;
				count_max2 <= count_max_in2;
			end
			else
			begin
				Duck_X_Pos2 <= 320;
            	Duck_Y_Pos2 <= 429;
				Duck_X_Motion2 <= 1;
            	Duck_Y_Motion2 <= -1;
         		count_min2 <= 1;
				count_max2 <= 1;
			end
			is_light_past <= is_light;
			is_home <= 1;
			is_gameover <= 0;
			is_start <= 0;
			if (is_light_past==0 && is_light==1)
				bullet <= bullet+1;
			if(shoot_dead || shoot_dead2)
			begin
				score <= score+1'b1;
				if (shoot_dead & shoot_dead2)
					score <= score+2;
				if (score == 7'd99)
				begin
					is_score_10 <= is_score_10 ;
					is_score_1 <= is_score_1 ;
				end			
				else if (score == 7'b0001001 || score == 7'b0010011 || score ==7'b0011101 
					|| score == 7'b0100111||score == 7'b0110001 || score == 7'b0111011
				 || score == 7'b1000101 || score == 7'b1001111 || score == 7'b1011001)
				begin
					is_score_10 <= is_score_10 + 4'b0001; 
					is_score_1 <= 0; 
				end
				else 
				begin
					is_score_1 <= is_score_1 + 4'b0001;
				end
			end
			if(Duck_Y_Pos == 0 || Duck_Y_Pos2 == 0)	
			begin
				lives <= lives-1;
			end
		end
        // By defualt, keep the register values.
    end
	 

    // You need to modify always_comb block.
    always_comb
    begin
				
			count_min_in = count_min;
			count_max_in = count_max;
			count_min_in2 = count_min2;
			count_max_in2 = count_max2;		
			//SET THE DUCKS WALLS TO DETERMINE MOTION
			if(count_min==1)
				Duck_X_Min = 100;		
			else if(count_min==2)
				Duck_X_Min = 200;		
		    else
				Duck_X_Min = 300;

			if(count_max==1)
				Duck_X_Max = 200;	
			else if(count_max==2)
				Duck_X_Max = 360;	
			else if(count_max==3)
				Duck_X_Max = 600;	
		    else
				Duck_X_Max = 420;

			if(count_min2==1)
				Duck_X_Min2 = 350;		
			else if(count_min2==2)
				Duck_X_Min2 = 250;		
		    else
				Duck_X_Min2 = 150;

			if(count_max2==1)
				Duck_X_Max2 = 200;	
			else if(count_max2==2)
				Duck_X_Max2 = 360;	
			else if(count_max2==3)
				Duck_X_Max2 = 600;	
		    else
				Duck_X_Max2 = 420;

			//SET DEFAULT POSITION AND MOTION VALUES
			Duck_X_Pos_in = Duck_X_Pos + Duck_X_Motion;
        	Duck_Y_Pos_in = Duck_Y_Pos + Duck_Y_Motion;
			
			Duck_X_Motion_in = Duck_X_Motion;
         	Duck_Y_Motion_in = Duck_Y_Motion;
			

         	Duck_X_Pos_in2 = Duck_X_Pos2 + Duck_X_Motion2;
        	Duck_Y_Pos_in2 = Duck_Y_Pos2 + Duck_Y_Motion2;
			
			Duck_X_Motion_in2 = Duck_X_Motion2;
         	Duck_Y_Motion_in2 = Duck_Y_Motion2;
			

			//DETERMINE COLLISION WITH TOP AND BOTTOM OF SCREEN
			
			if (Duck_Y_Pos + Duck_SizeY <= Duck_Y_Min  )  // duck as the top, go back to the bottom
			begin
            Duck_Y_Pos_in = 468;		

			end
			else if (Duck_Y_Pos > 468 & Duck_Y_Motion > 0 )  // duck is at the bottom and is moving downward, stop moving and move to different location
			begin
                Duck_Y_Pos_in = 468;
				if(score>=12 & score >=0)
					Duck_Y_Motion_in = -4;
				else if(score>=8 & score >=0)
					Duck_Y_Motion_in = -3;
				else if(score>=4 & score >=0)
					Duck_Y_Motion_in = -2;	
				else 
					Duck_Y_Motion_in = -1;									
			    if(count_min<4)
						count_min_in = count_min+1;
				else	
						count_min_in = 1;
					
					
				if(count_max==1)
				begin
				    count_max_in=2;
					Duck_X_Pos_in = 360;
				end
			    else if(count_max==2)	
				begin
					count_max_in=3;
		            Duck_X_Pos_in = 600;			
				end
				else if(count_max==3)	
				begin
					count_max_in=4;
		            Duck_X_Pos_in = 420;			
				end
				else 
				begin
					count_max_in=1;
		            Duck_X_Pos_in = 200;			
				end	
		   end

		   if (Duck_Y_Pos2 + Duck_SizeY2 <= Duck_Y_Min2  )  // duck as the top, go back to the bottom
			begin
            Duck_Y_Pos_in2 = 468;		
			end
			else if (Duck_Y_Pos2 > 468 & Duck_Y_Motion2 > 0 )  // duck is at the bottom and is moving downward, stop moving and move to different location
			begin
                Duck_Y_Pos_in2 = 468;
				if(score>=30 & score >=0)
					Duck_Y_Motion_in2 = -4;
				else if(score>=25 & score >=0)
					Duck_Y_Motion_in2 = -3;
				else if(score>=20 & score >=0)
					Duck_Y_Motion_in2 = -2;	
				else 
					Duck_Y_Motion_in2 = -1;				

			    if(count_min2<4)
						count_min_in2 = count_min2+1;
				else	
						count_min_in2 = 1;
					
					
				if(count_max2==1)
				begin
				    count_max_in2=2;
					Duck_X_Pos_in2 = 460;
				end
			    else if(count_max2==2)	
				begin
					count_max_in2=3;
		            Duck_X_Pos_in2 = 540;			
				end
				else if(count_max2==3)	
				begin
					count_max_in2=4;
		            Duck_X_Pos_in2 = 240;			
				end
				else 
				begin
					count_max_in2=1;
		            Duck_X_Pos_in2 = 330;			
				end	
		   end


			
				//CALCULATE MOTION DEPENDING ON BOUNCING OF WALLS

			if( Duck_X_Pos >= Duck_X_Max )  // duck right wall bounce
			begin  	
					if(score>=12)
						Duck_X_Motion_in = -4;
					else if(score>=8)
						Duck_X_Motion_in = -3;
					else if(score>=4)
						Duck_X_Motion_in = -2;	
					else 
						Duck_X_Motion_in = -1;	
			end
			else if ( Duck_X_Pos <= Duck_X_Min )  // duck left wall bounce
			begin
					if(score>=12)
						Duck_X_Motion_in = 4;
					else if(score>=8)
						Duck_X_Motion_in = 3;
					else if(score>=4)
						Duck_X_Motion_in = 2;	
					else 
						Duck_X_Motion_in = 1;
			end

			if( Duck_X_Pos2 >= Duck_X_Max2 )  // duck right wall bounce
			begin  	
					if(score>=12)
						Duck_X_Motion_in2 = -4;
					else if(score>=8)
						Duck_X_Motion_in2 = -3;
					else if(score>=4)
						Duck_X_Motion_in2 = -2;	
					else 
						Duck_X_Motion_in2 = -1;	
			end
			else if ( Duck_X_Pos2 <= Duck_X_Min2 )  // duck left wall bounce
			begin
					if(score>=12)
						Duck_X_Motion_in2 = 4;
					else if(score>=8)
						Duck_X_Motion_in2 = 3;
					else if(score>=4)
						Duck_X_Motion_in2 = 2;	
					else 
						Duck_X_Motion_in2 = 1;
			end






		//START DETECTION WITH TARGET	
		//& (scope_X_Pos + 30 > 260) & (scope_X_Pos + 30 < 380)  & (scope_Y_Pos+30 > 390) & (scope_Y_Pos+30 < 440)
		if (spacebar_on  & (scope_X_Pos + 30 > 260) & (scope_X_Pos + 30 < 380)  & (scope_Y_Pos+30 > 370) & (scope_Y_Pos+30 < 440) & is_start==1)
			shoot_start = 1;
		else
			shoot_start = 0;

		if (spacebar_on  & (scope_X_Pos + 30 > 405) & (scope_X_Pos + 30 < 435)  & (scope_Y_Pos+30 > 435) & (scope_Y_Pos+30 < 465) & (is_gameover==1 || is_start==0))
			shoot_gameover = 1;
		else
			shoot_gameover = 0;
				
		//COLLISION DETECTION WITH TARGET	
				
		if(spacebar_on & (scope_X_Pos + 30 > Duck_X_Pos) & (scope_X_Pos+30 < Duck_X_Pos + Duck_SizeX) & (scope_Y_Pos+30 > Duck_Y_Pos) & (scope_Y_Pos+30 < Duck_Y_Pos + Duck_SizeY))
		begin
			shoot_dead = 1;
			Duck_X_Motion_in=1'b0;
			Duck_Y_Motion_in=12;
		end
		else
			shoot_dead = 0;

		if(spacebar_on & (scope_X_Pos + 30 > Duck_X_Pos2) & (scope_X_Pos+30 < Duck_X_Pos2 + Duck_SizeX2) & (scope_Y_Pos+30 > Duck_Y_Pos2) & (scope_Y_Pos+30 < Duck_Y_Pos2 + Duck_SizeY2))
		begin
			shoot_dead2 = 1;
			Duck_X_Motion_in2=1'b0;
			Duck_Y_Motion_in2=12;
		end
		else
			shoot_dead2 = 0;
		
		  //ACCESSING THE DUCK ARRAY FOR DRAWING
		
		  if ( DistX <= SizeX & DistX >= 0  & DistY <= SizeY & DistY >= 0) 
		  begin
            	is_duck = 1'b1;
				Duck_Draw_X = DrawX - Duck_X_Pos;
				Duck_Draw_Y = DrawY - Duck_Y_Pos;
		  end	
          else
		  begin
            	is_duck = 1'b0;
				Duck_Draw_X = 1'b0;
				Duck_Draw_Y = 1'b0;
		  end

		  if ( DistX2 <= SizeX2 & DistX2 >= 0  & DistY2 <= SizeY2 & DistY2 >= 0) 
		  begin
            	is_duck2 = 1'b1;
				Duck_Draw_X2 = DrawX - Duck_X_Pos2;
				Duck_Draw_Y2 = DrawY - Duck_Y_Pos2;
		  end	
          else
		  begin
            	is_duck2 = 1'b0;
				Duck_Draw_X2 = 1'b0;
				Duck_Draw_Y2 = 1'b0;
		  end
    end
    
endmodule


