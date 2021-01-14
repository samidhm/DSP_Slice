`timescale 1ns / 1ps
//Includes the 2 fixed point modes and 1 FP32 mode
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
input [1:0]mode;
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
reg [1:0]mode_flopped_1;
reg [115:0] stream_flopped_1;
reg mux9_select_flopped_1;
reg internal_coeffa_flopped_1;
reg internal_coeffb_flopped_1;

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

reg [115:0 ] stream_flopped_2;
always @ (posedge clk) begin
if (reset == 1'b1) begin
 stream_flopped_2 <= 0;
end
else begin
 stream_flopped_2 <= stream_flopped_1;
end
end
// FLOATING POINT BEGINS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire [31:0] chainout_1;
wire [31:0] resulta_flopped;

wire [3:0]funct_flopped;
wire [31:0] ax_flopped;
wire [31:0] ay_flopped;
wire [31:0] az_flopped;

assign funct_flopped = stream_flopped_2[99:96];
assign ax_flopped = stream_flopped_2[31:0];
assign ay_flopped = stream_flopped_2[63:32];
assign az_flopped = stream_flopped_2[95:64];

wire mux1_select;
wire [1:0] mux2_select;
wire mux3_select;
wire mux5_select;

assign mux1_select = (funct_flopped[1] & funct_flopped[0] ) | (funct_flopped[3] & ~funct_flopped[1]) | (funct_flopped[2] & ~funct_flopped[0] );
assign mux2_select[1] = ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[1]) | ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[0]) | ( funct_flopped[3] & funct_flopped[1] & funct_flopped[0]);
assign mux2_select[0] = funct_flopped[2] | ( funct_flopped[3] & ~funct_flopped[1])  | (funct_flopped[1] & funct_flopped [0]);
assign mux3_select = (funct_flopped[3] & ~funct_flopped[1]) + (funct_flopped[2] & funct_flopped[1] & funct_flopped[0]);
assign mux5_select = funct_flopped[3] | (~funct_flopped[2] & funct_flopped[0]) | (funct_flopped[2] & ~funct_flopped[0])  | (funct_flopped[2] & ~funct_flopped[1]) ;

//final multiplier
wire [73:0] mult_out;

wire [31:0] mult_ip_a;
wire [31:0] mult_ip_b;
wire [31:0] mult_out_fp;
wire [4:0] mult_flags;
reg [31:0] mult_out_fp_flopped_1;

assign mult_ip_a = ay_flopped;
assign mult_ip_b = az_flopped;

	wire [31:0]a;
	wire [31:0]b;
	
	assign a= mult_ip_a;
	assign b= mult_ip_b;
	
	wire Sa ;										// A's sign
	wire Sb ;										// B's sign
	wire [7:0] Ea ;								// A's exponent
	wire [7:0] Eb ;								// B's exponent
	wire [47:0] Mp ;							// Mantissa product
	wire [4:0] InputExc ;						// Input numbers are exceptions

	wire Sp ;								// Product sign
	wire [8:0] NormE ;													// Normalized exponent
	wire [22:0] NormM ;												// Normalized mantissa
	wire GRS ;
	
	wire [110:0]pipe_1;
	wire [38:0]pipe_2;
	
	//FPMult_a M1 (a, b, Sa, Sb, Ea, Eb, Mp, InputExc) ;
	
	// Internal signals							// If signal is high...
	wire ANaN ;										// A is a signalling NaN
	wire BNaN ;										// B is a signalling NaN
	wire AInf ;										// A is infinity
	wire BInf ;										// B is infinity
	wire [47:0] PCOUT1 ;

	assign ANaN = &(a[30:23]) & |(a[30:23]) ;			// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(b[30:23]) & |(b[22:0]);			// All one exponent and not all zero mantissa - NaN
	assign AInf = &(a[30:23]) & ~|(a[30:23]) ;		// All one exponent and all zero mantissa - Infinity
	assign BInf = &(b[30:23]) & ~|(b[30:23]) ;		// All one exponent and all zero mantissa - Infinity
	
	// Check for any exceptions and put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;
	//assign InputExc = {(ANaN | ANaN | BNaN |BNaN), ANaN, ANaN, BNaN,BNaN} ;
	
	// Take input numbers apart
	assign Sa = a[31] ;							// A's sign
	assign Sb = b[31] ;							// B's sign
	assign Ea = (a[30:23]);						// Store A's exponent in Ea, unless A is an exception
	assign Eb = (b[30:23]);						// Store B's exponent in Eb, unless B is an exception	
	
	
	assign Mp = mult_out[47:0];
	//assign Mp = ({7'b0000001, a[22:0]}*{12'b000000000001, b[22:17]}) ;
	FPMult_b M2 (pipe_1[110:88],pipe_1[87:71],pipe_1[52:5],pipe_1[68:61],pipe_1[60:53],pipe_1[70],pipe_1[69],Sp,NormE,NormM,GRS);
	FPMult_c M3 (pipe_2[22:0],pipe_2[31:23],pipe_2[32],pipe_2[33],pipe_2[38:34],mult_out_fp, );
	
	assign pipe_1 = {a[22:0], b[16:0], Sa, Sb, Ea[7:0], Eb[7:0], Mp[47:0], InputExc[4:0]} ;
	assign pipe_2 = {pipe_1[4:0], GRS ,Sp, NormE, NormM};

always @(posedge clk) begin
	if (reset) begin
    mult_out_fp_flopped_1 <= 0;
  end else begin
    mult_out_fp_flopped_1 <= mult_out_fp;
  end
end

wire [31:0] adder_ip_a;
wire [31:0] adder_ip_b;
wire [31:0] mux1_out;
reg [31:0] mux1_out_flopped_1;
reg [31:0] mux1_out_flopped_2;
reg [31:0] mux1_out_flopped_3;
wire [31:0] mux2_out;
wire [31:0] mux4_out;
wire [31:0] adder_out;
//wire [4:0] adder_flags;
wire operation;


assign operation = ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[0]) | ( ~funct_flopped[3] & ~funct_flopped[1] & ~funct_flopped[0])  | ( funct_flopped[3] & ~funct_flopped[1] & funct_flopped[0]);

assign mux1_out = mux1_select ? chainin: ax_flopped;

//Three flop stages at the input of the adder 
always @(posedge clk) begin
	if (reset) begin
    mux1_out_flopped_1 <= 0;
    mux1_out_flopped_2 <= 0;
    mux1_out_flopped_3 <= 0;
  end else begin
    mux1_out_flopped_1 <= mux1_out;
    mux1_out_flopped_2 <= mux1_out_flopped_1;
    mux1_out_flopped_3 <= mux1_out_flopped_2;
  end
end

assign mux4_out = accumulate ? resulta_flopped : mux1_out_flopped_3;
assign mux2_out= mux2_select[1] ? ( mux2_select[0] ? ax_flopped : ay_flopped) : ( mux2_select[0] ? mult_out_fp_flopped_1 : 32'd0);

assign adder_ip_a = mux4_out;
assign adder_ip_b = mux2_out;

FPAddSub_single Adder ( clk, reset, adder_ip_a , adder_ip_b , operation, adder_out,  );

wire [31:0] mux3_out;
assign mux3_out = mux3_select ? ax_flopped : resulta_flopped;
assign chainout_1 = mux3_out;

wire [31:0] resulta_fp;
wire [31:0] mux5_out;

assign mux5_out = mux5_select ? adder_out : mult_out_fp_flopped_1;
assign resulta_fp = mux5_out;

reg [31:0] resulta_flopped_1;

always @(posedge clk) begin
	if (reset) begin
		resulta_flopped_1 <= 0;
    	end else begin
		resulta_flopped_1 <= resulta_fp;
    	end
end

assign resulta_flopped = resulta_flopped_1;
// FLOATING POINT ENDS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//preadder
wire [37:0] preadder_out; //preadder_out = adder2, adder1 for 18/19 mode and its the entire output for 27 bit mode (0 extended to 38 bits)
pre_adder_combined preadder( .IN1 (stream_flopped_1 [36:0]), .IN2 (stream_flopped_1 [73:37]), .OUT1 (preadder_out), .mode (mode_flopped_1[0]));

//internal coeffbank
reg [17:0]coeffbank_a [0:7];
reg [17:0] coeffbank_b [0:7];
always @(posedge clk)  
begin 
    if (coeffbank_we && coeffbank_sel)  coeffbank_a[coeffbank_addr] <= coeffbank_data;
    if (coeffbank_we && ~coeffbank_sel) coeffbank_b[coeffbank_addr] <= coeffbank_data;
end

//multiplier
reg [36:0] mult_ip_1;
reg [36:0] mult_ip_2;

//define these as inputs later
assign mux_select_1= internal_coeffa_flopped_1;
assign mux_select_2= internal_coeffb_flopped_1;

reg mode_bit;

always @ (*) begin
if (mode_flopped_1[1] == 1'b1) begin
mult_ip_1 = {5'b00001, a[22:0]};
mult_ip_2 = {12'b000000000001, b[22:17]};
mode_bit =1'b1;
end

else if (mode_flopped_1[0] ==1'b0) begin
mult_ip_1 =  mux_select_1 ? { coeffbank_a[stream_flopped_1[112:110]], preadder_out[18:0]}: {stream_flopped_1[91:74] , preadder_out[18:0]};
mult_ip_2 =  mux_select_2 ? { coeffbank_b[stream_flopped_1[115:113]], preadder_out[37:19]}: {stream_flopped_1[109:92] , preadder_out[37:19]};
 mode_bit =1'b0;
end

else if (mode_flopped_1[0] == 1'b1) begin
mult_ip_1 = {9'b0, preadder_out[27:0] } ;
mult_ip_2 = mux_select_1 ? { 10'b0, coeffbank_b[stream_flopped_1[115:113]][8:0], coeffbank_a[stream_flopped_1[112:110]] } : {10'b0, stream_flopped_1[79:53]};
 mode_bit =1'b1;
end
end

reg [36:0] mult_ip_1_flopped;
reg [36:0] mult_ip_2_flopped;
reg mode_bit_flopped;

always @(posedge clk) begin
	if (reset) begin
		mult_ip_1_flopped <= 0;
		mult_ip_2_flopped <= 0;
		mode_bit_flopped <= 0;
    	end else begin
		mult_ip_1_flopped <= mult_ip_1;
		mult_ip_2_flopped <= mult_ip_2;
		mode_bit_flopped <= mode_bit;
    	end
end


Multiplier_combined multiplier( mult_ip_1_flopped, mult_ip_2_flopped ,mult_out, mode_bit_flopped); //mult_out= {mult2 out , mult1 out} for 18/19 bit mode, for 27 bit mode, it's just one mult output

reg loadconst_flopped_2;
reg accumulate_flopped_2;
reg negate_flopped_2;
reg sub_flopped_2;
reg [1:0]mode_flopped_2;
reg mux9_select_flopped_2;

reg loadconst_flopped_3;
reg accumulate_flopped_3;
reg negate_flopped_3;
reg sub_flopped_3;
reg [1:0]mode_flopped_3;
reg mux9_select_flopped_3;

always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_2 <= 0 ;
 accumulate_flopped_2 <= 0 ;
 negate_flopped_2 <= 0 ;
 sub_flopped_2 <= 0 ;
 mode_flopped_2 <= 0 ;
 mux9_select_flopped_2 <= 0;
end
else begin
 loadconst_flopped_2 <= loadconst_flopped_1;
 accumulate_flopped_2 <= accumulate_flopped_1;
 negate_flopped_2 <= negate_flopped_1;
 sub_flopped_2 <= sub_flopped_1;
 mode_flopped_2 <= mode_flopped_1;
 mux9_select_flopped_2 <= mux9_select_flopped_1;
end
end

always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_3 <= 0 ;
 accumulate_flopped_3 <= 0 ;
 negate_flopped_3 <= 0 ;
 sub_flopped_3 <= 0 ;
 mode_flopped_3 <= 0 ;
 mux9_select_flopped_3 <= 0;
end
else begin
 loadconst_flopped_3 <= loadconst_flopped_2;
 accumulate_flopped_3 <= accumulate_flopped_2;
 negate_flopped_3 <= negate_flopped_2;
 sub_flopped_3 <= sub_flopped_2;
 mode_flopped_3 <= mode_flopped_2;
  mux9_select_flopped_3 <= mux9_select_flopped_2;
end
end

reg [73:0] mult_out_flopped_1;

always @(posedge clk) begin
	if (reset) begin
    mult_out_flopped_1 <= 0;
  end else begin
    mult_out_flopped_1 <= mult_out;
  end
end

reg [53:0] temp_signal;
always @ (*) begin
if (mode_flopped_3[0] ==1'b0) begin 
temp_signal = sub_flopped_3 ?  mult_out_flopped_1[36:0] - mult_out_flopped_1[73:37] : mult_out_flopped_1[36:0] + mult_out_flopped_1[73:37] ;
end
else if (mode_flopped_3[0] ==1'b1) begin 
temp_signal =  mult_out_flopped_1 [53:0];
end
end

wire [63:0]negate_out;
assign negate_out = negate_flopped_3 ? ~temp_signal + 1: temp_signal;

reg loadconst_flopped_4;
reg accumulate_flopped_4;
reg negate_flopped_4;
reg sub_flopped_4;
reg [1:0]mode_flopped_4;
reg mux9_select_flopped_4;

always @ (posedge clk) begin
if (reset == 1'b1) begin
 loadconst_flopped_4 <= 0 ;
 accumulate_flopped_4 <= 0 ;
 negate_flopped_4 <= 0 ;
 sub_flopped_4 <= 0 ;
 mode_flopped_4 <= 0 ;
 mux9_select_flopped_4 <= 0;
end
else begin
 loadconst_flopped_4 <= loadconst_flopped_3;
 accumulate_flopped_4 <= accumulate_flopped_3;
 negate_flopped_4 <= negate_flopped_3;
 sub_flopped_4 <= sub_flopped_3;
 mode_flopped_4 <= mode_flopped_3;
  mux9_select_flopped_4 <= mux9_select_flopped_3;
end
end

reg [73:0] mult_out_flopped_3;
reg [63:0] negate_out_flopped_1;
always @(posedge clk) begin
	if (reset) begin
    mult_out_flopped_3 <= 0;
    negate_out_flopped_1 <= 0;
  end else begin
    mult_out_flopped_3 <= mult_out_flopped_1;
    negate_out_flopped_1 <= negate_out;
  end
end

wire [63:0]data_out;
wire [63:0] mux10_out;
reg [63:0]double_acc_flopped;

assign mux10_out = accumulate_flopped_4 ? double_acc_flopped: ( loadconst_flopped_4 ? constant : 64'd0 );
assign data_out = accumulate_flopped_4 ? negate_out_flopped_1 + mux10_out : ( loadconst_flopped_4 ? mux10_out : ( negate_flopped_4 ? negate_out_flopped_1 + chainin : negate_out_flopped_1 ));

wire[99:0] mux9_out;
assign mux9_out = mux9_select_flopped_4 ? {36'd0, data_out} : { mult_out_flopped_3[72:37] ,28'd0, mult_out_flopped_3[35:0]};

reg [99:0] output_register_bank;
//output register bank
always @(posedge clk) begin
	if (reset) begin
		output_register_bank <= 0;
		double_acc_flopped <= 0;
    	end else begin
      		output_register_bank<=mux9_out;
		double_acc_flopped <= mux9_out[63:0];
    	end
end

assign resulta = mode_flopped_3[1] ? resulta_flopped : output_register_bank [63:0];
assign resultb = mode_flopped_3[1] ? 37'b0 : output_register_bank [99:64];
assign chainout= mode_flopped_3[1] ? chainout_1 : output_register_bank [63:0];

endmodule

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
