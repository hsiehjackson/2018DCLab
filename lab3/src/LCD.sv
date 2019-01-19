module LCD(
    output [7:0] CHARACTER,
    output [7:0] ADDRESS,

    output START,
    output CLEAR,
    input BUSY,

    input i_clk,
    input i_rst,
    input [2:0]   INPUT_STATE,
    input  [19:0] INPUT_ADDR,
    input  [4:0]  INPUT_SPEED,
    input mode,
    input [19:0]  END_ADDR
);

enum{
    PLAY,
    S_PLAY,
    PAUSE,
    S_PAUSE,
    STOP,
    S_STOP,
    RECORD,
    S_RECORD,
    IDLE
}states;

parameter [2:0] INPUT_INIT   = 3'b000;
parameter [2:0] INPUT_IDLE   = 3'b001;
parameter [2:0] INPUT_RECORD = 3'b010;
parameter [2:0] INPUT_STOP   = 3'b011;
parameter [2:0] INPUT_PLAY   = 3'b100;
parameter [2:0] INPUT_PAUSE  = 3'b101;

logic [4:0] state;

logic start;
logic clear;

logic [63:0] clock_counter;
logic [63:0] last_clock;
logic [7:0] address;
logic [4:0] time_sec;
logic [4:0] duration;
assign duration = 5'd16 / (END_ADDR[19:15]) * INPUT_ADDR[19:15];
assign time_sec = INPUT_ADDR[19:15];


