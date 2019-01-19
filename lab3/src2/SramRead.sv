module SramRead(
	input i_BCLK,
	input i_rst,
	input i_enable,
	input i_pause,		// From KEY
	input i_stop,		// From KEY
	input i_speed_up,	// From KEY
	input i_speed_down,	// From KEY
	input i_interpol,
	input i_DACLRCK,
	input [19:0] i_end_addr,
	input [15:0] i_SRAM_DQ,

	output [19:0] o_addr,
	output [15:0] o_DACDAT,
	output o_play_n,
	output [2:0]  o_state,
	output [4:0]  o_speed
);

	enum {IDLE, STOP, PLAY, PAUSE} state_w, state_r;
	enum {NORMAL, FAST, SLOW} play_mode_w, play_mode_r;
//	localparam fast_param = 4;
	logic [15:0] data_w, data_r;
	logic signed [15:0] data_pre_w, data_pre_r;
	logic signed [15:0] output_data_w, output_data_r;
//	logic [9:0]  counter_w, counter_r;
	logic [19:0] addr_w, addr_r;
	logic [2:0]  speed_w, speed_r;
	logic [2:0]  spd_counter_w, spd_counter_r;
	logic [2:0] hex_output_w, hex_output_r;

	assign o_addr = addr_r;
	assign o_DACDAT = output_data_r;
	assign o_play_n = !(state_r == PLAY);
	assign o_speed[4] = (play_mode_r == SLOW);
	assign o_speed[3:0] = speed_r + 1;
	assign o_state = hex_output_r;

	always_comb begin
		hex_output_w = hex_output_r;
		state_w = state_r;
		play_mode_w = play_mode_r;
		data_w = data_r;
		data_pre_w = data_pre_r;
		output_data_w = output_data_r;
		addr_w = addr_r;
		speed_w = speed_r;
		spd_counter_w = spd_counter_r;
