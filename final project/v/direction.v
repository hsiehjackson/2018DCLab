
module	direction(
	clk,
	rst,
	ready,
	X_center,
	Y_center,
	light,
	X_center_before_r,
	Y_center_before_r,
	X_MOVE_right_r, X_MOVE_left_r, Y_MOVE_down_r, Y_MOVE_up_r);


input clk;
input rst;
input ready;
input  [9:0]  X_center;
input  [9:0]  Y_center;
output reg [7:0] light;
//output reg [4:0] beforePOS, afterPOS;
output reg  [9:0] X_MOVE_right_r, X_MOVE_left_r, Y_MOVE_down_r, Y_MOVE_up_r;
wire  [9:0] X_MOVE_right_w, X_MOVE_left_w, Y_MOVE_down_w, Y_MOVE_up_w;
wire[9:0] X_center_before_w, Y_center_before_w, X_center_after_w, Y_center_after_w; 
output reg[9:0] X_center_before_r, Y_center_before_r;
reg [9:0] X_center_after_r, Y_center_after_r; 
wire up,down,left,right;
assign X_center_before_w = X_center_before_r;
assign Y_center_before_w = Y_center_before_r;
assign X_center_after_w = X_center_after_r; 
assign Y_center_after_w = Y_center_after_r;

assign up = ((Y_center_before_w < Y_center_after_w)) ? 1:0;
assign down = ((Y_center_after_w < Y_center_before_w)) ? 1:0;
assign left = ((X_center_before_w < X_center_after_w)) ? 1:0;
assign right = ((X_center_after_w < X_center_before_w)) ? 1:0;
assign X_MOVE_right_w = X_center_before_w - X_center_after_w; //>0 RIGHT
assign X_MOVE_left_w =  X_center_after_w - X_center_before_w; //>0 LEFT
assign Y_MOVE_down_w = Y_center_before_w - Y_center_after_w; //>0 DOWN
assign Y_MOVE_up_w =  Y_center_after_w - Y_center_before_w; //>0 UP

wire w_on, s_on, a_on, d_on;
assign w_on =  (~Y_MOVE_up_r[9]) & Y_MOVE_down_r[9];
assign s_on =  (~Y_MOVE_down_r[9]) & Y_MOVE_up_r[9];
assign a_on = (~X_MOVE_right_r[9]) & X_MOVE_left_r[9];
assign d_on = (~X_MOVE_left_r[9]) & X_MOVE_right_r[9];

always@(posedge clk or negedge rst)
	begin
		if (!rst)
			begin
				light <= 0;
				//beforePOS <= 0;
				//afterPOS <= 0;
				X_center_before_r <= 0;
				Y_center_before_r <= 0;
				X_center_after_r <= 0;
				Y_center_after_r <= 0;
			end
		else
		begin
		if ((ready) && (X_center!=X_center_before_w))
			begin
				X_center_before_r <= X_center;
				X_center_after_r <= X_center_before_w;
				X_MOVE_left_r <=  X_MOVE_left_w;
				X_MOVE_right_r <= X_MOVE_right_w;
			end
		//else
		//	X_MOVE_left_r  <= 0;
		//	X_MOVE_right_r <= 0;
		if ((ready) && (Y_center!=Y_center_before_w))
			begin
				//beforePOS <= Y_center[4:0];
				//afterPOS <= Y_center_before_w[4:0];
				Y_center_before_r <= Y_center;
				Y_center_after_r <= Y_center_before_w;
				Y_MOVE_up_r <= Y_MOVE_up_w;
				Y_MOVE_down_r <= Y_MOVE_down_w;
			end
		//else
		//	Y_MOVE_up_r <= 0;
		//	Y_MOVE_down_r <= 0;

		light[0] <= w_on; //5
		light[1] <= s_on;
		light[2] <= d_on;
		light[3] <= a_on; //8
		end
	end

endmodule // direction