always_ff @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        state <= RECORD;
        start <= 0;
        clear <= 0;
        address <= 8'b0;
        clock_counter <= 64'b0;
        last_clock <= 64'b0;
    end
    else begin

        clock_counter <= clock_counter + 1;
             if (state == PLAY) begin
                START <= 0;
                last_clock <= clock_counter;
                if (INPUT_STATE == INPUT_PLAY) begin
                    state <= S_PLAY;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_PAUSE) begin
                    state <= S_PAUSE;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_STOP) begin
                    state <= S_STOP;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_RECORD) begin
                    state <= S_RECORD;
                    address <= 8'h0;
                end
            end
            else if (state == S_PLAY) begin
                if (clock_counter > last_clock + 10) begin
                    last_clock <= clock_counter;
                    case (address)
                        8'h00 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h00;
                                        CHARACTER <= P; // P
                                        address <= 8'h01;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h01 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h01;
                                        CHARACTER <= L; // L
                                        address <= 8'h02;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h02 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h02;
                                        CHARACTER <= A; // A
                                        address <= 8'h03;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h03 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h03;
                                        CHARACTER <= Y; // Y
                                        address <= 8'h04;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h04 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h04;
                                        CHARACTER <= Space; // _
                                        address <= 8'h05;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h05 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h05;
                                        CHARACTER <= Space; // _
                                        address <= 8'h06;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end             
                        8'h06 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h06;
                                        CHARACTER <= Space; // _
                                        address <= 8'h07;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end                
                        8'h07 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h07;
                                        CHARACTER <= T;   
                                        address <= 8'h08;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h08 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h08;
                                        CHARACTER <= ABOUT; 
                                        address <= 8'h09;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end                     
                        8'h09 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h09;
                                        address <= 8'h0A;
                                        case (time_sec)
                                            5'h0: CHARACTER <= D0; 
                                            5'h1: CHARACTER <= D0; 
                                            5'h2: CHARACTER <= D0; 
                                            5'h3: CHARACTER <= D0; 
                                            5'h4: CHARACTER <= D0; 
                                            5'h5: CHARACTER <= D0; 
                                            5'h6: CHARACTER <= D0; 
                                            5'h7: CHARACTER <= D0; 
                                            5'h8: CHARACTER <= D0; 
                                            5'h9: CHARACTER <= D0; 
                                            5'ha: CHARACTER <= D1;
                                            5'hb: CHARACTER <= D1;
                                            5'hc: CHARACTER <= D1;
                                            5'hd: CHARACTER <= D1;
                                            5'he: CHARACTER <= D1;
                                            5'hf: CHARACTER <= D1;
                                            5'h10: CHARACTER <= D1;
                                            5'h11: CHARACTER <= D1;
                                            5'h12: CHARACTER <= D1;
                                            5'h13: CHARACTER <= D1;    
                                            5'h14: CHARACTER <= D2;
                                            5'h15: CHARACTER <= D2;
                                            5'h16: CHARACTER <= D2;
                                            5'h17: CHARACTER <= D2;
                                            5'h18: CHARACTER <= D2;
                                            5'h19: CHARACTER <= D2;
                                            5'h1a: CHARACTER <= D2;
                                            5'h1b: CHARACTER <= D2;
                                            5'h1c: CHARACTER <= D2;
                                            5'h1d: CHARACTER <= D2;
                                            5'h1e: CHARACTER <= D3;
                                            5'h1f: CHARACTER <= D3;
                                            default : CHARACTER <= D0; // 0
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0A : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0A;
                                        address <= 8'h0B;
                                        case (time_sec)
                                            5'h0: CHARACTER <= D0; 
                                            5'h1: CHARACTER <= D1; 
                                            5'h2: CHARACTER <= D2; 
                                            5'h3: CHARACTER <= D3; 
                                            5'h4: CHARACTER <= D4; 
                                            5'h5: CHARACTER <= D5; 
                                            5'h6: CHARACTER <= D6; 
                                            5'h7: CHARACTER <= D7; 
                                            5'h8: CHARACTER <= D8; 
                                            5'h9: CHARACTER <= D9; 
                                            5'ha: CHARACTER <= D0;
                                            5'hb: CHARACTER <= D1;
                                            5'hc: CHARACTER <= D2;
                                            5'hd: CHARACTER <= D3;
                                            5'he: CHARACTER <= D4;
                                            5'hf: CHARACTER <= D5;
                                            5'h10: CHARACTER <= D6;
                                            5'h11: CHARACTER <= D7;
                                            5'h12: CHARACTER <= D8;
                                            5'h13: CHARACTER <= D9;    
                                            5'h14: CHARACTER <= D0;
                                            5'h15: CHARACTER <= D1;
                                            5'h16: CHARACTER <= D2;
                                            5'h17: CHARACTER <= D3;
                                            5'h18: CHARACTER <= D4;
                                            5'h19: CHARACTER <= D5;
                                            5'h1a: CHARACTER <= D6;
                                            5'h1b: CHARACTER <= D7;
                                            5'h1c: CHARACTER <= D8;
                                            5'h1d: CHARACTER <= D9;
                                            5'h1e: CHARACTER <= D0;
                                            5'h1f: CHARACTER <= D1;
                                            default : CHARACTER <= D0; // 0
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0B : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0B;
                                        CHARACTER <= Space; // _
                                        address <= 8'h0C;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0C : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0C;
                                        CHARACTER <= mode?V:Space;
                                        address <= 8'h0D;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0D : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0D;
                                        CHARACTER <= mode?ABOUT:Space;
                                        address <= 8'h0E;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0E : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0E;
                                        address <= 8'h0F;
													              case(INPUT_SPEED)
                                              5'b00000: CHARACTER<= Space;
                                              5'b00001: CHARACTER<= D0;
                                              5'b00010: CHARACTER<= D0;
                                              5'b00011: CHARACTER<= D0;
                                              5'b00100: CHARACTER<= D0;
                                              5'b00101: CHARACTER<= D0;
                                              5'b00110: CHARACTER<= D0;
                                              5'b00111: CHARACTER<= D0;
                                              5'b01000: CHARACTER<= D0;
                                              5'b10010: CHARACTER<= D10;
                                              5'b10011: CHARACTER<= D10;
                                              5'b10100: CHARACTER<= D10;
                                              5'b10101: CHARACTER<= D10;
                                              5'b10110: CHARACTER<= D10;
                                              5'b10111: CHARACTER<= D10;
                                              5'b11000: CHARACTER<= D10;
                                              5'b10001: CHARACTER<= D0;
                                              default: CHARACTER<= Space;
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0F : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0F;
                                        address <= 8'h40;
                                        case(INPUT_SPEED)
                                              5'b00000: CHARACTER<= Space;
                                              5'b00001: CHARACTER<= D1;
                                              5'b00010: CHARACTER<= D2;
                                              5'b00011: CHARACTER<= D3;
                                              5'b00100: CHARACTER<= D4;
                                              5'b00101: CHARACTER<= D5;
                                              5'b00110: CHARACTER<= D6;
                                              5'b00111: CHARACTER<= D7;
                                              5'b01000: CHARACTER<= D8;
                                              5'b11000: CHARACTER<= D8;
                                              5'b10111: CHARACTER<= D7;
                                              5'b10110: CHARACTER<= D6;
                                              5'b10101: CHARACTER<= D5;
                                              5'b10100: CHARACTER<= D4;
                                              5'b10011: CHARACTER<= D3;
                                              5'b10010: CHARACTER<= D2;
                                              5'b10001: CHARACTER<= D1;
                                              default: CHARACTER<= Space;
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h40 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h40;
                                        if (duration > 5'd1) begin
                                          CHARACTER <= D8; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h41;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h41 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h41;
                                        if (duration > 5'd2) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h42;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h42 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h42;
                                        if (duration > 5'd3) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h43;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h43 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h43;
                                        if (duration > 5'd4) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h44;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h44 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h44;
                                        if (duration > 5'd5) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h45;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h45 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h45;
                                        if (duration > 5'd6) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h46;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end   
                        8'h46 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h46;
                                        if (duration > 5'd7) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h47;
                                    end
                                    else begin
                                        START <= 0;
                                    end        
                                end
                        8'h47 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h47;
                                        if (duration > 5'd8) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h48;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h48 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h48;
                                        if (duration > 5'd9) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h49;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h49 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h49;
                                        if (duration > 5'd10) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h4A;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4A : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4A;
                                        if (duration > 5'd11) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h4B;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4B : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4B;
                                        if (duration > 5'd12) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h4C;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4C : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4C;
                                        if (duration > 5'd13) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h4D;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4D : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4D;
                                        if (duration > 5'd14) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h4E;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4E : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4E;
                                        if (duration > 5'd15) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        address <= 8'h4F;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4F : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4F;
                                        if (duration == 5'd16) begin
                                          CHARACTER <= D; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        state <= RECORD;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        default : begin state <= PLAY; end
                    endcase
                end
            end
            else if (state == PAUSE) begin
                START <= 0;
                last_clock <= clock_counter;
                if (INPUT_STATE == INPUT_PLAY) begin
                    state <= S_PLAY;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_PAUSE) begin
                    state <= S_PAUSE;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_STOP) begin
                    state <= S_STOP;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_RECORD) begin
                    state <= S_RECORD;
                    address <= 8'h0;
                end
            end
            else if (state == S_PAUSE) begin
                if (clock_counter > last_clock + 10) begin
                    last_clock <= clock_counter;
                    case (address)
                        8'h00 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h00;
                                        CHARACTER <= P; // P
                                        address <= 8'h01;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h01 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h01;
                                        CHARACTER <= A; // A
                                        address <= 8'h02;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h02 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h02;
                                        CHARACTER <= U; // U
                                        address <= 8'h03;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h03 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h03;
                                        CHARACTER <= S; // S
                                        address <= 8'h04;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h04 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h04;
                                        CHARACTER <= E; // E
                                        address <= 8'h05;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h05 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h05;
                                        CHARACTER <= Space; // _
                                        address <= 8'h06;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end             
                        8'h06 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h06;
                                        CHARACTER <= Space; // _
                                        address <= 8'h07;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end                
                        8'h07 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h07;
                                        CHARACTER <= T;   
                                        address <= 8'h08;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h08 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h08;
                                        CHARACTER <= ABOUT; 
                                        address <= 8'h09;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end                     
                        8'h09 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h09;
                                        address <= 8'h0A;
                                        case (time_sec)
                                            5'h0: CHARACTER <= D0; 
                                            5'h1: CHARACTER <= D0; 
                                            5'h2: CHARACTER <= D0; 
                                            5'h3: CHARACTER <= D0; 
                                            5'h4: CHARACTER <= D0; 
                                            5'h5: CHARACTER <= D0; 
                                            5'h6: CHARACTER <= D0; 
                                            5'h7: CHARACTER <= D0; 
                                            5'h8: CHARACTER <= D0; 
                                            5'h9: CHARACTER <= D0; 
                                            5'ha: CHARACTER <= D1;
                                            5'hb: CHARACTER <= D1;
                                            5'hc: CHARACTER <= D1;
                                            5'hd: CHARACTER <= D1;
                                            5'he: CHARACTER <= D1;
                                            5'hf: CHARACTER <= D1;
                                            5'h10: CHARACTER <= D1;
                                            5'h11: CHARACTER <= D1;
                                            5'h12: CHARACTER <= D1;
                                            5'h13: CHARACTER <= D1;    
                                            5'h14: CHARACTER <= D2;
                                            5'h15: CHARACTER <= D2;
                                            5'h16: CHARACTER <= D2;
                                            5'h17: CHARACTER <= D2;
                                            5'h18: CHARACTER <= D2;
                                            5'h19: CHARACTER <= D2;
                                            5'h1a: CHARACTER <= D2;
                                            5'h1b: CHARACTER <= D2;
                                            5'h1c: CHARACTER <= D2;
                                            5'h1d: CHARACTER <= D2;
                                            5'h1e: CHARACTER <= D3;
                                            5'h1f: CHARACTER <= D3;
                                            default : CHARACTER <= D0; // 0
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0A : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0A;
                                        address <= 8'h0B;
                                        case (time_sec)
                                            5'h0: CHARACTER <= D0; 
                                            5'h1: CHARACTER <= D1; 
                                            5'h2: CHARACTER <= D2; 
                                            5'h3: CHARACTER <= D3; 
                                            5'h4: CHARACTER <= D4; 
                                            5'h5: CHARACTER <= D5; 
                                            5'h6: CHARACTER <= D6; 
                                            5'h7: CHARACTER <= D7; 
                                            5'h8: CHARACTER <= D8; 
                                            5'h9: CHARACTER <= D9; 
                                            5'ha: CHARACTER <= D0;
                                            5'hb: CHARACTER <= D1;
                                            5'hc: CHARACTER <= D2;
                                            5'hd: CHARACTER <= D3;
                                            5'he: CHARACTER <= D4;
                                            5'hf: CHARACTER <= D5;
                                            5'h10: CHARACTER <= D6;
                                            5'h11: CHARACTER <= D7;
                                            5'h12: CHARACTER <= D8;
                                            5'h13: CHARACTER <= D9;    
                                            5'h14: CHARACTER <= D0;
                                            5'h15: CHARACTER <= D1;
                                            5'h16: CHARACTER <= D2;
                                            5'h17: CHARACTER <= D3;
                                            5'h18: CHARACTER <= D4;
                                            5'h19: CHARACTER <= D5;
                                            5'h1a: CHARACTER <= D6;
                                            5'h1b: CHARACTER <= D7;
                                            5'h1c: CHARACTER <= D8;
                                            5'h1d: CHARACTER <= D9;
                                            5'h1e: CHARACTER <= D0;
                                            5'h1f: CHARACTER <= D1;
                                            default : CHARACTER <= D0; // 0
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0B : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0B;
                                        CHARACTER <= Space; // _
                                        address <= 8'h0C;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0C : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0C;
                                        CHARACTER <= mode?V:Space;
                                        address <= 8'h0D;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0D : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0D;
                                        CHARACTER <= mode?ABOUT:Space;
                                        address <= 8'h0E;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0E : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0E;
                                        address <= 8'h0F;
                                        case(INPUT_SPEED)
                                              5'b00000: CHARACTER<= Space;
                                              5'b00001: CHARACTER<= D0;
                                              5'b00010: CHARACTER<= D0;
                                              5'b00011: CHARACTER<= D0;
                                              5'b00100: CHARACTER<= D0;
                                              5'b00101: CHARACTER<= D0;
                                              5'b00110: CHARACTER<= D0;
                                              5'b00111: CHARACTER<= D0;
                                              5'b01000: CHARACTER<= D0;
                                              5'b10010: CHARACTER<= D10;
                                              5'b10011: CHARACTER<= D10;
                                              5'b10100: CHARACTER<= D10;
                                              5'b10101: CHARACTER<= D10;
                                              5'b10110: CHARACTER<= D10;
                                              5'b10111: CHARACTER<= D10;
                                              5'b10111: CHARACTER<= D10;
                                              5'b11000: CHARACTER<= D10;
                                              5'b10001: CHARACTER<= D0;
                                              default: CHARACTER<= Space;
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0F : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0F;
                                        address <= 8'h40;
                                        case(INPUT_SPEED)
                                              5'b00000: CHARACTER<= Space;
                                              5'b00001: CHARACTER<= D1;
                                              5'b00010: CHARACTER<= D2;
                                              5'b00011: CHARACTER<= D3;
                                              5'b00100: CHARACTER<= D4;
                                              5'b00101: CHARACTER<= D5;
                                              5'b00110: CHARACTER<= D6;
                                              5'b00111: CHARACTER<= D7;
                                              5'b01000: CHARACTER<= D8;
                                              5'b11000: CHARACTER<= D8;
                                              5'b10111: CHARACTER<= D7;
                                              5'b10110: CHARACTER<= D6;
                                              5'b10101: CHARACTER<= D5;
                                              5'b10100: CHARACTER<= D4;
                                              5'b10011: CHARACTER<= D3;
                                              5'b10010: CHARACTER<= D2;
                                              5'b10001: CHARACTER<= D1;
                                              default: CHARACTER<= Space;
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                         8'h40 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h40;
                                        if (mode == 1) begin
                                        if (duration > 5'd1) begin
                                          CHARACTER <= D8; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= D8;
                                        end
                                        address <= 8'h41;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h41 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h41;
                                        if (mode == 1) begin
                                        if (duration > 5'd2) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h42;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h42 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h42;
                                        if (mode == 1) begin
                                        if (duration > 5'd3) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h43;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h43 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h43;
                                        if (mode == 1) begin
                                        if (duration > 5'd4) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h44;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h44 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h44;
                                        if (mode == 1) begin
                                        if (duration > 5'd5) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h45;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h45 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h45;
                                        if (mode == 1) begin
                                        if (duration > 5'd6) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h46;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end   
                        8'h46 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h46;
                                        if (mode == 1) begin
                                        if (duration > 5'd7) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h47;
                                    end
                                    else begin
                                        START <= 0;
                                    end        
                                end
                        8'h47 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h47;
                                        if (mode == 1) begin
                                        if (duration > 5'd8) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h48;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h48 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h48;
                                        if (mode == 1) begin
                                        if (duration > 5'd9) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h49;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h49 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h49;
                                        if (mode == 1) begin
                                        if (duration > 5'd10) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4A;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4A : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4A;
                                        if (mode == 1) begin
                                        if (duration > 5'd11) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4B;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4B : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4B;
                                        if (mode == 1) begin
                                        if (duration > 5'd12) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4C;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4C : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4C;
                                        if (mode == 1) begin
                                        if (duration > 5'd13) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4D;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4D : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4D;
                                        if (mode == 1) begin
                                        if (duration > 5'd14) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4E;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4E : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4E;
                                        if (mode == 1) begin
                                        if (duration > 5'd15) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4F;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4F : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4F;
                                        if (mode == 1) begin
                                        if (duration == 5'd16) begin
                                          CHARACTER <= D; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= D;
                                        end
                                        state <= RECORD;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        default : state <= PAUSE;
                    endcase
                end
            end
            else if (state == STOP) begin
                START <= 0;
                last_clock <= clock_counter;
                if (INPUT_STATE == INPUT_PLAY) begin
                    state <= S_PLAY;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_PAUSE) begin
                    state <= S_PAUSE;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_STOP) begin
                    state <= S_STOP;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_RECORD) begin
                    state <= S_RECORD;
                    address <= 8'h0;
                end
            end
            else if (state == S_STOP) begin
                if (clock_counter > last_clock + 10) begin
                    last_clock <= clock_counter;
                    case (address)
                        8'h00 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h00;
                                        CHARACTER <= S; 
                                        address <= 8'h01;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h01 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h01;
                                        CHARACTER <= T; 
                                        address <= 8'h02;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h02 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h02;
                                        CHARACTER <= O; 
                                        address <= 8'h03;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h03 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h03;
                                        CHARACTER <= P; 
                                        address <= 8'h04;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h04 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h04;
                                        CHARACTER <= Space; // _
                                        address <= 8'h05;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h05 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h05;
                                        CHARACTER <= Space; // _
                                        address <= 8'h06;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end             
                        8'h06 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h06;
                                        CHARACTER <= Space; // _
                                        address <= 8'h07;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end                
                        8'h07 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h07;
                                        CHARACTER <= T;   
                                        address <= 8'h08;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h08 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h08;
                                        CHARACTER <= ABOUT; 
                                        address <= 8'h09;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end                     
                        8'h09 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h09;
                                        address <= 8'h0A;
                                        case (time_sec)
                                            5'h0: CHARACTER <= D0; 
                                            5'h1: CHARACTER <= D0; 
                                            5'h2: CHARACTER <= D0; 
                                            5'h3: CHARACTER <= D0; 
                                            5'h4: CHARACTER <= D0; 
                                            5'h5: CHARACTER <= D0; 
                                            5'h6: CHARACTER <= D0; 
                                            5'h7: CHARACTER <= D0; 
                                            5'h8: CHARACTER <= D0; 
                                            5'h9: CHARACTER <= D0; 
                                            5'ha: CHARACTER <= D1;
                                            5'hb: CHARACTER <= D1;
                                            5'hc: CHARACTER <= D1;
                                            5'hd: CHARACTER <= D1;
                                            5'he: CHARACTER <= D1;
                                            5'hf: CHARACTER <= D1;
                                            5'h10: CHARACTER <= D1;
                                            5'h11: CHARACTER <= D1;
                                            5'h12: CHARACTER <= D1;
                                            5'h13: CHARACTER <= D1;    
                                            5'h14: CHARACTER <= D2;
                                            5'h15: CHARACTER <= D2;
                                            5'h16: CHARACTER <= D2;
                                            5'h17: CHARACTER <= D2;
                                            5'h18: CHARACTER <= D2;
                                            5'h19: CHARACTER <= D2;
                                            5'h1a: CHARACTER <= D2;
                                            5'h1b: CHARACTER <= D2;
                                            5'h1c: CHARACTER <= D2;
                                            5'h1d: CHARACTER <= D2;
                                            5'h1e: CHARACTER <= D3;
                                            5'h1f: CHARACTER <= D3;
                                            default : CHARACTER <= D0; // 0
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0A : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0A;
                                        address <= 8'h0B;
                                        case (time_sec)
                                            5'h0: CHARACTER <= D0; 
                                            5'h1: CHARACTER <= D1; 
                                            5'h2: CHARACTER <= D2; 
                                            5'h3: CHARACTER <= D3; 
                                            5'h4: CHARACTER <= D4; 
                                            5'h5: CHARACTER <= D5; 
                                            5'h6: CHARACTER <= D6; 
                                            5'h7: CHARACTER <= D7; 
                                            5'h8: CHARACTER <= D8; 
                                            5'h9: CHARACTER <= D9; 
                                            5'ha: CHARACTER <= D0;
                                            5'hb: CHARACTER <= D1;
                                            5'hc: CHARACTER <= D2;
                                            5'hd: CHARACTER <= D3;
                                            5'he: CHARACTER <= D4;
                                            5'hf: CHARACTER <= D5;
                                            5'h10: CHARACTER <= D6;
                                            5'h11: CHARACTER <= D7;
                                            5'h12: CHARACTER <= D8;
                                            5'h13: CHARACTER <= D9;    
                                            5'h14: CHARACTER <= D0;
                                            5'h15: CHARACTER <= D1;
                                            5'h16: CHARACTER <= D2;
                                            5'h17: CHARACTER <= D3;
                                            5'h18: CHARACTER <= D4;
                                            5'h19: CHARACTER <= D5;
                                            5'h1a: CHARACTER <= D6;
                                            5'h1b: CHARACTER <= D7;
                                            5'h1c: CHARACTER <= D8;
                                            5'h1d: CHARACTER <= D9;
                                            5'h1e: CHARACTER <= D0;
                                            5'h1f: CHARACTER <= D1;
                                            default : CHARACTER <= D0; // 0
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0B : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0B;
                                        CHARACTER <= Space; // _
                                        address <= 8'h0C;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0C : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0C;
                                        CHARACTER <= mode?V:Space;
                                        address <= 8'h0D;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0D : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0D;
                                        CHARACTER <= mode?ABOUT:Space;
                                        address <= 8'h0E;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0E : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0E;
                                        address <= 8'h0F;
													              case(INPUT_SPEED)
                                              5'b00000: CHARACTER<= Space;
                                              5'b00001: CHARACTER<= D0;
                                              5'b00010: CHARACTER<= D0;
                                              5'b00011: CHARACTER<= D0;
                                              5'b00100: CHARACTER<= D0;
                                              5'b00101: CHARACTER<= D0;
                                              5'b00110: CHARACTER<= D0;
                                              5'b00111: CHARACTER<= D0;
                                              5'b01000: CHARACTER<= D0;
                                              5'b10010: CHARACTER<= D10;
                                              5'b10011: CHARACTER<= D10;
                                              5'b10100: CHARACTER<= D10;
                                              5'b10101: CHARACTER<= D10;
                                              5'b10110: CHARACTER<= D10;
                                              5'b10111: CHARACTER<= D10;
                                              5'b10111: CHARACTER<= D10;
                                              5'b11000: CHARACTER<= D10;
                                              5'b10001: CHARACTER<= D0;
                                              default: CHARACTER<= Space;
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0F : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0F;
                                        address <= 8'h40;
                                        case(INPUT_SPEED)
                                              5'b00000: CHARACTER<= Space;
                                              5'b00001: CHARACTER<= D1;
                                              5'b00010: CHARACTER<= D2;
                                              5'b00011: CHARACTER<= D3;
                                              5'b00100: CHARACTER<= D4;
                                              5'b00101: CHARACTER<= D5;
                                              5'b00110: CHARACTER<= D6;
                                              5'b00111: CHARACTER<= D7;
                                              5'b01000: CHARACTER<= D8;
                                              5'b11000: CHARACTER<= D8;
                                              5'b10111: CHARACTER<= D7;
                                              5'b10110: CHARACTER<= D6;
                                              5'b10101: CHARACTER<= D5;
                                              5'b10100: CHARACTER<= D4;
                                              5'b10011: CHARACTER<= D3;
                                              5'b10010: CHARACTER<= D2;
                                              5'b10001: CHARACTER<= D1;
                                              default: CHARACTER<= Space;
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                                                 8'h40 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h40;
                                        if (mode == 1) begin
                                        if (duration > 5'd1) begin
                                          CHARACTER <= D8; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= D8;
                                        end
                                        address <= 8'h41;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h41 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h41;
                                        if (mode == 1) begin
                                        if (duration > 5'd2) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h42;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h42 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h42;
                                        if (mode == 1) begin
                                        if (duration > 5'd3) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h43;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h43 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h43;
                                        if (mode == 1) begin
                                        if (duration > 5'd4) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h44;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h44 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h44;
                                        if (mode == 1) begin
                                        if (duration > 5'd5) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h45;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h45 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h45;
                                        if (mode == 1) begin
                                        if (duration > 5'd6) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h46;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end   
                        8'h46 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h46;
                                        if (mode == 1) begin
                                        if (duration > 5'd7) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h47;
                                    end
                                    else begin
                                        START <= 0;
                                    end        
                                end
                        8'h47 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h47;
                                        if (mode == 1) begin
                                        if (duration > 5'd8) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h48;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h48 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h48;
                                        if (mode == 1) begin
                                        if (duration > 5'd9) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h49;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h49 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h49;
                                        if (mode == 1) begin
                                        if (duration > 5'd10) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4A;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4A : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4A;
                                        if (mode == 1) begin
                                        if (duration > 5'd11) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4B;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4B : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4B;
                                        if (mode == 1) begin
                                        if (duration > 5'd12) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4C;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4C : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4C;
                                        if (mode == 1) begin
                                        if (duration > 5'd13) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4D;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4D : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4D;
                                        if (mode == 1) begin
                                        if (duration > 5'd14) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4E;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4E : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4E;
                                        if (mode == 1) begin
                                        if (duration > 5'd15) begin
                                          CHARACTER <= Equa; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= Equa;
                                        end
                                        address <= 8'h4F;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4F : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4F;
                                        if (mode == 1) begin
                                        if (duration == 5'd16) begin
                                          CHARACTER <= D; // _
                                        end
                                        else begin
                                          CHARACTER <= Space;
                                        end
                                        end
                                        else begin
                                          CHARACTER <= D;
                                        end
                                        state <= RECORD;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        default : state <= STOP;
                    endcase
                end
            end

            else if (state == RECORD) begin
                START <= 0;
                last_clock <= clock_counter;
                if (INPUT_STATE == INPUT_PLAY) begin
                    state <= S_PLAY;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_PAUSE) begin
                    state <= S_PAUSE;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_STOP) begin
                    state <= S_STOP;
                    address <= 8'h0;
                end
                else if (INPUT_STATE == INPUT_RECORD) begin
                    state <= S_RECORD;
                    address <= 8'h0;
                end
            end
            else if (state == S_RECORD) begin
                if (clock_counter > last_clock + 10) begin
                    last_clock <= clock_counter;
                    case (address)
                        8'h00 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h00;
                                        CHARACTER <= R; 
                                        address <= 8'h01;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h01 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h01;
                                        CHARACTER <= E; 
                                        address <= 8'h02;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h02 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h02;
                                        CHARACTER <= C; 
                                        address <= 8'h03;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h03 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h03;
                                        CHARACTER <= O; 
                                        address <= 8'h04;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h04 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h04;
                                        CHARACTER <= R; // _
                                        address <= 8'h05;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h05 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h05;
                                        CHARACTER <= D; // _
                                        address <= 8'h06;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h06 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h06;
                                        CHARACTER <= Space; // _
                                        address <= 8'h07;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end                
                        8'h07 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h07;
                                        CHARACTER <= T;   
                                        address <= 8'h08;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h08 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h08;
                                        CHARACTER <= ABOUT; // _
                                        address <= 8'h09;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end                     
                        8'h09 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h09;
                                        address <= 8'h0A;
                                        case (time_sec)
                                            5'h0: CHARACTER <= D0; 
                                            5'h1: CHARACTER <= D0; 
                                            5'h2: CHARACTER <= D0; 
                                            5'h3: CHARACTER <= D0; 
                                            5'h4: CHARACTER <= D0; 
                                            5'h5: CHARACTER <= D0; 
                                            5'h6: CHARACTER <= D0; 
                                            5'h7: CHARACTER <= D0; 
                                            5'h8: CHARACTER <= D0; 
                                            5'h9: CHARACTER <= D0; 
                                            5'ha: CHARACTER <= D1;
                                            5'hb: CHARACTER <= D1;
                                            5'hc: CHARACTER <= D1;
                                            5'hd: CHARACTER <= D1;
                                            5'he: CHARACTER <= D1;
                                            5'hf: CHARACTER <= D1;
                                            5'h10: CHARACTER <= D1;
                                            5'h11: CHARACTER <= D1;
                                            5'h12: CHARACTER <= D1;
                                            5'h13: CHARACTER <= D1;    
                                            5'h14: CHARACTER <= D2;
                                            5'h15: CHARACTER <= D2;
                                            5'h16: CHARACTER <= D2;
                                            5'h17: CHARACTER <= D2;
                                            5'h18: CHARACTER <= D2;
                                            5'h19: CHARACTER <= D2;
                                            5'h1a: CHARACTER <= D2;
                                            5'h1b: CHARACTER <= D2;
                                            5'h1c: CHARACTER <= D2;
                                            5'h1d: CHARACTER <= D2;
                                            5'h1e: CHARACTER <= D3;
                                            5'h1f: CHARACTER <= D3;
                                            default : CHARACTER <= D0; // 0
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0A : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0A;
                                        address <= 8'h0B;
                                        case (time_sec)
                                            5'h0: CHARACTER <= D0; 
                                            5'h1: CHARACTER <= D1; 
                                            5'h2: CHARACTER <= D2; 
                                            5'h3: CHARACTER <= D3; 
                                            5'h4: CHARACTER <= D4; 
                                            5'h5: CHARACTER <= D5; 
                                            5'h6: CHARACTER <= D6; 
                                            5'h7: CHARACTER <= D7; 
                                            5'h8: CHARACTER <= D8; 
                                            5'h9: CHARACTER <= D9; 
                                            5'ha: CHARACTER <= D0;
                                            5'hb: CHARACTER <= D1;
                                            5'hc: CHARACTER <= D2;
                                            5'hd: CHARACTER <= D3;
                                            5'he: CHARACTER <= D4;
                                            5'hf: CHARACTER <= D5;
                                            5'h10: CHARACTER <= D6;
                                            5'h11: CHARACTER <= D7;
                                            5'h12: CHARACTER <= D8;
                                            5'h13: CHARACTER <= D9;    
                                            5'h14: CHARACTER <= D0;
                                            5'h15: CHARACTER <= D1;
                                            5'h16: CHARACTER <= D2;
                                            5'h17: CHARACTER <= D3;
                                            5'h18: CHARACTER <= D4;
                                            5'h19: CHARACTER <= D5;
                                            5'h1a: CHARACTER <= D6;
                                            5'h1b: CHARACTER <= D7;
                                            5'h1c: CHARACTER <= D8;
                                            5'h1d: CHARACTER <= D9;
                                            5'h1e: CHARACTER <= D0;
                                            5'h1f: CHARACTER <= D1;
                                            default : CHARACTER <= D0; // 0
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0B : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0B;
                                        CHARACTER <= Space; // _
                                        address <= 8'h0C;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0C : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0C;
                                        CHARACTER <= mode?V:Space;
                                        address <= 8'h0D;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0D : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0D;
                                        CHARACTER <= mode?ABOUT:Space;
                                        address <= 8'h0E;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0E : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0E;
                                        address <= 8'h0F;
                                        case(INPUT_SPEED)
                                              5'b00000: CHARACTER<= Space;
                                              5'b00001: CHARACTER<= D0;
                                              5'b00010: CHARACTER<= D0;
                                              5'b00011: CHARACTER<= D0;
                                              5'b00100: CHARACTER<= D0;
                                              5'b00101: CHARACTER<= D0;
                                              5'b00110: CHARACTER<= D0;
                                              5'b00111: CHARACTER<= D0;
                                              5'b01000: CHARACTER<= D0;
                                              5'b10010: CHARACTER<= D10;
                                              5'b10011: CHARACTER<= D10;
                                              5'b10100: CHARACTER<= D10;
                                              5'b10101: CHARACTER<= D10;
                                              5'b10110: CHARACTER<= D10;
                                              5'b10111: CHARACTER<= D10;
                                              5'b11000: CHARACTER<= D10;
                                              5'b10001: CHARACTER<= D0;
                                              default: CHARACTER<= Space;
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h0F : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h0F;
                                        address <= 8'h40;
                                        case(INPUT_SPEED)
                                              5'b00000: CHARACTER<= Space;
                                              5'b00001: CHARACTER<= D1;
                                              5'b00010: CHARACTER<= D2;
                                              5'b00011: CHARACTER<= D3;
                                              5'b00100: CHARACTER<= D4;
                                              5'b00101: CHARACTER<= D5;
                                              5'b00110: CHARACTER<= D6;
                                              5'b00111: CHARACTER<= D7;
                                              5'b01000: CHARACTER<= D8;
                                              5'b11000: CHARACTER<= D8;
                                              5'b10111: CHARACTER<= D7;
                                              5'b10110: CHARACTER<= D6;
                                              5'b10101: CHARACTER<= D5;
                                              5'b10100: CHARACTER<= D4;
                                              5'b10011: CHARACTER<= D3;
                                              5'b10010: CHARACTER<= D2;
                                              5'b10001: CHARACTER<= D1;
                                              default: CHARACTER<= Space;
                                        endcase
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h40 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h40;
                                        CHARACTER <= D8; // _
                                        address <= 8'h41;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h41 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h41;
                                        CHARACTER <= Equa;
                                        address <= 8'h42;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h42 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h42;
                                        CHARACTER <= Equa;
                                        address <= 8'h43;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h43 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h43;
                                        CHARACTER <= Equa;
                                        address <= 8'h44;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h44 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h44;
                                        CHARACTER <= Equa;
                                        address <= 8'h45;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h45 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h45;
                                        CHARACTER <= Equa;
                                        address <= 8'h46;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end    
                        8'h46 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h46;
                                        CHARACTER <= Equa;
                                        address <= 8'h47;
                                    end
                                    else begin
                                        START <= 0;
                                    end   
                                end
                        8'h47 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h47;
                                        CHARACTER <= Equa;
                                        address <= 8'h48;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h48 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h48;
                                        CHARACTER <= Equa;
                                        address <= 8'h49;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h49 : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h49;
                                        CHARACTER <= Equa;
                                        address <= 8'h4A;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4A : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4A;
                                        CHARACTER <= Equa;
                                        address <= 8'h4B;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4B : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4B;
                                        CHARACTER <= Equa;
                                        address <= 8'h4C;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4C : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4C;
                                        CHARACTER <= Equa;
                                        address <= 8'h4D;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4D : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4D;
                                        CHARACTER <= Equa;
                                        address <= 8'h4E;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4E : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4E;
                                        CHARACTER <= Equa;
                                        address <= 8'h4F;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        8'h4F : begin
                                    if (!BUSY) begin
                                        START <= 1;
                                        ADDRESS <= 8'h4F;
                                        CHARACTER <= D;
                                        state <= RECORD;
                                    end
                                    else begin
                                        START <= 0;
                                    end
                                end
                        default : state <= RECORD;
                    endcase
                end
            end
        //end
    end
end
localparam A = 8'h41;
localparam B = 8'h42;
localparam C = 8'h43;
localparam D = 8'h44;
localparam E = 8'h45;
localparam F = 8'h46;
localparam G = 8'h47;
localparam H = 8'h48;
localparam I = 8'h49;
localparam J = 8'h4A;
localparam K = 8'h4B;
localparam L = 8'h4C;
localparam M = 8'h4D;
localparam N = 8'h4E;
localparam O = 8'h4F;
localparam P = 8'h50;
localparam Q = 8'h51;
localparam R = 8'h52;
localparam S = 8'h53;
localparam T = 8'h54;
localparam U = 8'h55;
localparam V = 8'h56;
localparam W = 8'h57;
localparam X = 8'h58;
localparam Y = 8'h59;
localparam Z = 8'h5A;
localparam ABOUT = 8'b00111010;
localparam Space = 8'b00100000;
localparam Equa = 8'b00111101;

localparam D0 = 8'b00110000;
localparam D1 = 8'b00110001;
localparam D2 = 8'b00110010;
localparam D3 = 8'b00110011;
localparam D4 = 8'b00110100;
localparam D5 = 8'b00110101;
localparam D6 = 8'b00110110;
localparam D7 = 8'b00110111;
localparam D8 = 8'b00111000;
localparam D9 = 8'b00111001;
localparam D10 = 8'b10110000;
endmodule