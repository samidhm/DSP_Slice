// algo used : https://fgiesen.wordpress.com/2012/03/28/half-to-float-done-quic/

`timescale 1ns / 1ps

module fp16_to_fp32 (input [15:0] a , output [31:0] b);

reg [31:0]b_temp;
reg [3:0] j;
reg [3:0] k;
reg [3:0] k_temp;
always @ (*) begin

if ( a [14: 0] == 15'b0 ) begin //signed zero
	b_temp [31] = a[15]; //sign bit
	b_temp[30:0] = 31'b0;
end

else begin

	if ( a[14 : 10] == 5'b0 ) begin //denormalized (covert to normalized)
		
		for (j=0; j<=9; j=j+1) begin
			if (a[j] == 1'b1) begin 
			    k_temp = j;	
			end
		end
	k = 9 - k_temp;

	b_temp [22:0] = ( (a [9:0] << (k+1'b1)) & 10'h3FF ) << 13;
	b_temp [30:23] =  7'd127 - 4'd15 - k;
	b_temp [31] = a[15];
	end

	else if ( a[14 : 10] == 5'b11111 ) begin //Infinity/ NAN
	b_temp [22:0] = a [9:0] << 13;
	b_temp [30:23] = 8'hFF;
	b_temp [31] = a[15];
	end

	else begin //Normalized Number
	b_temp [22:0] = a [9:0] << 13;
	b_temp [30:23] =  7'd127 - 4'd15 + a[14:10];
	b_temp [31] = a[15];
	end
end
end

assign b = b_temp;


endmodule

/*
module tb_fp16_to_fp32 ();
reg [15:0] a;
wire [31:0] b;
fp16_to_fp32 uut (a, b);
initial begin
a = 0;
#10
#10 a= 16'h00A0;
#10 a= 16'h808A;
#10 a= 16'h1642;
#10 a= 16'hD555;
#10 a= 16'h7E44;
#10 $finish;
end
endmodule
*/
