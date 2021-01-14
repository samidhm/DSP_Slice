module pre_adder_combined(
	input [36:0] IN1,
	input [36:0] IN2,
	output [37:0] OUT1,
	input mode
);

reg [ 18 :0] add1_a;
reg [ 17 :0] add1_b;
reg [18:0]add2_a;
reg [17:0]add2_b;
wire [18:0]add1_c;
wire [18:0]add2_c;

always @(*) begin
if ( mode == 1'b0 ) begin
	add1_a = IN1[18:0]; //ay 19bit
	add1_b = IN1[36:19]; //az 18bit
	add2_a = IN2[18:0]; //by 19bit
	add2_b = IN2[36:19]; //bz 18bit
	end
else begin
	add1_a=IN1[18:0]; //ay first 19 bits
	add1_b={ IN2[7:0], IN1[36:27]}; //az first 19 bits
	
	add2_a= {10'b0, IN1[26:19]}; //ay last 8 bits
	add2_b= {10'b0, IN2[15:8]}; //az last 8 bits
	end
end

wire carry;
wire cout_1;

pre_adder_building u_add1(.a(add1_a), .b(add1_b), .cin(1'b0), .c(add1_c), .cout(cout_1));
assign carry = mode ? cout_1: 1'b0;
pre_adder_building u_add2(.a(add2_a), .b(add2_b), .cin(carry), .c(add2_c), .cout());

assign OUT1 = {add2_c, add1_c};

endmodule

module pre_adder_building(
	input [18:0] a,
	input [17:0] b,
	input cin,
	output [18:0] c,
	output cout
	);
assign {cout, c} = a + b + cin;
endmodule
