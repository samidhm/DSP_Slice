module dsp_slice_combined (
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
  coeffbank_addr,
  coeffbank_data,
  coeffbank_we,
  coeffbank_sel,
  constant,
	resulta,
	resultb,
	chainout
);
input clk;
input reset;
input enable;
input loadconst;
input accumulate;
input negate;
input sub;
input mode;
input mux9_select;
input internal_coeffa;
input internal_coeffb;
input [115:0] stream;
input [63:0] chainin;
input [2:0] coeffbank_addr;
input [17:0] coeffbank_data;
input coeffbank_we;
input coeffbank_sel;
input [63:0] constant;
output [63:0] resulta;
output [36:0] resultb;
output [63:0] chainout;

reg loadconst_flopped_1;
reg accumulate_flopped_1;
reg negate_flopped_1;
reg sub_flopped_1;
reg mode_flopped_1;
reg [115:0] stream_flopped_1;
reg mux9_select_flopped_1;

reg loadconst_flopped_2;
reg accumulate_flopped_2;
reg negate_flopped_2;
reg sub_flopped_2;
reg mode_flopped_2;
reg [115:0] stream_flopped_2;
reg mux9_select_flopped_2;

reg loadconst_flopped_3;
reg accumulate_flopped_3;
reg negate_flopped_3;
reg sub_flopped_3;
reg mode_flopped_3;
reg [115:0] stream_flopped_3;
reg mux9_select_flopped_3;
reg internal_coeffa_flopped_1;
reg internal_coeffb_flopped_1;
reg internal_coeffa_flopped_2;
reg internal_coeffb_flopped_2;
reg internal_coeffa_flopped_3;
reg internal_coeffb_flopped_3;

wire mux_select_1;
wire mux_select_2;

always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_1 <= 0;
 accumulate_flopped_1 <= 0;
 negate_flopped_1 <= 0;
 sub_flopped_1 <= 0;
 mode_flopped_1 <= 0;
 stream_flopped_1 <= 0;
 mux9_select_flopped_1 <= 0;
 internal_coeffa_flopped_1 <= 0;
 internal_coeffb_flopped_1 <= 0;
end
else begin
 loadconst_flopped_1 <= loadconst;
 accumulate_flopped_1 <= accumulate;
 negate_flopped_1 <= negate;
 sub_flopped_1 <= sub;
 mode_flopped_1 <= mode;
 stream_flopped_1 <= stream;
 mux9_select_flopped_1 <= mux9_select;
 internal_coeffa_flopped_1 <= internal_coeffa;
 internal_coeffb_flopped_1 <= internal_coeffb;
end
end

always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_2 <= 0 ;
 accumulate_flopped_2 <= 0 ;
 negate_flopped_2 <= 0 ;
 sub_flopped_2 <= 0 ;
 mode_flopped_2 <= 0 ;
 stream_flopped_2 <= 0 ;
 mux9_select_flopped_2 <= 0;
 internal_coeffa_flopped_2 <= 0;
 internal_coeffb_flopped_2 <= 0;
end
else begin
 loadconst_flopped_2 <= loadconst_flopped_1;
 accumulate_flopped_2 <= accumulate_flopped_1;
 negate_flopped_2 <= negate_flopped_1;
 sub_flopped_2 <= sub_flopped_1;
 mode_flopped_2 <= mode_flopped_1;
 stream_flopped_2 <= stream_flopped_1;
 mux9_select_flopped_2 <= mux9_select_flopped_1;
 internal_coeffa_flopped_2 <= internal_coeffa_flopped_1;
 internal_coeffb_flopped_2 <= internal_coeffb_flopped_1;
end
end

always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_3 <= 0 ;
 accumulate_flopped_3 <= 0 ;
 negate_flopped_3 <= 0 ;
 sub_flopped_3 <= 0 ;
 mode_flopped_3 <= 0 ;
 stream_flopped_3 <= 0 ;
 mux9_select_flopped_3 <= 0;
 internal_coeffa_flopped_3 <= 0;
 internal_coeffb_flopped_3 <= 0;