//		counter_w = counter_r;

		case (state_r)
			IDLE: begin
					addr_w = 0;
					hex_output_w <= 3'b100;
					if (i_enable) begin
						state_w = STOP;
						speed_w = 0;
						play_mode_w = NORMAL;
					end
			end

			STOP: begin
					if (!i_enable) begin
						state_w = IDLE;
					end else if (i_pause) begin
						hex_output_w <= 3'b100;
						state_w = PLAY;
						addr_w = 0;
					end
					case (play_mode_r)
						NORMAL: begin
								if (i_speed_up) begin
									play_mode_w = FAST;
									speed_w = 1;
								end else if (i_speed_down) begin
									play_mode_w = SLOW;
									speed_w = 1;
								end
						end

						FAST: begin 
								if (i_speed_up) begin
									if (speed_r != 7) begin
										speed_w = speed_r + 1;
									end
								end else if (i_speed_down) begin
									if (speed_r == 1) begin
										play_mode_w = NORMAL;
										speed_w = 0;
									end else begin
										speed_w = speed_r - 1;
									end
								end
						end

						SLOW: begin 
								if (i_speed_down) begin
									if (speed_r != 7) begin
										speed_w = speed_r + 1;
									end
								end else if (i_speed_up) begin
									if (speed_r == 1) begin
										play_mode_w = NORMAL;
										speed_w = 0;
									end else begin
										speed_w = speed_r - 1;
									end
								end
						end
					endcase // play_mode_r
			end

			PLAY: begin 
					hex_output_w = 3'b100;
					if (!i_enable) begin
						state_w = IDLE;
					end else if (i_pause) begin
						hex_output_w = 3'b101;
						state_w = PAUSE;
					end else if (i_stop) begin
						hex_output_w = 3'b011; 
						state_w = STOP;
						addr_w = 0;
					end else if (addr_r > i_end_addr - speed_r - 2) begin
						state_w = STOP;
					end

					case (play_mode_r)
						NORMAL: begin
								output_data_w = i_SRAM_DQ;
								addr_w = addr_r + 1;
								if (i_speed_up) begin
									play_mode_w = FAST;
									speed_w = 1;
								end else if (i_speed_down) begin
									play_mode_w = SLOW;
									speed_w = 1;
								end
						end

						FAST: begin 
								output_data_w = i_SRAM_DQ;
								addr_w = addr_r + speed_r + 1;
								/*
								if (counter_r == fast_param) begin
									counter_w = 0;
									addr_w = addr_r + fast_param * speed_r;
								end else begin
									counter_w = counter_r + 1;
									addr_w = addr_r + 1;
								end
								*/
								if (i_speed_up) begin
									if (speed_r != 7) begin
										speed_w = speed_r + 1;
									end
								end else if (i_speed_down) begin
									if (speed_r == 1) begin
										play_mode_w = NORMAL;
										speed_w = 0;
									end else begin
										speed_w = speed_r - 1;
									end
								end
						end

						SLOW: begin 
								if (i_speed_down) begin
									if (speed_r != 7) begin
										speed_w = speed_r + 1;
									end
								end else if (i_speed_up) begin
									if (speed_r == 1) begin
										play_mode_w = NORMAL;
										speed_w = 0;
									end else begin
										speed_w = speed_r - 1;
									end
								end else begin 
									if (spd_counter_r == 0) begin
										output_data_w = data_pre_r;
										spd_counter_w = spd_counter_r + 1;
									end else begin
										if (spd_counter_r == speed_r) begin
											spd_counter_w = 0;
											addr_w = addr_r + 1;
											data_pre_w = signed'(i_SRAM_DQ);
										end else begin
											spd_counter_w = spd_counter_r + 1;
										end

										if (i_interpol) begin
											output_data_w = data_pre_r + (signed'(i_SRAM_DQ) - data_pre_r) * signed'(spd_counter_r) / signed'(speed_r + 1);
										end else begin 
											output_data_w = data_pre_r;
										end
									end
								end
						end
					endcase // play_mode_r
			end

			PAUSE: begin
					if (!i_enable) begin
						state_w = IDLE;
					end else if (i_stop) begin 
						hex_output_w = 3'b011;
						state_w = STOP;
						addr_w = 0;
					end else if (i_pause) begin
						hex_output_w = 3'b100;
						state_w = PLAY;
					end
					case (play_mode_r)
						NORMAL: begin
								if (i_speed_up) begin
									play_mode_w = FAST;
									speed_w = 1;
								end else if (i_speed_down) begin
									play_mode_w = SLOW;
									speed_w = 1;
								end
						end

						FAST: begin 
								if (i_speed_up) begin
									if (speed_r != 7) begin
										speed_w = speed_r + 1;
									end
								end else if (i_speed_down) begin
									if (speed_r == 1) begin
										play_mode_w = NORMAL;
										speed_w = 0;
									end else begin
										speed_w = speed_r - 1;
									end
								end
						end

						SLOW: begin 
								if (i_speed_down) begin
									if (speed_r != 7) begin
										speed_w = speed_r + 1;
									end
								end else if (i_speed_up) begin
									if (speed_r == 1) begin
										play_mode_w = NORMAL;
										speed_w = 0;
									end else begin
										speed_w = speed_r - 1;
									end
								end
						end
					endcase // play_mode_r
			end


		endcase // state_r

	end

	always_ff @(posedge i_DACLRCK or posedge i_rst) begin
		if(i_rst) begin
			state_r <= IDLE;
			hex_output_r <= 3'b100;
			play_mode_r <= NORMAL;
			data_r <= 0;
			data_pre_r <= 0;
			output_data_r <= 0;
			addr_r <= 0;
			speed_r <= 0;
			spd_counter_r <= 0;
//			counter_r <= 0;
		end else begin
			state_r <= state_w;
			hex_output_r <= hex_output_w;
			play_mode_r <= play_mode_w;
			data_r <= data_w;
			data_pre_r <= data_pre_w;
			output_data_r <= output_data_w;
			addr_r <= addr_w;
			speed_r <= speed_w;
			spd_counter_r <= spd_counter_w;
//			counter_r <= counter_w;
		end
	end




endmodule // sramReader