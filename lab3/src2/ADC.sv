module ADC (
	input        i_BCLK,
	input        i_rst,
	input        i_start,
	input [15:0] sram_dq,
	output       aud_dacdat,
	output		 o_finished
);
	localparam IDLE = 0;
	localparam RUN = 1;
	logic state_r, state_w, finished_w, finished_r;
	logic [3:0] count_r, count_w;
	logic [15:0] data_r, data_w;

	assign o_finished = finished_r;
	assign aud_dacdat = data_r[15];

	always_comb begin
		state_w     = state_r;
		count_w     = count_r;
		finished_w  = finished_r;
		data_w      = data_r;
		
		case(state_r)
			IDLE:
			begin
				if (i_start) begin
					state_w = RUN;
					count_w = 0;
					data_w = sram_dq;
				end
			end
			RUN:
			begin
				if (count_r < 16) begin
					data_w = data_r << 1;
					count_w = count_r + 1;
				end
				if (count_r == 15) begin
					count_w = 0;
					state_w = IDLE;
					finished_w = 1'b1;        
				end
			end
		endcase
	end

	always_ff @(posedge i_BCLK or posedge i_rst) begin
		if (i_rst) begin
			count_r     <= 0;
			finished_r  <= 0;
			data_r      <= 0;
			state_r     <= IDLE;
		end
		else begin
			count_r     <= count_w;
			finished_r  <= finished_w;
			data_r      <= data_w;
			state_r     <= state_w;
		end
	end

endmodule