module tb_dsp_slice();
reg clk;
reg reset;
reg enable;
reg loadconst;
reg accumulate;
reg negate;
reg sub;
reg mode;
reg mux9_select;
reg [115:0] stream;
reg [63:0] chainin;
wire [63:0] resulta;
wire [36:0] resultb;
wire [63:0] chainout;

dsp_slice_combined dsp_slice(
 	clk,
 	reset,
 	enable,
 	loadconst,
	accumulate,
	negate,
	sub,
	mode,
	mux9_select,
	stream,
	chainin,
	resulta,
	resultb,
	chainout
);

initial begin
clk = 0;
repeat(60)
#10 clk = ~clk; #10 $finish;
end

initial begin
reset=1;
#5 reset=0;
end

initial begin
#30 loadconst <= 0;	accumulate<= 0; negate <= 0; sub <= 0; mode <= 0; mux9_select <= 0; stream <= 116'd0; chainin <= 64'd0;
end

endmodule