//Date		: 2020/05/26
//Author	: zhishangtanxin 
//Function	: 
//read more, please refer to wechat public account "zhishangtanxin"
`define csa_len 320
module booth_top#(
	parameter a_len = 256,				//256 * 64
	parameter b_len = 64,
	parameter p_len = a_len+b_len,
	parameter prod_num = b_len/2,
	parameter prod_wid = 8
	)(
	input [a_len-1:0] A,
	input [b_len-1:0] B,
	output [p_len-1:0] P
);
wire [prod_num-1:0] neg;
wire [prod_num-1:0] zero;
wire [prod_num-1:0] one;
wire [prod_num-1:0] two;

genvar i;
generate 
	for(i=0; i<prod_num; i=i+1)
	begin
		if(i==0)
			booth_enc u_booth_enc(
				.code ({B[1:0],1'b0}),
				.neg  (neg[i]    ),
				.zero (zero[i]   ),
				.one  (one[i]	 ),
				.two  (two[i]	 )
			);
		else
			booth_enc u_booth_enc(
				.code (B[i*2+1:i*2-1]),
				.neg  (neg[i]    ),
				.zero (zero[i]   ),
				.one  (one[i]	 ),
				.two  (two[i]	 )
			);
	end
endgenerate

wire [p_len-1:0]prod[prod_num-1:0];
generate 
	for(i=0; i<prod_num; i=i+1)
	begin
		gen_prod  #(
			.a_len		(a_len),
			.prod_len	(p_len)
		) u_gen_prod (
			.A    ( A       ),
			.neg  ( neg[i]  ),
			.zero ( zero[i] ),
			.one  ( one[i]  ),
			.two  ( two[i]  ),
			.prod ( prod[i] )
		);
	end
endgenerate
//wallace_tree		change to 256 * 64
wire [`csa_len-1:0] s_lev01;		//level 0	10..2
wire [`csa_len-1:0] c_lev01;
wire [`csa_len-1:0] s_lev02;
wire [`csa_len-1:0] c_lev02;
wire [`csa_len-1:0] s_lev03;
wire [`csa_len-1:0] c_lev03;
wire [`csa_len-1:0] s_lev04;
wire [`csa_len-1:0] c_lev04;
wire [`csa_len-1:0] s_lev05;
wire [`csa_len-1:0] c_lev05;
wire [`csa_len-1:0] s_lev06;
wire [`csa_len-1:0] c_lev06;
wire [`csa_len-1:0] s_lev07;
wire [`csa_len-1:0] c_lev07;
wire [`csa_len-1:0] s_lev08;
wire [`csa_len-1:0] c_lev08;
wire [`csa_len-1:0] s_lev09;
wire [`csa_len-1:0] c_lev09;
wire [`csa_len-1:0] s_lev0a;
wire [`csa_len-1:0] c_lev0a;

wire [`csa_len-1:0] s_lev11;		//level 1	7..1
wire [`csa_len-1:0] c_lev11;
wire [`csa_len-1:0] s_lev12;
wire [`csa_len-1:0] c_lev12;
wire [`csa_len-1:0] s_lev13;
wire [`csa_len-1:0] c_lev13;
wire [`csa_len-1:0] s_lev14;
wire [`csa_len-1:0] c_lev14;
wire [`csa_len-1:0] s_lev15;
wire [`csa_len-1:0] c_lev15;
wire [`csa_len-1:0] s_lev16;
wire [`csa_len-1:0] c_lev16;
wire [`csa_len-1:0] s_lev17;
wire [`csa_len-1:0] c_lev17;

wire [`csa_len-1:0] s_lev21;		//level 2	5..0
wire [`csa_len-1:0] c_lev21;
wire [`csa_len-1:0] s_lev22;
wire [`csa_len-1:0] c_lev22;
wire [`csa_len-1:0] s_lev23;
wire [`csa_len-1:0] c_lev23;
wire [`csa_len-1:0] s_lev24;
wire [`csa_len-1:0] c_lev24;
wire [`csa_len-1:0] s_lev25;
wire [`csa_len-1:0] c_lev25;

wire [`csa_len-1:0] s_lev31;		//level 3	3..1
wire [`csa_len-1:0] c_lev31;
wire [`csa_len-1:0] s_lev32;
wire [`csa_len-1:0] c_lev32;
wire [`csa_len-1:0] s_lev33;
wire [`csa_len-1:0] c_lev33;

wire [`csa_len-1:0] s_lev41;		//level 4	2..1
wire [`csa_len-1:0] c_lev41;
wire [`csa_len-1:0] s_lev42;
wire [`csa_len-1:0] c_lev42;

wire [`csa_len-1:0] s_lev51;		//level 5	1..2
wire [`csa_len-1:0] c_lev51;

wire [`csa_len-1:0] s_lev61;		//level 6	1..1
wire [`csa_len-1:0] c_lev61;

wire [`csa_len-1:0] s_lev71;		//level 7	1..0
wire [`csa_len-1:0] c_lev71;

wire [`csa_len-1:0] ans;		//level 8



