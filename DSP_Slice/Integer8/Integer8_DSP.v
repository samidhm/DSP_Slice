`define DWIDTH 8

module pre_adder( mode, dir, a, b , c);
input mode;
input dir;
input [`DWIDTH-1 : 0] a;
input [`DWIDTH-1 : 0] b;
input [`DWIDTH-1 : 0] c;
assign c = mode ? ( dir ? a-b: a+b) : a ;
endmodule

module multiplier(a,b,c);
input [`DWIDTH-1 : 0] a;
input [`DWIDTH-1 : 0] b;
input [2*`DWIDTH-1 : 0] c;
assign c=a*b;
endmodule

module multiplier_1(en, a,b,c);
input en;
input [`DWIDTH-1 : 0] a;
input [`DWIDTH-1 : 0] b;
input [2*`DWIDTH-1 : 0] c;
assign c= en ? a*b : a;
endmodule

module adder_subtractor(sub,a,b,c);
input sub;
input [2*`DWIDTH-1 : 0] a;
input [2*`DWIDTH-1 : 0] b;
input [2*`DWIDTH-1 : 0] c;
assign c = sub ? a-b: a+b;
endmodule

module inverse ( negate, a, b);
input negate;
input [2*`DWIDTH-1 : 0] a;
output [2*`DWIDTH-1 : 0] b;
assign b = negate ? ~a + 1: a;
endmodule


module chainout_add_acc(accumulate, negate, data_1, chainin, data_2, data_out);
input accumulate;
input negate;
input [4*`DWIDTH-1 : 0]data_1;
input [2*`DWIDTH-1 : 0]chainin;
input [2*`DWIDTH-1 : 0]data_2;
output [4*`DWIDTH-1 : 0]data_out;
assign data_out = accumulate ? data_1 + data_2 : ( negate ? data_2 + chainin : data_1 );
endmodule 

module dsp_slice(
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
input clk;
input enable;
input clr;
input loadconst;
input accumulate;
input negate;
input sub;
input [`DWIDTH-1:0] ay;
input [`DWIDTH-1:0] az;
input [`DWIDTH-1:0] ax;
input [`DWIDTH-1:0] by;
input [`DWIDTH-1:0] bz;
input [`DWIDTH-1:0] bx;
input [`DWIDTH-1:0]scanin;
input [2*`DWIDTH-1:0]chainin;
output [`DWIDTH-1:0]scanout;
output [2*`DWIDTH-1:0]chainout;
output [2*`DWIDTH-1:0] resulta;
output [2*`DWIDTH-1:0] resultb;

input [1:0]func;
input [7:0]muxsel;
input [4*`DWIDTH-1:0]constant;

//add COEFSELA, COEFSELB
//implement systolic registers for delay required in dsp operations (coefficients)


wire mux1_select;
wire mux2_select;
wire mux3_select;
wire mux4_select; 
wire mux5_select;
wire mux6_select;
wire mux7_select;
wire mux8_select;
wire mux9_select;


assign mux1_select=muxsel[0];
assign mux5_select=muxsel[4];


//Data Input Registers design (Figure 4)
wire [`DWIDTH-1:0] mux1_out;
wire [`DWIDTH-1:0] mux2_out;
wire [`DWIDTH-1:0] mux3_out;
wire [`DWIDTH-1:0] mux4_out;
wire [`DWIDTH-1:0] mux5_out;
wire [`DWIDTH-1:0] mux6_out;
wire [`DWIDTH-1:0] mux7_out;
wire [`DWIDTH-1:0] mux8_out;

wire mult2_en;
assign mult2_en= !func[0];
assign mux9_select= func[1];

reg [`DWIDTH-1:0] mux1_out_flopped;
reg [`DWIDTH-1:0] az_flopped;
reg [`DWIDTH-1:0] ax_flopped;
reg [`DWIDTH-1:0] mux2_out_flopped;
reg [`DWIDTH-1:0] mux5_out_flopped;
reg [`DWIDTH-1:0] bz_flopped;
reg [`DWIDTH-1:0] bx_flopped;
reg [`DWIDTH-1:0] mux6_out_flopped;
reg [7:0] muxsel_flopped;

assign mux1_out = mux1_select ? ay: scanin;

always @(posedge clk) begin
	if (clr) begin
		muxsel_flopped <= 8'd0;
    	end else begin
      		muxsel_flopped<=muxsel;
    	end
end

assign mux2_select=muxsel[1];
assign mux3_select=muxsel[2];
assign mux4_select=muxsel[3];
assign mux6_select=muxsel[5];
assign mux7_select=muxsel[6];
assign mux8_select=muxsel[7];

