
module	VGA_Position(	//	Host Side
						iRed,
						iGreen,
						iBlue,
						oRequest,
						//	VGA Side
						oVGA_R,
						oVGA_G,
						oVGA_B,
						oVGA_H_SYNC,
						oVGA_V_SYNC,
						oVGA_SYNC,
						oVGA_BLANK,

						//	Control Signal
						iCLK,
						iRST_N,
						iZOOM_MODE_SW,
						X_center_r,
						Y_center_r,
						ready_r,
						is_light,
							);
`include "VGA_Param.h"

`ifdef VGA_640x480p60
//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	48;
parameter	H_SYNC_ACT	=	640;	
parameter	H_SYNC_FRONT=	16;
parameter	H_SYNC_TOTAL=	800;

//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	33;
parameter	V_SYNC_ACT	=	480;	
parameter	V_SYNC_FRONT=	10;
parameter	V_SYNC_TOTAL=	525; 

`else
 // SVGA_800x600p60
////	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	128;         //Peli
parameter	H_SYNC_BACK	=	88;
parameter	H_SYNC_ACT	=	800;	
parameter	H_SYNC_FRONT=	40;
parameter	H_SYNC_TOTAL=	1056;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	4;
parameter	V_SYNC_BACK	=	23;
parameter	V_SYNC_ACT	=	600;	
parameter	V_SYNC_FRONT=	1;
parameter	V_SYNC_TOTAL=	628;

`endif
//	Start Offset
parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK;
parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;
//	Host Side
input		[9:0]	iRed;
input		[9:0]	iGreen;
input		[9:0]	iBlue;
output	reg			oRequest;
output  reg         is_light;
//	VGA Side
output	reg	[9:0]	oVGA_R;
output	reg	[9:0]	oVGA_G;
output	reg	[9:0]	oVGA_B;
output	reg			oVGA_H_SYNC;
output	reg			oVGA_V_SYNC;
output	reg			oVGA_SYNC;
output	reg			oVGA_BLANK;
output  reg [9:0]  X_center_r;
output  reg [9:0]  Y_center_r;

wire		[9:0]	mVGA_R;
wire		[9:0]	mVGA_G;
wire		[9:0]	mVGA_B;

wire    	[9:0]	setVGA_R;
wire	    [9:0] 	setVGA_G;
wire		[9:0]	setVGA_B;
wire        [17:0] Y ;
wire        [7:0]  Y1;

reg					mVGA_H_SYNC;
reg					mVGA_V_SYNC;
wire				mVGA_SYNC;
wire				mVGA_BLANK;


// Get position
wire    ready_w;
output reg 	ready_r;
reg 	[12:0]  X_MIN;
reg 	[12:0]  X_MAX;
reg 	[12:0]  Y_MIN;
reg 	[12:0]  Y_MAX;
wire    [9:0]  X_center_w;
wire    [9:0]  Y_center_w;
wire    [12:0]  X_center_w1;
wire    [12:0]  Y_center_w1;
//	Control Signal
input				iCLK;
input				iRST_N;
input 				iZOOM_MODE_SW;

//	Internal Registers and Wires
reg		[12:0]		H_Cont;
reg		[12:0]		V_Cont;

wire	[12:0]		v_mask;

assign v_mask = 13'd0 ;//iZOOM_MODE_SW ? 13'd0 : 13'd26;
reg [5:0] count;
////////////////////////////////////////////////////////

assign	mVGA_BLANK	=	mVGA_H_SYNC & mVGA_V_SYNC;
assign	mVGA_SYNC	=	1'b0;

assign	mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iRed	:	0;
assign	mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iGreen	:	0;
assign	mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iBlue	:	0;
assign Y = mVGA_R * 77 +  mVGA_G *150 +  mVGA_B *29 ; 
assign Y1 = Y[15:8];
assign setVGA_R = (Y1 >= 255) ? mVGA_R : 10'hFF;
assign setVGA_G = (Y1 >= 255) ? mVGA_G : 10'hFF;
assign setVGA_B = (Y1 >= 255) ? mVGA_B : 10'hFF;
//assign setVGA_R = mVGA_R;
//assign setVGA_G = mVGA_G;
//assign setVGA_B = mVGA_B;
assign X_center_w1 = (X_MAX + X_MIN);
assign Y_center_w1 = (Y_MAX + Y_MIN);
assign X_center_w = X_center_w1[10:1];
assign Y_center_w = Y_center_w1[10:1];
assign ready_w = ready_r;

