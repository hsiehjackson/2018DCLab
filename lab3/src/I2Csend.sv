module I2Csend(
	input i_clk,
	input i_start,
	input i_rst,
	input [23:0] i_data,
	output o_finished,
	output o_scl,
	inout io_sda
);

	localparam [23:0] RESET = 24'b0011_0100_000_1111_0_0000_0000;

	localparam S_START = 0;
	localparam S_SCLOW = 1;
	localparam S_ACK = 2;
	localparam S_FINAL = 3;

	localparam EIGHT_BITS = 8;


	logic  [1:0]  state_r, state_w;
	logic  [3:0]  bit_cnt_r, bit_cnt_w;
	logic  [1:0]  byte_cnt_r, byte_cnt_w;
	logic         scl_r, scl_w;
	logic         oack_r, oack_w;
	logic  [23:0] i_data_r, i_data_w;
	logic         o_bit_r, o_bit_w;
	logic         o_finished_r, o_finished_w;

	assign o_finished = o_finished_r;
	assign o_scl = scl_r;
	assign io_sda = oack_r ? o_bit_r : 1'bz;

	always_comb begin
		state_w      = state_r;
		bit_cnt_w    = bit_cnt_r;
		byte_cnt_w   = byte_cnt_r;
		scl_w        = scl_r;
		oack_w       = oack_r;
		i_data_w     = i_data_r;
		o_bit_w      = o_bit_r;
		o_finished_w = o_finished_r;
		//SCL LOW -> SDA can change
		//SCL HIGH -> SDA READ 
		case (state_r)
			S_START:
			begin
				if (i_start) begin
					state_w = S_SCLOW;
					bit_cnt_w = 0;
					byte_cnt_w = 0;
					i_data_w = i_data;
					o_finished_w = 0;
					o_bit_w = 0;
				end
			end
			S_SCLOW:
			begin
				scl_w = 0;
				if (!scl_r) begin
					state_w = S_ACK;
					o_bit_w = i_data_r[23];
					i_data_w = i_data_r << 1;
				end
			end
			S_ACK:
			begin
				if (scl_r == 0) begin //BLUE
					scl_w = 1;
				end 
				else if (scl_r == 1) begin //GREEN
					bit_cnt_w = bit_cnt_r + 1;
					scl_w = 0;
					if (bit_cnt_r < EIGHT_BITS-1) begin
						o_bit_w = i_data_r[23];
						i_data_w = i_data_r << 1;
					end 
					else if (bit_cnt_r == EIGHT_BITS-1) begin
						oack_w = 0;
					end 
					else if (bit_cnt_r == EIGHT_BITS && byte_cnt_r != 2) begin
						byte_cnt_w = byte_cnt_r + 1;
						oack_w = 1;
						bit_cnt_w = 0;
						i_data_w = i_data_r << 1;
						o_bit_w = i_data_r[23];
					end 
					else if (bit_cnt_r == EIGHT_BITS && byte_cnt_r == 2) begin
						oack_w = 1;
						o_bit_w = 0;
						state_w = S_FINAL;
					end
				end
			end
			S_FINAL:
			begin
				scl_w = 1;
				if (scl_r) begin
					state_w = S_START;
					o_bit_w = 1;
					o_finished_w = 1;
				end
			end
		endcase
	end

	always_ff @(posedge i_clk or posedge i_rst) begin
		if (i_rst) begin
			state_r      <= S_START;
			bit_cnt_r    <= 0;
			byte_cnt_r   <= 0;
			scl_r        <= 1;
			oack_r       <= 1;
			i_data_r     <= RESET;
			o_bit_r      <= 1;
			o_finished_r <= 0;
		end
		else begin
			state_r      <= state_w;
			bit_cnt_r    <= bit_cnt_w;
			byte_cnt_r   <= byte_cnt_w;
			scl_r        <= scl_w;
			oack_r       <= oack_w;
			i_data_r     <= i_data_w;
			o_bit_r      <= o_bit_w;
			o_finished_r <= o_finished_w;
		end
	end
endmodule
