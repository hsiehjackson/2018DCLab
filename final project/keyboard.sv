module keyboardRecv(
	input i_clk,
	input i_rst,
	input i_quick_clk,
	input i_data,
	output [7:0] o_key
);

	logic [7:0] key_r, key_w;
	logic [7:0] key_pre_r, key_pre_w;
	logic [3:0] counter_r, counter_w;
	logic [19:0] error_counter_r, error_counter_w;

	assign o_key = (error_counter_r == 20'd1048575)? 8'd0 : key_r;
	assign key_pre_w = {i_data, key_pre_r[7:1]};
	
	always_comb begin
		if(error_counter_r == 20'd1048575)
			counter_w = 4'd1;
		else begin
			if(counter_r == 4'd10)
				counter_w = 4'd0;
			else
				counter_w = counter_r + 4'd1;
		end

		if(counter_r == 4'd9) begin
			key_w = key_pre_r;
		end
		else begin
			key_w = key_r;
		end

		if(error_counter_r >= 20'd1048575)
			error_counter_w = 20'd1048575;
		else
			error_counter_w = error_counter_r + 20'd1;
	end
	
	always_ff@(negedge i_clk) begin
		counter_r <= counter_w;
		key_r     <= key_w;
		key_pre_r <= key_pre_w;
	end
	
	always_ff@(negedge i_clk or posedge i_quick_clk) begin
		if(~i_clk)
			error_counter_r <= 20'd0;
		else
			error_counter_r <= error_counter_w;
	end
	
endmodule