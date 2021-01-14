// algo used : https://fgiesen.wordpress.com/2012/03/28/half-to-float-done-quic/

`timescale 1ns / 1ps

module fp32_to_fp16 (input [31:0] a , output [15:0] b);

reg [15:0]b_temp;
//integer j;
//reg [3:0]k;
always @ (*) begin

if ( a [30: 0] == 15'b0 ) begin //signed zero
	b_temp [15] = a[30]; //sign bit
	b_temp [14:0] = 15'b0; 
end

else begin

	if ( a[30 : 23] <= 8'd112  &&  a[30 : 23] >= 8'd103 ) begin //denormalized (covert to normalized)
		
	b_temp [9:0] = {1'b1, a[22:13]} >> {8'd112 - a[30 : 23] + 1'b1} ;  
	b_temp [14:10] =  5'b0;
	b_temp [15] = a[31];
	end

	else if ( a[ 30 : 23] == 8'b11111111 ) begin //Infinity/ NAN
	b_temp [9:0] = a [22:13];
	b_temp [14:10] = 5'h1F;
	b_temp [15] = a[31];
	end

	else begin //Normalized Number
	b_temp [9:0] = a [22:13];
	b_temp [14:10] = 4'd15 - 7'd127  + a[30:23]; //number should be in the range which can be depicted by fp16 (exp for fp32: 70h, 8Eh ; normalized exp for fp32: -15 to 15)
	b_temp [15] = a[31];
	end
end
end

assign b = b_temp;


endmodule
/*
module tb_fp32_to_fp16 ();
reg [31:0] a;
wire [15:0] b;

fp32_to_fp16 uut (a, b);

initial begin
a = 0;
#10
#10 a= 32'h37200000;
#10 a= 32'hB70A0000;
#10 a= 32'h3AC84000;
#10 a= 32'hC2AAA000;
#10 a= 32'h7FC88000;
#10 $finish;
end

endmodule
*/