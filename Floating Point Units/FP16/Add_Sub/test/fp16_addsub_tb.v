`timescale 1ns / 1ps

module FPAddSub_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [`DWIDTH-1:0] a;
	reg [`DWIDTH-1:0] b;
	reg operation;
	// Outputs
	wire [`DWIDTH-1:0] result;
	wire [4:0] flags;
	
	integer i ;

	// Instantiate the Unit Under Test (UUT)
 FPAddSub uut(
		clk,
		rst,
		a,
		b,
		operation,			// 0 add, 1 sub
		result,
		flags
	);
	

	always begin
		#5 clk = ~clk;
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		a = 0;
		b = 0;
		operation = 1'b0;
		// Wait 10 ns for global reset to finish
		#10;
        
		// Add stimulus here

		// expected: 
		#10 a = 16'h1234; b = 16'h4321;
		
		#10 a = 16'hE37B; b = 16'h1AB4; 	

		#10 a = 16'hABCD; b = 16'h9876;


		#100 

		#10 $finish; 

	end
      
endmodule
