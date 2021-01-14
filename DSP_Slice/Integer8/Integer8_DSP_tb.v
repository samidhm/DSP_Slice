`define DWIDTH 8

module tb_dsp_slice();
reg clk;
reg enable;
reg clr;
reg loadconst;
reg accumulate;
reg negate;
reg sub;
reg [`DWIDTH-1:0] ay;
reg [`DWIDTH-1:0] az;
reg [`DWIDTH-1:0] ax;
reg [`DWIDTH-1:0] by;
reg [`DWIDTH-1:0] bz;
reg [`DWIDTH-1:0] bx;
reg [`DWIDTH-1:0]scanin;
reg [2*`DWIDTH-1:0]chainin;
wire [`DWIDTH-1:0]scanout;
wire [2*`DWIDTH-1:0]chainout;
wire [2*`DWIDTH-1:0] resulta;
wire [2*`DWIDTH-1:0] resultb;

reg [1:0]func;
reg [7:0]muxsel;
reg [4*`DWIDTH-1:0] constant;


dsp_slice slice_me(
	clk,
	enable,
	clr,
	loadconst,
	accumulate,
	negate,
	sub,
	ay,
	az,
	ax,
	by,
	bz,
	bx,
	scanin,
	chainin,
	scanout,
	chainout,
	resulta,
	resultb,
	func,
	muxsel,
	constant
);

initial begin
clk = 0;
repeat(40)
#10 clk = ~clk; #10 $finish;
end

initial begin
clr=1;
#5 clr=0;
end

initial begin
#30 func= 2'b00; loadconst = 0; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b11; loadconst = 0; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;

#20 func= 2'b00; loadconst = 0; accumulate = 0; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b10; loadconst = 0; accumulate = 0; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b11; loadconst = 0; accumulate = 0; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;

#20 func= 2'b00; loadconst = 0; accumulate = 1; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b10; loadconst = 1; accumulate = 1; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b11; loadconst = 0; accumulate = 1; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;

#20 func= 2'b00; loadconst = 1; accumulate = 1; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b10; loadconst = 0; accumulate = 1; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b11; loadconst = 1; accumulate = 1; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;

#20 func= 2'b00; loadconst = 1; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b10; loadconst = 1; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;
#20 func= 2'b11; loadconst = 1; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 8'h02; ax = 8'h03; by = 8'h04; bz = 8'h05; bx = 8'h06; muxsel = 8'hFF; constant= 32'h12345678;

end

endmodule
