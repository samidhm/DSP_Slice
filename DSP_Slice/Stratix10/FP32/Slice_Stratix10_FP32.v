module dsp_slice_fp32 (clk, enable, clr, funct, chainin, accumulate, ax, ay, az, chainout, resulta_flopped );

input clk;
input enable;
input clr;
input [3:0] funct;
input [31:0] chainin;
input accumulate;
input [31:0] ax;
input [31:0] ay;
input [31:0] az;
output [31:0] chainout;
output [31:0] resulta_flopped;

reg [31:0] ax_flopped;
reg [31:0] ay_flopped;
reg [31:0]az_flopped;
reg accumulate_flopped_1;
reg [3:0] funct_flopped;

always @(posedge clk) begin
	if (clr) begin
		ax_flopped <= 0;
		ay_flopped <= 0;
		az_flopped <= 0;
		accumulate_flopped_1 <= 0;
		funct_flopped <= 0;
    	end else begin
      		ax_flopped <= ax;
		ay_flopped <= ay;
		az_flopped <= az;
		accumulate_flopped_1 <= accumulate;
		funct_flopped <= funct;
    	end
end

wire mux1_select;
wire [1:0] mux2_select;
wire mux3_select;
wire mux5_select;

assign mux1_select = (funct_flopped[1] & funct_flopped[0] ) | (funct_flopped[3] & ~funct_flopped[1]) | (funct_flopped[2] & ~funct_flopped[0] );
assign mux2_select[1] = ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[1]) | ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[0]) | ( funct_flopped[3] & funct_flopped[1] & funct_flopped[0]);
assign mux2_select[0] = funct_flopped[2] | ( funct_flopped[3] & ~funct_flopped[1])  | (funct_flopped[1] & funct_flopped [0]);
assign mux3_select = (funct_flopped[3] & ~funct_flopped[1]) + (funct_flopped[2] & funct_flopped[1] & funct_flopped[0]);
assign mux5_select = funct_flopped[3] | (~funct_flopped[2] & funct_flopped[0]) | (funct_flopped[2] & ~funct_flopped[0])  | (funct_flopped[2] & ~funct_flopped[1]) ;

wire [31:0] mult_ip_a;
wire [31:0] mult_ip_b;
wire [31:0] mult_out;
reg [31:0] mult_out_flopped_1;
reg [31:0] mult_out_flopped_2;
wire [4:0] mult_flags;
assign mult_ip_a = ay_flopped;
assign mult_ip_b = az_flopped;

FPMult_single Multiplier( clk, clr ,mult_ip_a ,mult_ip_b,mult_out, mult_flags );

//Two flop stages after the output of the multiplier
always @(posedge clk) begin
	if (clr) begin
    mult_out_flopped_1 <= 0;
    mult_out_flopped_2 <= 0;
  end else begin
    mult_out_flopped_1 <= mult_out;
    mult_out_flopped_2 <= mult_out_flopped_1;
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
wire [4:0] adder_flags;
wire operation;


assign operation = ( ~funct_flopped[3] & ~funct_flopped[2] & ~funct_flopped[0]) | ( ~funct_flopped[3] & ~funct_flopped[1] & ~funct_flopped[0])  | ( funct_flopped[3] & ~funct_flopped[1] & funct_flopped[0]);

assign mux1_out = mux1_select ? chainin: ax_flopped;

//Three flop stages at the input of the adder 
always @(posedge clk) begin
	if (clr) begin
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
assign mux2_out= mux2_select[1] ? ( mux2_select[0] ? ax_flopped : ay_flopped) : ( mux2_select[0] ? mult_out_flopped_2 : 32'd0);

assign adder_ip_a = mux4_out;
assign adder_ip_b = mux2_out;

FPAddSub_single Adder ( clk, clr, adder_ip_a , adder_ip_b , operation, adder_out, adder_flags );

wire [31:0] mux3_out;
assign mux3_out = mux3_select ? ax_flopped : resulta_flopped;
assign chainout = mux3_out;

wire [31:0] resulta;
wire [31:0] mux5_out;

assign mux5_out = mux5_select ? adder_out : mult_out_flopped_2;
assign resulta = mux5_out;

reg [31:0] resulta_flopped_1;

always @(posedge clk) begin
	if (clr) begin
		resulta_flopped_1 <= 0;
    	end else begin
		resulta_flopped_1 <= resulta;
    	end
end

assign resulta_flopped = resulta_flopped_1;

endmodule

