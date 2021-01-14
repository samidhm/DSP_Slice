module tb_dsp_fixed2 ();

reg clk;
reg ena;
reg clr;
reg loadconst;
reg accumulate;
reg negate;
reg [26:0]ay;
reg [25:0]az;
reg [26:0]ax;
reg [2:0]coefsela;
reg [26:0]scanin;
reg [63:0] chainin;

wire [26:0]scanout;
wire [63:0] chainout;
wire [63:0] resulta;

reg [4:0]mux_sel;
reg [63:0] constant;

dsp_slice slice_me(

clk,
ena,
clr,
loadconst,
accumulate,
negate,
ay,
az,
ax,
coefsela,
scanin,
chainin,

scanout,
chainout,
resulta,

mux_sel,
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
#30  mux_sel= 5'b01111; negate = 0 ; loadconst = 0; accumulate = 0; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b11111; negate = 0 ; loadconst = 0; accumulate = 0; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b01111; negate = 0 ; loadconst = 1; accumulate = 0; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b11111; negate = 0 ; loadconst = 1; accumulate = 0; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b01111; negate = 0 ; loadconst = 0; accumulate = 1; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b11111; negate = 0 ; loadconst = 1; accumulate = 1; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b01111; negate = 0 ; loadconst = 0; accumulate = 0; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b01111; negate = 1 ; loadconst = 1; accumulate = 1; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b01111; negate = 0 ; loadconst = 0; accumulate = 0; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b11111; negate = 1 ; loadconst = 0; accumulate = 1; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b01111; negate = 1 ; loadconst = 0; accumulate = 0; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;
#20  mux_sel= 5'b11111; negate = 1 ; loadconst = 0; accumulate = 0; ax= 27'h1; ay= 27'h2; az= 26'h3; coefsela= 3'h0; scanin=27'h0;  chainin= 64'h1; constant = 64'h2;

end

endmodule
