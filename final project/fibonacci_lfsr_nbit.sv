module fibonacci_lfsr_nbit
   #(parameter BITS = 5)
   (
    input             clk,
    input             rst_n,

    output reg [4:0] data
    );

   reg [4:0] data_next;
   always_comb begin
      data_next = data;
      repeat(BITS) begin
         data_next = {(data_next[4]^data_next[1]), data_next[4:1]};
      end
   end

   always_ff @(posedge clk) 
	begin
         data <= data_next;
   end

endmodule