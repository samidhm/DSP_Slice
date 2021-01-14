`timescale 1ns / 1ps

module tb_dsp_slice();
reg clk;
reg reset;
reg enable;
reg loadconst;
reg accumulate;
reg negate;
reg sub;
reg [1:0] mode;
reg mux9_select;
reg internal_coeffa;
reg internal_coeffb;
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
	internal_coeffa,
	internal_coeffb,
	stream,
	chainin,
	resulta,
	resultb,
	chainout
);

initial begin
clk = 0;
repeat(100)
#10 clk = ~clk; #10 $finish;
end

initial begin
reset=1;
#5 reset=0;
end

initial begin
#10

#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 1; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 1; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 1; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 1; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 1; internal_coeffb <= 1; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b0; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 1; mux9_select <= 1'b0; accumulate<= 0; internal_coeffa <= 1; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b0; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 1; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 1; mux9_select <= 1'b0; accumulate<= 0; internal_coeffa <= 1; internal_coeffb <= 1; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 1; sub <= 1; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 1; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 1; internal_coeffa <= 1; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 1; loadconst <= 0; sub <= 1; mux9_select <= 1'b1; accumulate<= 1; internal_coeffa <= 1; internal_coeffb <= 1; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;
#20 mode <= 2'b00; negate <= 1; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 18'd4, 18'd1 ,18'd6 ,19'd5,18'd3,19'd2}; chainin <= 64'd0;


#20 mode <= 2'b01; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 30'd0 ,27'd1,26'd3,27'd2}; chainin <= 64'd0;
#20 mode <= 2'b01; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 1; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 30'd0 ,27'd1,26'd3,27'd2}; chainin <= 64'd0;
#20 mode <= 2'b01; negate <= 0; loadconst <= 1; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 30'd0 ,27'd1,26'd3,27'd2}; chainin <= 64'd0;
#20 mode <= 2'b01; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 1; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 30'd0 ,27'd1,26'd3,27'd2}; chainin <= 64'd0;
#20 mode <= 2'b01; negate <= 1; loadconst <= 1; sub <= 0; mux9_select <= 1'b1; accumulate<= 1; internal_coeffa <= 1; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 30'd0 ,27'd1,26'd3,27'd2}; chainin <= 64'd0;
#20 mode <= 2'b01; negate <= 1; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {3'd0, 3'd0, 30'd0 ,27'd1,26'd3,27'd2}; chainin <= 64'd0;


#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b0000, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b0001, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b0010, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 1; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b0011, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 1; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b0100, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b0101, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b0110, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b0111, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b1000, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b1001, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;
#20 mode <= 2'b10; negate <= 0; loadconst <= 0; sub <= 0; mux9_select <= 1'b1; accumulate<= 0; internal_coeffa <= 0; internal_coeffb <= 0; stream <= {16'd0, 4'b1010, 32'b00111111010110100101011100101111, 32'b00111110000111111111010001001101, 32'b11000000110100011100001011110010}; chainin <= 64'b00111111010110100101011100101111;

end

endmodule