end
else begin
 loadconst_flopped_3 <= loadconst_flopped_2;
 accumulate_flopped_3 <= accumulate_flopped_2;
 negate_flopped_3 <= negate_flopped_2;
 sub_flopped_3 <= sub_flopped_2;
 mode_flopped_3 <= mode_flopped_2;
 stream_flopped_3 <= stream_flopped_2;
mux9_select_flopped_3 <= mux9_select_flopped_2;
  internal_coeffa_flopped_3 <= internal_coeffa_flopped_2;
 internal_coeffb_flopped_3 <= internal_coeffb_flopped_2;
end
end

//preadder
wire [37:0] preadder_out; //preadder_out = adder2, adder1 for 18/19 mode and its the entire output for 27 bit mode (0 extended to 38 bits)
pre_adder_combined preadder( .IN1 (stream_flopped_3 [36:0]), .IN2 (stream_flopped_3 [73:37]), .OUT1 (preadder_out), .mode (mode_flopped_3));

//internal coeffbank
reg [17:0] coeffbank_a [0:7];
reg [17:0] coeffbank_b [0:7];
always @(posedge clk)  
begin 
    if (coeffbank_we && coeffbank_sel)  coeffbank_a[coeffbank_addr] <= coeffbank_data;
    if (coeffbank_we && ~coeffbank_sel) coeffbank_b[coeffbank_addr] <= coeffbank_data;
end

//multiplier
reg [36:0] mult_ip_1;
reg [36:0] mult_ip_2;
wire [73:0] mult_out;

assign mux_select_1= internal_coeffa_flopped_3;
assign mux_select_2= internal_coeffb_flopped_3;

always @ (*) begin
if (mode_flopped_3 ==1'b0) begin
mult_ip_1 = { mux_select_1 ? coeffbank_a[stream_flopped_3[112:110]]: stream_flopped_3[91:74] , preadder_out[18:0]};
mult_ip_2 = { mux_select_2 ? coeffbank_b[stream_flopped_3[115:113]]: stream_flopped_3[109:92] , preadder_out[37:19]};
end

else if (mode_flopped_3 == 1'b1) begin
mult_ip_1 = preadder_out[27:0] ;
mult_ip_2 = mux_select_1 ? { coeffbank_b[stream_flopped_3[115:113]], coeffbank_a[stream_flopped_3[112:110]] } : stream_flopped_3[79:53];
end
end

Multiplier_combined multiplier( mult_ip_1, mult_ip_2 ,mult_out, mode_flopped_3); //mult_out= {mult2 out , mult1 out} for 18/19 bit mode, for 27 bit mode, it's just one mult output

reg [53:0] temp_signal;
always @ (*) begin
if (mode_flopped_3 ==1'b0) begin 
temp_signal = sub ?  mult_out[36:0] - mult_out[73:37] : mult_out[36:0] + mult_out[73:37] ;
end
else if (mode_flopped_3 ==1'b1) begin 
temp_signal =  mult_out [53:0];
end
end

wire [53:0]negate_out;
assign negate_out = negate ? ~temp_signal + 1: temp_signal;

wire [63:0]data_out;
wire [63:0] mux10_out;
reg [63:0]double_acc_flopped;

assign mux10_out = accumulate_flopped_3 ? double_acc_flopped: ( loadconst_flopped_3 ? constant : 64'd0 );
assign data_out = accumulate_flopped_3 ? negate_out + mux10_out : ( loadconst_flopped_3 ? mux10_out : ( negate_flopped_3 ? negate_out + chainin : negate_out ));

wire [99:0] mux9_out;
	assign mux9_out = mux9_select_flopped_3 ? {36'b0, data_out} : { mult_out[73:36] , 28'b0, mult_out[35:0]};

reg [99:0] output_register_bank;
//output register bank
always @(posedge clk) begin
	if (reset) begin
		output_register_bank <= 0;
		double_acc_flopped <= 0;
    	end else begin
		output_register_bank <= mux9_out[99:0];
		double_acc_flopped <= mux9_out[63:0];
    	end
end

assign resulta = output_register_bank [63:0];
assign resultb = output_register_bank [99:64];
assign chainout= output_register_bank [63:0];

endmodule

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