always @(posedge clk) begin
	if (clr) begin
		mux1_out_flopped <= 0;
    	end else begin
      		mux1_out_flopped<=mux1_out;
    	end
end
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
      		mux2_out_flopped<=mux2_out;
    	end
end

assign mux5_out = mux5_select ? by: mux2_out_flopped;

always @(posedge clk) begin
	if (clr) begin
		mux5_out_flopped <= 0;
    	end else begin
      		mux5_out_flopped<=mux5_out;
    	end
end
assign mux6_out = mux6_select ? mux5_out_flopped: mux5_out;

always @(posedge clk) begin
	if (clr) begin
		bz_flopped <= 0;
    	end else begin
      		bz_flopped<=bz;
    	end
end
assign mux7_out = mux7_select ? bz_flopped: bz;

always @(posedge clk) begin
	if (clr) begin
		bx_flopped <= 0;
    	end else begin
      		bx_flopped<=bx;
    	end
end
assign mux8_out = mux8_select ? bx_flopped: bx;

//Bottom Delay Register
always @(posedge clk) begin
	if (clr) begin
		mux6_out_flopped <= 0;
    	end else begin
      		mux6_out_flopped<=mux6_out;
    	end
end

reg mult2_en_flopped_1;
reg mux9_select_flopped_1;
reg loadconst_flopped_1;
reg accumulate_flopped_1;
reg negate_flopped_1;
reg sub_flopped_1;
reg [4*`DWIDTH-1:0] constant_flopped_1;

//completing the input register for the loadconst, accumulate, negate, sub
always @(posedge clk) begin
	if (clr) begin
		loadconst_flopped_1 <= 0;
		accumulate_flopped_1 <= 0;
		negate_flopped_1 <= 0;
		sub_flopped_1 <= 0;
		mult2_en_flopped_1 <= 0;
		mux9_select_flopped_1 <= 0;
		constant_flopped_1 <=0; 
		
    	end else begin
      		loadconst_flopped_1<=loadconst;
		accumulate_flopped_1 <= accumulate;
		negate_flopped_1 <= negate;
		sub_flopped_1 <= sub;
		mult2_en_flopped_1<= mult2_en;
		mux9_select_flopped_1 <= mux9_select;
		constant_flopped_1 <= constant;
    	end
end

reg mult2_en_flopped_2;
reg mux9_select_flopped_2;
reg loadconst_flopped_2 ;
reg accumulate_flopped_2;
reg negate_flopped_2;
reg sub_flopped_2;
reg [4*`DWIDTH-1:0] constant_flopped_2;
reg [`DWIDTH-1:0] mux2_out_flopped_2;
reg [`DWIDTH-1:0] mux3_out_flopped_2;
reg [`DWIDTH-1:0] mux4_out_flopped_2;
reg [`DWIDTH-1:0] mux6_out_flopped_2;
reg [`DWIDTH-1:0] mux7_out_flopped_2;
reg [`DWIDTH-1:0] mux8_out_flopped_2;
//first pipeline register
always @(posedge clk) begin
	if (clr) begin
		loadconst_flopped_2 <= 0;
		accumulate_flopped_2 <= 0;
		negate_flopped_2 <= 0;
		sub_flopped_2 <= 0;
		mux2_out_flopped_2<=0;
		mux3_out_flopped_2<=0;
		mux4_out_flopped_2<=0;
		mux6_out_flopped_2<=0;
		mux7_out_flopped_2<=0;
		mux8_out_flopped_2<=0; 
		mult2_en_flopped_2 <=0;
		mux9_select_flopped_2 <=0;
		constant_flopped_2<=0;
    	end else begin
      		loadconst_flopped_2<=loadconst_flopped_1;
		accumulate_flopped_2 <= accumulate_flopped_1;
		negate_flopped_2 <= negate_flopped_1;
		sub_flopped_2 <= sub_flopped_1;
		mult2_en_flopped_2 <=mult2_en_flopped_1;
		mux9_select_flopped_2 <=mux9_select_flopped_1;
		constant_flopped_2 <= constant_flopped_1;

		mux2_out_flopped_2<=mux2_out;
		mux3_out_flopped_2<=mux3_out;
		mux4_out_flopped_2<=mux4_out;
		mux6_out_flopped_2<=mux6_out;
		mux7_out_flopped_2<=mux7_out;
		mux8_out_flopped_2<=mux8_out;

    	end
