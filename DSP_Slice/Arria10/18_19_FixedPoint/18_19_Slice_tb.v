module tb_dsp_slice();
reg clk;
reg enable;
reg clr;
reg loadconst;
reg accumulate;
reg negate;
reg sub;
reg [18:0] ay;
reg [17:0] az;
reg [17:0] ax;
reg [18:0] by;
reg [17:0] bz;
reg [17:0] bx;
reg [18:0]scanin;
reg [63:0]chainin;
wire [18:0]scanout;
wire [63:0]chainout;
wire [36:0] resulta;
wire [36:0] resultb;

reg [1:0]func;
reg [7:0]muxsel;
reg coeffmux;
reg [73:0] constant;
reg [2:0] coefsela;
reg [2:0] coefselb;

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
	coeffmux,
	constant,
	coefsela,
	coefselb
);

initial begin
clk = 0;
repeat(60)
#10 clk = ~clk; #10 $finish;
end

initial begin
clr=1;
#5 clr=0;
end

initial begin
#30 coeffmux <= 0; coefsela <= 3'b001; coefselb <= 3'b011; func= 2'b00; loadconst = 0; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 1; coefsela <= 3'b111; coefselb <= 3'b010; func= 2'b11; loadconst = 0; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;

#20 coeffmux <= 0; coefsela <= 3'b001; coefselb <= 3'b011; func= 2'b00; loadconst = 0; accumulate = 0; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 1; coefsela <= 3'b111; coefselb <= 3'b010; func= 2'b10; loadconst = 0; accumulate = 0; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 0; coefsela <= 3'b001; coefselb <= 3'b011; func= 2'b11; loadconst = 0; accumulate = 0; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;

#20 coeffmux <= 1; coefsela <= 3'b111; coefselb <= 3'b010; func= 2'b00; loadconst = 0; accumulate = 1; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 0; coefsela <= 3'b001; coefselb <= 3'b011; func= 2'b10; loadconst = 1; accumulate = 1; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 1; coefsela <= 3'b111; coefselb <= 3'b010; func= 2'b11; loadconst = 0; accumulate = 1; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;


#20 coeffmux <= 0; coefsela <= 3'b001; coefselb <= 3'b011; func= 2'b00; loadconst = 1; accumulate = 1; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 1; coefsela <= 3'b111; coefselb <= 3'b010; func= 2'b10; loadconst = 0; accumulate = 1; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 0; coefsela <= 3'b001; coefselb <= 3'b011; func= 2'b11; loadconst = 1; accumulate = 1; negate = 1 ; sub = 0 ;  scanin=0; chainin =0; ay= 8'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;

#20 coeffmux <= 1; coefsela <= 3'b111; coefselb <= 3'b010; func= 2'b00; loadconst = 1; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 0; coefsela <= 3'b001; coefselb <= 3'b011; func= 2'b10; loadconst = 1; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;
#20 coeffmux <= 1; coefsela <= 3'b111; coefselb <= 3'b010; func= 2'b11; loadconst = 1; accumulate = 0; negate = 0 ; sub = 0 ;  scanin=0; chainin =0; ay= 19'h01 ; az= 18'h02; ax = 18'h03; by = 19'h04; bz = 18'h05; bx = 18'h06; muxsel = 8'hFF; constant= 74'h111234567812345678;

end

endmodule
