module DAC (
    input         i_BCLK,
    input         i_rst,
    input         i_start,
    input         aud_adcdat,
    output        o_finished,
    output [15:0] sram_dq
);

    localparam IDLE = 0;
    localparam RUN = 1;
    logic state_w, state_r, finished_r, finished_w;
    logic [4:0] count_w, count_r;
    logic [15:0] data_r, data_w;

    assign sram_dq = data_r;
    assign o_finished = finished_r;

    always_comb begin
        state_w    = state_r;
        count_w    = count_r;
        data_w     = data_r;
        finished_w = finished_r;

        case(state_r)
            IDLE:
            begin
                finished_w = 1'b0;
                if (i_start) begin
                    state_w = RUN;
                    count_w = 0;
                end
            end
            RUN:
            begin
                if (count_r < 16) begin
                    count_w = count_r + 1;
                    data_w = data_r << 1;
                    data_w[0] = aud_adcdat;
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
            count_r    <= 0;
            finished_r <= 0;
            data_r     <= 0;
            state_r    <= IDLE;
        end
        else begin
            count_r    <= count_w;
            finished_r <= finished_w;
            data_r     <= data_w;
            state_r    <= state_w;
        end
    end

endmodule