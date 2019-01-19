`ifndef QUARTUS_II
    `include "RsaDefine.sv"
`endif

module Rsa256Wrapper(
    input [RSA_MAX_LOG2:0] i_RSA_BIT, //bit mode lenth 128-1024
    output LED_ready, //to light process
    input avm_rst,
    input avm_clk,
    output [4:0] avm_address, //to specified address (RX,TX,STATUS)
    output avm_read, //1 to tell I want read
    input [31:0] avm_readdata, //read in specified address
    output avm_write, // 1 to tell I want read
    output [31:0] avm_writedata, // write in specified address
    input avm_waitrequest // whether to wait for 
);
    //Avalon Memory -> avm
    localparam RX_BASE     = 0*4; //addr receive 0-31
    localparam TX_BASE     = 1*4; //addr transmit 32-63
    localparam STATUS_BASE = 2*4; //addr status 64-95
    localparam TX_OK_BIT = 6; //Transmit ready
    localparam RX_OK_BIT = 7; //Read ready

    // Feel free to design your own FSM!
    logic [2:0] STATE;
    localparam S_GET_KEY = 0;
    localparam S_GET_DATA = 1;
    localparam S_GET_ESC = 2;
    localparam S_WAIT_CALC = 3;
    localparam S_SEND_DATA = 4;

    localparam RSA_ESC = 0; // maybe PACKAGE_SIZE SIZE
    localparam RSA_ESC_END = 1; //maybe PACKAGE_SIZE SIZE

    //_w:wire to connect and use in combinational with assign
    //_r:register to use in flipflop with <=

    logic [RSA_BUS:0] n_w, n_r;
    logic [RSA_BUS:0] e_w, e_r; 
    logic [RSA_BUS:0] enc_w, enc_r;
    logic [RSA_BUS:0] dec_w, dec_r;
    logic [RSA_BUS:0] CHECK_ESC_w;
    assign n_w = n_r;
    assign e_w = e_r;
    assign enc_w = enc_r;
    assign CHECK_ESC_w = (enc_r<<8)|avm_readdata[7:0]; //check next 8 bit enc data is ESC

    logic rsa_start_w, rsa_start_r;
    assign rsa_start_w = rsa_start_r;

    logic rsa_finished_w;

    logic [RSA_MAX_LOG2:0] bytes_counter_r;
    logic [RSA_MAX_LOG2:0] RSA_PACKAGE_SIZE;  
    assign RSA_PACKAGE_SIZE = i_RSA_BIT>>3;  //PACKAGE_SIZE size = bitlength/8, every split to small package
    
    logic [4:0] avm_address_r;
    logic avm_read_r, avm_write_r;
    logic [7:0] avm_writedata_r;
    assign avm_address = avm_address_r;
    assign avm_read = avm_read_r;
    assign avm_write = avm_write_r;
    assign avm_writedata = avm_writedata_r;

    logic  LED_ready_r;
    assign LED_ready = LED_ready_r;

    Rsa256Core rsa256_core(
        .i_RSA_BIT(i_RSA_BIT),
        .i_clk(avm_clk),
        .i_rst(avm_rst),
        .i_start(rsa_start_w),
        .i_a(enc_w),
        .i_e(e_w),
        .i_n(n_w),
        .o_a_pow_e(dec_w),
        .o_finished(rsa_finished_w)
    );

    task StartRead;
        input [4:0] addr;
        begin
            avm_read_r = 1;
            avm_write_r = 0;
            avm_address_r = addr;
        end
    endtask
    task StartWrite;
        input [4:0] addr;
        begin
            avm_read_r = 0;
            avm_write_r = 1;
            avm_address_r = addr;
            case(i_RSA_BIT)
                128: begin avm_writedata_r <= dec_r[119-:8]; end
                256: begin avm_writedata_r <= dec_r[247-:8]; end
                512: begin avm_writedata_r <= dec_r[503-:8]; end
                1024: begin avm_writedata_r <= dec_r[1015-:8]; end
                default: begin avm_writedata_r <= dec_r[119-:8]; end //why ?
            endcase
        end
    endtask
    task Reset;
        begin
            n_r <= 0;
            e_r <= 0;
            enc_r <= 0;
            dec_r <= 0;
            StartRead(STATUS_BASE);
            STATE <= S_GET_KEY;
            bytes_counter_r <= 0;
            rsa_start_r <= 0;
            LED_ready_r <= 1;
        end
    endtask

    always_comb begin //_w
        // TODO
    end

    always_ff @(posedge avm_clk or posedge avm_rst) begin //_r
        if (avm_rst) begin
            Reset();
        end 
        else begin
            if (STATE == S_GET_KEY && avm_waitrequest==0) begin // Get key
                if (avm_address_r == STATUS_BASE) begin //if status address
                    if (avm_readdata[RX_OK_BIT]) begin //if ready 
                        LED_ready_r <= 0; //light up until reset
                        StartRead(RX_BASE); // go to read address
                    end
                end
                else if(avm_address_r == RX_BASE) begin //if read address 
                    if (bytes_counter_r < RSA_PACKAGE_SIZE) begin // because key length is 8*RSA_PACKAGE_SIZE 
                        n_r <= (n_r<<8)|avm_readdata[7:0]; //PACKAGE_SIZE length but only one byte
                    end
                    else begin // RSA_PACKAGE_SIZE ~ 2*RSA_PACKAGE_SIZE
                        e_r <= (e_r<<8)|avm_readdata[7:0]; //PACKAGE_SIZE length but only one byte
                    end
                    if (bytes_counter_r == RSA_PACKAGE_SIZE*2-1) begin //read key done!!!
                        bytes_counter_r <= 0;
                        STATE <= S_GET_DATA;
                        enc_r <= 0;
                        dec_r <= 0;
                    end
                    else begin
                        bytes_counter_r <= bytes_counter_r + 1; //collect transmit one byte
                    end
                    StartRead(STATUS_BASE); //go back status address 
                end
            end
            else if (STATE == S_GET_DATA && avm_waitrequest==0) begin
                //LED_ready_r <= 0; //light up 
                if (avm_address_r == STATUS_BASE) begin //if status address
                    if (avm_readdata[RX_OK_BIT]) begin //if ready
                        StartRead(RX_BASE); //go to read address
                    end
                end
                else if (avm_address_r == RX_BASE) begin // if read address
                    enc_r <= (enc_r<<8)|avm_readdata[7:0]; //trasmit last to RSA core
                    if (bytes_counter_r == RSA_PACKAGE_SIZE-1) begin //the last package 0~(PACKAGE_SIZE-1)
                        if (CHECK_ESC_w ==  RSA_ESC) begin
                            enc_r <= 0; // not transmit enc_r need double check bug??????????????
                            STATE <= S_GET_ESC;
                        end
                        else begin
                            rsa_start_r <= 1;
                            STATE <= S_WAIT_CALC;
                        end
                        bytes_counter_r <= 0; //!!!!!!
                    end
                    else begin
                        bytes_counter_r <= bytes_counter_r + 1;
                    end
                    StartRead(STATUS_BASE);
                end
            end
            else if (STATE == S_GET_ESC && avm_waitrequest==0) begin
                if (avm_address_r == STATUS_BASE) begin //if status address
                    if (avm_readdata[RX_OK_BIT]) begin // if ready
                        StartRead(RX_BASE); // go to read  address
                    end
                end
                else if (avm_address_r == RX_BASE) begin //if read address
                    enc_r <= (enc_r<<8)|avm_readdata[7:0]; //true transmit ESC chunk
                    if (bytes_counter_r == RSA_PACKAGE_SIZE-1) begin // last package
                        if(CHECK_ESC_w == RSA_ESC) begin
                            rsa_start_r <= 1;
                            STATE <= S_WAIT_CALC;
                        end
                        else if (CHECK_ESC_w == RSA_ESC_END) begin
                            Reset(); //already transmit all data package
                        end
                        else begin
                        end
                        bytes_counter_r <= 0;
                    end
                    else begin
                        bytes_counter_r <= bytes_counter_r + 1;
                    end
                    StartRead(STATUS_BASE);
                end
            end
            else if (STATE == S_WAIT_CALC) begin
                rsa_start_r <= 0;
                if (rsa_finished_w) begin
                    dec_r <= dec_w; //all decode data from core
                    STATE <= S_SEND_DATA;
                end
            end
            else if (STATE == S_SEND_DATA && avm_waitrequest==0) begin
                if (avm_address_r == STATUS_BASE) begin //if status 
                    if (avm_readdata[TX_OK_BIT]) begin //if ready
                        StartWrite(TX_BASE);//go to write address
                    end
                end
                else if (avm_address_r == TX_BASE) begin
                    if (bytes_counter_r == RSA_PACKAGE_SIZE-1-1) begin //less than original size-1
                        enc_r <= 0;
                        bytes_counter_r <= 0;            
                        STATE <= S_GET_DATA; //!!!don't reset
                    end
                    else begin 
                        bytes_counter_r <= bytes_counter_r + 1;
                    end 
                    dec_r <= dec_r << 8;
                    StartRead(STATUS_BASE);    
                end    
            end
        end
    end
endmodule