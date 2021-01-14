module Multiplier_combined(
	input [36:0] IN1,
	input [36:0] IN2,
	output [73:0] OUT1,
	input mode
);
reg [8:0] mult1_a;
reg [8:0] mult1_b;
reg [9:0] mult2_a;
reg [8:0] mult2_b;
reg [8:0] mult3_a;
reg [8:0] mult3_b;
reg [9:0] mult4_a;
reg [8:0] mult4_b;
reg [8:0] mult5_a;
reg [8:0] mult5_b;
reg [9:0] mult6_a;
reg [8:0] mult6_b;
reg [8:0] mult7_a;
reg [8:0] mult7_b;
reg [9:0] mult8_a;
reg [8:0] mult8_b;
reg [8:0] mult9_a;
reg [8:0] mult9_b;

wire [17:0] mult1_c;
wire [18:0] mult2_c;
wire [17:0] mult3_c;
wire [18:0] mult4_c;
wire [17:0] mult5_c;
wire [18:0] mult6_c;
wire [17:0] mult7_c;
wire [18:0] mult8_c;
wire [17:0] mult9_c;

wire [36:0]temp1;
wire [36:0] temp2;
always @ (*) begin
//for 18*19 mode
if (mode == 1'b0) begin
mult1_a = IN1[8:0];
mult1_b = IN1 [27:19]; //1

mult2_a= IN1 [18:9];
mult2_b = IN1[27:19]; //2

mult3_a = IN1 [36:28];
mult3_b = IN1[8:0]; //1

mult4_a= IN1[18:9];
mult4_b= IN1[36:28]; //2

mult5_a = IN2[8:0];
mult5_b = IN2 [27:19]; //1

mult6_a= IN2 [18:9];
mult6_b = IN2[27:19]; //2

mult7_a = IN2 [36:28];
mult7_b = IN2[8:0]; //1

mult8_a= IN2[18:9];
mult8_b= IN2[36:28]; //2

end
//for 27*27 mode

else if (mode == 1'b1) begin
mult1_a = IN1[8:0];
mult1_b = IN2 [8:0];

mult2_a = IN1[8:0];
mult2_b = IN2 [17:9];

mult3_a = IN1[8:0];
mult3_b = IN2 [26:18];

mult4_a = IN1[17:9];
mult4_b = IN2 [8:0];

mult5_a = IN1[17:9];
mult5_b = IN2 [17:9];

mult6_a = IN1[17:9];
mult6_b = IN2 [26:18];

mult7_a = IN1[26:18];
mult7_b = IN2 [8:0];

mult8_a = IN1[26:18];
mult8_b = IN2 [17:9];

mult9_a = IN1[26:18];
mult9_b = IN2 [26:18];
end
end


multiplier_basic_1 M1( mult1_a, mult1_b, mult1_c);
multiplier_basic_2 M2( mult2_a, mult2_b, mult2_c);
multiplier_basic_1 M3( mult3_a, mult3_b, mult3_c);
multiplier_basic_2 M4( mult4_a, mult4_b, mult4_c);
multiplier_basic_1 M5( mult5_a, mult5_b, mult5_c);
multiplier_basic_2 M6( mult6_a, mult6_b, mult6_c);
multiplier_basic_1 M7( mult7_a, mult7_b, mult7_c);
multiplier_basic_2 M8( mult8_a, mult8_b, mult8_c);
multiplier_basic_1 M9( mult9_a, mult9_b, mult9_c);

assign temp1 = mult1_c + (mult2_c << 9) + (mult3_c << 9) + (mult4_c << 18);
assign temp2 = mult5_c + (mult6_c << 9) + (mult7_c << 9) + (mult8_c << 18);
assign OUT1 = mode ? (mult1_c + (mult2_c << 9) + (mult3_c << 18) + (mult4_c << 9) + (mult5_c << 18) + (mult6_c << 27) + (mult7_c << 18) + (mult8_c << 27) + (mult9_c << 36)) : {temp2, temp1};

endmodule

module multiplier_basic_1 (
	input [8:0] a,
	input [8:0] b,
	output [17:0] c
);

assign c = a*b;
endmodule

module multiplier_basic_2 (
	input [9:0] a,
	input [8:0] b,
	output [18:0] c
);
assign c = a*b;
endmodule