//level 0
csa #(`csa_len) csa_lev01(
	.op1( prod[0]      ),
	.op2( prod[1] << 2 ),
	.op3( prod[2] << 4 ),
	.S	( s_lev01      ),
	.C	( c_lev01      )
);

csa #(`csa_len) csa_lev02(
	.op1( prod[3] << 6 ),
	.op2( prod[4] << 8 ),
	.op3( prod[5] << 10),
	.S	( s_lev02      ),
	.C	( c_lev02      )
);

csa #(`csa_len) csa_lev03(
	.op1( prod[6] << 12),
	.op2( prod[7] << 14),
	.op3( prod[8] << 16),
	.S	( s_lev03      ),
	.C	( c_lev03      )
);

csa #(`csa_len) csa_lev04(
	.op1( prod[9]  << 18 ),
	.op2( prod[10] << 20 ),
	.op3( prod[11] << 22 ),
	.S	( s_lev04      ),
	.C	( c_lev04      )
);

csa #(`csa_len) csa_lev05(
	.op1( prod[12] << 24 ),
	.op2( prod[13] << 26 ),
	.op3( prod[14] << 28 ),
	.S	( s_lev05      ),
	.C	( c_lev05      )
);

csa #(`csa_len) csa_lev06(
	.op1( prod[15] << 30 ),
	.op2( prod[16] << 32 ),
	.op3( prod[17] << 34 ),
	.S	( s_lev06      ),
	.C	( c_lev06      )
);

csa #(`csa_len) csa_lev07(
	.op1( prod[18] << 36 ),
	.op2( prod[19] << 38 ),
	.op3( prod[20] << 40 ),
	.S	( s_lev07      ),
	.C	( c_lev07      )
);

csa #(`csa_len) csa_lev08(
	.op1( prod[21] << 42 ),
	.op2( prod[22] << 44 ),
	.op3( prod[23] << 46 ),
	.S	( s_lev08      ),
	.C	( c_lev08      )
);

csa #(`csa_len) csa_lev09(
	.op1( prod[24] << 48 ),
	.op2( prod[25] << 50 ),
	.op3( prod[26] << 52 ),
	.S	( s_lev09      ),
	.C	( c_lev09      )
);

csa #(`csa_len) csa_lev0a(
	.op1( prod[27] << 54 ),
	.op2( prod[28] << 56 ),
	.op3( prod[29] << 58 ),			//prod[30]  prod[31]
	.S	( s_lev0a      ),
	.C	( c_lev0a      )
);

//level 1
csa #(`csa_len) csa_lev11(
	.op1( s_lev01      ),
	.op2( c_lev01 << 1 ),
	.op3( s_lev02      ),
	.S	( s_lev11      ),
	.C	( c_lev11      )
);

csa #(`csa_len) csa_lev12(
	.op1( c_lev02 << 1 ),
	.op2( s_lev03 	   ),
	.op3( c_lev03 << 1 ),		
	.S	( s_lev12      ),
	.C	( c_lev12      )
);

csa #(`csa_len) csa_lev13(
	.op1( s_lev04		),
	.op2( c_lev04 << 1	),
	.op3( s_lev05		),
	.S	( s_lev13		),
	.C	( c_lev13		)
);

csa #(`csa_len) csa_lev14(
	.op1( c_lev05 << 1 ),
	.op2( s_lev06 	   ),
	.op3( c_lev06 << 1 ),		
	.S	( s_lev14      ),
	.C	( c_lev14      )
);

