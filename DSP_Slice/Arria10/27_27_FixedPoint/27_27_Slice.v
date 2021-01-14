
module pre_adder( mode, dir, a, b , c);
input mode;
input dir;
input [26 : 0] a;
input [25 : 0] b;
input [26 : 0] c;
assign c = mode ? ( dir ? a-b: a+b) : a ;
endmodule

module multiplier(a,b,c);
input [26 : 0] a;
input [26 : 0] b;
input [53 : 0] c;
assign c=a*b;
endmodule

module inverse ( negate, a, b);
input negate;
input [53 : 0] a;
output [53 : 0] b;
assign b = negate ? ~a + 1: a;
endmodule

module chainout_add_acc(accumulate, loadconst, negate, data_1, chainin, data_2, data_out);
input accumulate;
input loadconst;
input negate;
input [63 : 0]data_1;
input [63 : 0]chainin;
input [53 : 0]data_2;
output [63 : 0]data_out;
assign data_out = accumulate ? data_1 + data_2 : ( loadconst ? data_1 : ( negate ? data_2 + chainin : data_2 ));
endmodule 

module dsp_slice (

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
input clk;
input ena;
input clr;
input loadconst;
input accumulate;
input negate;
input [26:0]ay;
input [25:0]az;
input [26:0]ax;
input [2:0]coefsela;
input [26:0]scanin;
input [63:0] chainin;

output [26:0]scanout;
output [63:0] chainout;
output [63:0] resulta;

input [4:0]mux_sel;
input [63:0] constant;

wire [26:0]mux1_out;
wire [26:0]mux2_out;
wire [25:0]mux3_out;
wire [26:0]mux4_out;
wire [26:0]mux5_out;
wire [63:0]mux6_out;

wire mux1_select;
wire mux2_select;
wire mux3_select;
wire mux4_select;
wire mux5_select;

assign mux1_select=mux_sel[0];

reg [26:0] mux1_out_flopped;
reg [25:0] az_flopped;
reg [26:0] ax_flopped;
reg [26:0] mux2_out_flopped;

reg [4:0] mux_sel_flopped_1;

//input register bank
assign mux1_out = mux1_select ? ay: scanin;	

always @(posedge clk) begin
	if (clr) begin
		mux1_out_flopped <= 0;
		mux_sel_flopped_1 <= 0;
    	end else begin
      		mux1_out_flopped<=mux1_out;
		mux_sel_flopped_1 <= mux_sel;
    	end
end

assign mux2_select=mux_sel_flopped_1[1];
assign mux3_select=mux_sel_flopped_1[2];
assign mux4_select=mux_sel_flopped_1[3];

assign mux2_out = mux2_select ? mux1_out_flopped: mux1_out;


always @(posedge clk) begin
	if (clr) begin
		az_flopped <= 0;
    	end else begin
      		az_flopped<=az;
    	end
end
assign mux3_out = mux3_select ? az_flopped: az;

always @(posedge clk) begin
	if (clr) begin
		ax_flopped <= 0;
    	end else begin
      		ax_flopped<=ax;
    	end
end
assign mux4_out = mux4_select ? ax_flopped: ax;

//Top Delay Registers
always @(posedge clk) begin
	if (clr) begin
		mux2_out_flopped <= 0;
    	end else begin
      		mux2_out_flopped<= mux2_out;
    	end
end

reg loadconst_flopped_1;
reg accumulate_flopped_1;
reg negate_flopped_1;
reg [2:0] coefsela_flopped_1;
reg [63:0] constant_flopped_1;

assign scanout = mux2_out_flopped;
//completing the input register for remaining inputs
always @(posedge clk) begin
	if (clr) begin
		loadconst_flopped_1 <= 0;
		accumulate_flopped_1 <= 0;
		negate_flopped_1 <= 0;
		coefsela_flopped_1 <= 0;
		constant_flopped_1 <= 0;
    	end else begin
		loadconst_flopped_1 <= loadconst;
		accumulate_flopped_1 <= accumulate;
		negate_flopped_1 <= negate;
		coefsela_flopped_1 <= coefsela;   
		constant_flopped_1 <= constant;  		
    	end
end

reg loadconst_flopped_2;
reg accumulate_flopped_2;
reg negate_flopped_2;
reg [26:0] mux2_out_flopped_2;
reg [25:0] mux3_out_flopped_2;
reg [26:0] mux4_out_flopped_2;
reg [2:0] coefsela_flopped_2;
reg [4:0] mux_sel_flopped_2;
reg [63:0] constant_flopped_2;
//first pipeline register
always @(posedge clk) begin
	if (clr) begin
		loadconst_flopped_2 <= 0;
		accumulate_flopped_2 <= 0;
		negate_flopped_2 <= 0;
		mux2_out_flopped_2 <= 0;
		mux3_out_flopped_2 <= 0;
		mux4_out_flopped_2 <= 0;
		coefsela_flopped_2 <= 0;
		mux_sel_flopped_2 <= 0;
		constant_flopped_2 <= 0;
    	end else begin
		loadconst_flopped_2 <= loadconst_flopped_1;
		accumulate_flopped_2 <= accumulate_flopped_1;
		negate_flopped_2 <= negate_flopped_1;
		mux2_out_flopped_2 <= mux2_out;
		mux3_out_flopped_2 <= mux3_out;
		mux4_out_flopped_2 <= mux4_out;
		coefsela_flopped_2 <= coefsela_flopped_1;
		mux_sel_flopped_2 <= mux_sel_flopped_1; 
		constant_flopped_2 <= constant_flopped_1;    		
    	end
end


reg loadconst_flopped_3;
reg accumulate_flopped_3;
reg negate_flopped_3;
reg [26:0] mux2_out_flopped_3;
reg [25:0] mux3_out_flopped_3;
reg [26:0] mux4_out_flopped_3;
reg [2:0] coefsela_flopped_3;
reg [4:0] mux_sel_flopped_3;
reg [63:0] constant_flopped_3;

always @(posedge clk) begin
	if (clr) begin
		loadconst_flopped_3 <= 0;
		accumulate_flopped_3 <= 0;
		negate_flopped_3 <= 0;
		mux2_out_flopped_3 <= 0;
		mux3_out_flopped_3 <= 0;
		mux4_out_flopped_3 <= 0;
		coefsela_flopped_3 <= 0;
		mux_sel_flopped_3 <= 0;
		constant_flopped_3 <= 0;
    	end else begin
		loadconst_flopped_3 <= loadconst_flopped_2;
		accumulate_flopped_3 <= accumulate_flopped_2;
		negate_flopped_3 <= negate_flopped_2;
		mux2_out_flopped_3 <= mux2_out_flopped_2;
		mux3_out_flopped_3 <= mux3_out_flopped_2;
		mux4_out_flopped_3 <= mux4_out_flopped_2;
		coefsela_flopped_3 <= coefsela_flopped_2;
		mux_sel_flopped_3 <= mux_sel_flopped_2; 
		constant_flopped_3 <= constant_flopped_2;     		
    	end
end

wire [26:0] preadder_out;
pre_adder M1( 1'b0, 1'b0, mux2_out_flopped_3, mux3_out_flopped_3 , preadder_out);

//internal coeffbank
reg [26:0]coeffbank_a [0:7];
initial begin
coeffbank_a[0] <= 27'h21111;  coeffbank_a[1] <= 27'h22222; coeffbank_a[2] <= 27'h23333; coeffbank_a[3] <= 27'h24444;
coeffbank_a[4] <= 27'h25555;  coeffbank_a[5] <= 27'h26666; coeffbank_a[6] <= 27'h27777; coeffbank_a[7] <= 27'h28888; 
end

assign mux5_select=mux_sel_flopped_3[4];

assign mux5_out =  mux5_select ? coeffbank_a[coefsela_flopped_3]: mux4_out_flopped_3;

wire [53:0]mult_out;
multiplier M2 (preadder_out,mux5_out,mult_out);

wire [53:0] inverse_out;
inverse M3( negate_flopped_3, mult_out , inverse_out);

reg [63:0] double_acc_flopped;
wire [63:0] chainout_add_acc_out;


assign mux6_out = accumulate_flopped_3 ? double_acc_flopped : ( loadconst_flopped_3 ? constant_flopped_3 : 64'd0 );
chainout_add_acc M4 (accumulate_flopped_3, loadconst_flopped_3, negate_flopped_3, mux6_out, chainin, inverse_out, chainout_add_acc_out );

reg [63:0] output_reg;

always @(posedge clk) begin
	if (clr) begin
		output_reg <= 0;
    	end else begin
      		output_reg<= chainout_add_acc_out;
    	end
end

assign chainout = output_reg;
assign resulta = output_reg;

// an extra cycle with enable can be added here. I am taking the output directly for the accumulation, without delay.
always @(posedge clk) begin
	if (clr) begin
		double_acc_flopped <= 0;
    	end else begin
      		double_acc_flopped<= chainout_add_acc_out;
    	end
end

endmodule