end
reg mult2_en_flopped_3;
reg mux9_select_flopped_3;
reg loadconst_flopped_3 ;
reg accumulate_flopped_3;
reg negate_flopped_3;
reg sub_flopped_3;
reg [4*`DWIDTH-1:0] constant_flopped_3;

reg [`DWIDTH-1:0] mux2_out_flopped_3;
reg [`DWIDTH-1:0] mux3_out_flopped_3;
reg [`DWIDTH-1:0] mux4_out_flopped_3;
reg [`DWIDTH-1:0] mux6_out_flopped_3;
reg [`DWIDTH-1:0] mux7_out_flopped_3;
reg [`DWIDTH-1:0] mux8_out_flopped_3;
//second pipeline register
always @(posedge clk) begin
	if (clr) begin
		loadconst_flopped_3 <= 0;
		accumulate_flopped_3 <= 0;
		negate_flopped_3 <= 0;
		sub_flopped_3 <= 0;
		mux2_out_flopped_3<=0;
		mux3_out_flopped_3<=0;
		mux4_out_flopped_3<=0;
		mux6_out_flopped_3<=0;
		mux7_out_flopped_3<=0;
		mux8_out_flopped_3<=0;
		mult2_en_flopped_3 <=0;
		mux9_select_flopped_3 <=0;
		constant_flopped_3 <=0; 
    	end else begin
      		loadconst_flopped_3<=loadconst_flopped_2;
		accumulate_flopped_3 <= accumulate_flopped_2;
		negate_flopped_3 <= negate_flopped_2;
		sub_flopped_3 <= sub_flopped_2;
		constant_flopped_3 <= constant_flopped_2;
		mult2_en_flopped_3 <=mult2_en_flopped_2;
		mux9_select_flopped_3 <= mux9_select_flopped_2;
		mux2_out_flopped_3<=mux2_out_flopped_2;
		mux3_out_flopped_3<=mux3_out_flopped_2;
		mux4_out_flopped_3<=mux4_out_flopped_2;
		mux6_out_flopped_3<=mux6_out_flopped_2;
		mux7_out_flopped_3<=mux7_out_flopped_2;
		mux8_out_flopped_3<=mux8_out_flopped_2;	
    	end
end

wire [`DWIDTH-1:0]mult_ip_a_1;
wire [`DWIDTH-1:0]mult_ip_b_1;
wire [2*`DWIDTH-1:0]mult_out_1;

pre_adder M1(1'b0 , 1'b0, mux2_out_flopped_3, mux3_out_flopped_3 , mult_ip_a_1);
assign mult_ip_b_1 = mux4_out_flopped_3;
multiplier M2(mult_ip_a_1,mult_ip_b_1,mult_out_1);


wire [`DWIDTH-1:0]mult_ip_a_2;
wire [`DWIDTH-1:0]mult_ip_b_2;
wire [2*`DWIDTH-1:0]mult_out_2;

pre_adder M3( 1'b0 ,1'b0, mux6_out_flopped_3, mux7_out_flopped_3 , mult_ip_a_2);
assign mult_ip_b_2 = mux8_out_flopped_3;
multiplier_1 M4(mult2_en_flopped_3, mult_ip_a_2,mult_ip_b_2,mult_out_2);

wire [2*`DWIDTH-1:0]adder_sub_out;
adder_subtractor M5( sub_flopped_3, mult_out_1, mult_out_2, adder_sub_out);

wire [2*`DWIDTH-1:0]inverse_out;
inverse M6( negate_flopped_3, adder_sub_out, inverse_out);


reg [2*`DWIDTH-1:0]double_acc_flopped;
wire[4*`DWIDTH-1:0] mux10_out;
assign mux10_out = accumulate_flopped_3 ? double_acc_flopped: ( loadconst_flopped_3 ? constant_flopped_3 : 32'd0 );

wire [4*`DWIDTH-1:0]add_acc_out;
chainout_add_acc M7(accumulate_flopped_3, negate_flopped_3, mux10_out, chainin, inverse_out, add_acc_out);

wire[4*`DWIDTH-1:0] mux9_out;
assign mux9_out = mux9_select_flopped_3 ? add_acc_out: {mult_out_2,mult_out_1};

reg [4*`DWIDTH-1:0] output_register_bank;
//output register bank
always @(posedge clk) begin
	if (clr) begin
		output_register_bank <= 0;
		double_acc_flopped <= 0;
    	end else begin
      		output_register_bank<=mux9_out;
		double_acc_flopped <= mux9_out[15:0];
    	end
end

//always @(posedge clk) begin
//	if (clr) begin
//		double_acc_flopped <= 0;
//    	end else begin
//      		double_acc_flopped <=output_register_bank[15:0];
//    	end
//end

assign resulta = output_register_bank [15:0];
assign resultb = output_register_bank [31:16];
assign chainout=output_register_bank [15:0];

endmodule



