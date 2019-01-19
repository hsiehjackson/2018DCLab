module  numberROM
(       
		input logic [3:0] now_score ,
          input logic [18:0] read_address,
		output logic [3:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem0 [0:1599];
logic [3:0] mem1 [0:1599];
logic [3:0] mem2 [0:1599];
logic [3:0] mem3 [0:1599];
logic [3:0] mem4 [0:1599];
logic [3:0] mem5 [0:1599];
logic [3:0] mem6 [0:1599];
logic [3:0] mem7 [0:1599];
logic [3:0] mem8 [0:1599];
logic [3:0] mem9 [0:1599];
initial
begin
	 $readmemh("sprite_bytes/0.txt", mem0);
     $readmemh("sprite_bytes/1.txt", mem1);
     $readmemh("sprite_bytes/2.txt", mem2);
     $readmemh("sprite_bytes/3.txt", mem3);
     $readmemh("sprite_bytes/4.txt", mem4);
     $readmemh("sprite_bytes/5.txt", mem5);
     $readmemh("sprite_bytes/6.txt", mem6);
     $readmemh("sprite_bytes/7.txt", mem7);
     $readmemh("sprite_bytes/8.txt", mem8);
     $readmemh("sprite_bytes/9.txt", mem9);
end


always_comb
begin
     if (now_score == 0)
     begin
	     data_Out<= mem0[read_address];
     end
     else if (now_score ==1)
     begin
         data_Out<= mem1[read_address]; 
     end
     else if (now_score == 2)
     begin
	     data_Out<= mem2[read_address];
     end
     else if (now_score ==3)
     begin
         data_Out<= mem3[read_address]; 
     end
     else if (now_score == 4)
     begin
	     data_Out<= mem4[read_address];
     end
     else if (now_score == 5)
     begin
         data_Out<= mem5[read_address]; 
     end
     else if (now_score == 6)
     begin
	     data_Out<= mem6[read_address];
     end
     else if (now_score == 7)
     begin
         data_Out<= mem7[read_address]; 
     end
     else if (now_score == 8)
     begin
         data_Out<= mem8[read_address]; 
     end
     else 
     begin
	     data_Out<= mem9[read_address];
     end
     
end

endmodule