csa #(`csa_len) csa_lev15(
	.op1( s_lev07      ),
	.op2( c_lev07 << 1 ),
	.op3( s_lev08      ),
	.S	( s_lev15      ),
	.C	( c_lev15      )
);

csa #(`csa_len) csa_lev16(
	.op1( c_lev08 << 1 ),
	.op2( s_lev09 	   ),
	.op3( c_lev09 << 1 ),		
	.S	( s_lev16      ),
	.C	( c_lev16      )
);

csa #(`csa_len) csa_lev17(
	.op1( s_lev0a       ),
	.op2( c_lev0a << 1  ),
	.op3( prod[30] << 60),		//prod[31]
	.S	( s_lev17       ),
	.C	( c_lev17       )
);

//level 2
csa #(`csa_len) csa_lev21(
	.op1( s_lev11      ),
	.op2( c_lev11 << 1 ),
	.op3( s_lev12      ),
	.S	( s_lev21      ),
	.C	( c_lev21      )
);

csa #(`csa_len) csa_lev22(
	.op1( c_lev12 << 1 ),
	.op2( s_lev13 	   ),
	.op3( c_lev13 << 1 ),		
	.S	( s_lev22      ),
	.C	( c_lev22      )
);

csa #(`csa_len) csa_lev23(
	.op1( s_lev14		),
	.op2( c_lev14 << 1	),
	.op3( s_lev15		),
	.S	( s_lev23		),
	.C	( c_lev23		)
);

csa #(`csa_len) csa_lev24(
	.op1( c_lev15 << 1 ),
	.op2( s_lev16 	   ),
	.op3( c_lev16 << 1 ),		
	.S	( s_lev24      ),
	.C	( c_lev24      )
);

csa #(`csa_len) csa_lev25(
	.op1( s_lev17      ),
	.op2( c_lev17 << 1 ),
	.op3( prod[31] <<62),
	.S	( s_lev25      ),
	.C	( c_lev25      )
);

//level 3
csa #(`csa_len) csa_lev31(
	.op1( s_lev21      ),
	.op2( c_lev21 << 1 ),
	.op3( s_lev22      ),
	.S	( s_lev31      ),
	.C	( c_lev31      )
);

csa #(`csa_len) csa_lev32(
	.op1( c_lev22 << 1 ),
	.op2( s_lev23 	   ),
	.op3( c_lev23 << 1 ),		
	.S	( s_lev32      ),
	.C	( c_lev32      )
);

csa #(`csa_len) csa_lev33(
	.op1( s_lev24		),
	.op2( c_lev24 << 1	),
	.op3( s_lev25		),		//c_lev25
	.S	( s_lev33		),
	.C	( c_lev33		)
);

//level 4
csa #(`csa_len) csa_lev41(
	.op1( s_lev31      ),
	.op2( c_lev31 << 1 ),
	.op3( s_lev32      ),
	.S	( s_lev41      ),
	.C	( c_lev41      )
);

csa #(`csa_len) csa_lev42(
	.op1( c_lev32 << 1 ),
	.op2( s_lev33 	   ),
	.op3( c_lev33 << 1 ),		//c_lev25
	.S	( s_lev42      ),
	.C	( c_lev42      )
);

//level 5
csa #(`csa_len) csa_lev51(
	.op1( s_lev41      ),
	.op2( c_lev41 << 1 ),
	.op3( s_lev42      ),		//c_lev42	c_lev25
	.S	( s_lev51      ),
	.C	( c_lev51      )
);

//level 6
csa #(`csa_len) csa_lev61(
	.op1( s_lev51      ),
	.op2( c_lev51 << 1 ),
	.op3( s_lev42      ),		//c_lev25
	.S	( s_lev61      ),
	.C	( c_lev61      )
);

//level 7
csa #(`csa_len) csa_lev71(
	.op1( s_lev61      ),
	.op2( c_lev61 << 1 ),
	.op3( c_lev25 << 1 ),
	.S	( s_lev71      ),
	.C	( c_lev71      )
);

//adder
rca #(`csa_len) u_rca (
    .op1 ( s_lev71  ), 
    .op2 ( c_lev71 << 1  ),
    .cin ( 1'b0   ),
    .sum ( P      ),
    .cout(        )
);
endmodule