always@(posedge iCLK or negedge iRST_N)
	begin
		if (!iRST_N)
			begin
				oVGA_R <= 0;
				oVGA_G <= 0;
                oVGA_B <= 0;
				oVGA_BLANK <= 0;
				oVGA_SYNC <= 0;
				oVGA_H_SYNC <= 0;
				oVGA_V_SYNC <= 0; 
			end
		else
			begin
				oVGA_R <= setVGA_R;
				oVGA_G <= setVGA_G;
                oVGA_B <= setVGA_B;
				oVGA_BLANK <= mVGA_BLANK;
				oVGA_SYNC <= mVGA_SYNC;
				oVGA_H_SYNC <= mVGA_H_SYNC;
				oVGA_V_SYNC <= mVGA_V_SYNC;	
			end               
	end

always@(posedge iCLK or negedge iRST_N)
begin
	if (!iRST_N)
	begin
		X_center_r <= 0;
		X_center_r <= 0;
	end
	else
	begin
		X_center_r <= X_center_w;
		Y_center_r <= Y_center_w;	
	end
end



always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		X_MAX <= 0;
		X_MIN <= 13'd8192;
		Y_MAX <= 0;
		Y_MIN <= 13'd8192;
	end
	else
	begin
		if(	H_Cont>=X_START && H_Cont<X_START+H_SYNC_ACT &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT )
		begin
			if (Y1 >= 255)
			begin
				if (H_Cont > X_MAX)
					X_MAX <= H_Cont - X_START;
				if (H_Cont < X_MIN)
					X_MIN <= H_Cont - X_START;
				if (V_Cont > Y_MAX)
					Y_MAX <= V_Cont - Y_START;
				if (V_Cont < Y_MIN)
					Y_MIN <= V_Cont - Y_START;
			end
		end

		if (H_Cont > X_START+H_SYNC_ACT && V_Cont > Y_START+V_SYNC_ACT)
		begin
			X_MAX <= 0;
			X_MIN <= 13'd8192;
			Y_MAX <= 0;
			Y_MIN <= 13'd8192;
		end
		
		if (H_Cont==X_START+H_SYNC_ACT-1 && V_Cont==Y_START+V_SYNC_ACT-1)
		begin
			
			if (X_MAX == 0 && X_MIN == 13'd8192 && Y_MAX == 0 && Y_MIN == 13'd8192)
			begin
				is_light <= 0;
				ready_r <= 0;
			end
			else
			begin
				is_light <= 1;
				ready_r <= 1;
			end
		end
		else
			ready_r <= 0;
	end
end




//	Pixel LUT Address Generator
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	oRequest	<=	0;
	else
	begin
		if(	H_Cont>=X_START-2 && H_Cont<X_START+H_SYNC_ACT-2 &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT )
		oRequest	<=	1;
		else
		oRequest	<=	0;
	end
end

//	H_Sync Generator, Ref. 40 MHz Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		mVGA_H_SYNC	<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if( H_Cont < H_SYNC_TOTAL )
			H_Cont	<=	H_Cont+1;
		else
			H_Cont	<=	0;
		//	H_Sync Generator
		if( H_Cont < H_SYNC_CYC )
		mVGA_H_SYNC	<=	0;
		else
		begin
		mVGA_H_SYNC	<=	1;
		end
	end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		mVGA_V_SYNC	<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		if(H_Cont==0)
		begin
			//	V_Sync Counter
			if( V_Cont < V_SYNC_TOTAL )
				V_Cont	<=	V_Cont+1;
			else
				V_Cont	<=	0;
			//	V_Sync Generator
			if(	V_Cont < V_SYNC_CYC )
			mVGA_V_SYNC	<=	0;
			else
			mVGA_V_SYNC	<=	1;
		end
	end
end

endmodule