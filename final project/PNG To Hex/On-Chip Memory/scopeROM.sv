/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  scopeROM
(
		input logic [18:0] read_address,
		output logic [3:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:4095];

initial
begin
	 $readmemh("sprite_bytes/scope.txt", mem);
end


always_comb
 begin
	data_Out<= mem[read_address];
end

endmodule
