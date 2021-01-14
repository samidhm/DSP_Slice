
module FPMult_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [`DWIDTH-1:0] a;
	reg [`DWIDTH-1:0] b;

	// Outputs
	wire [`DWIDTH-1:0] result;
	wire [4:0] flags;
	
	integer i ;

	// Instantiate the Unit Under Test (UUT)
	FPMult_16 uut (
		.clk(clk), 
		.rst(rst), 
		.a(a), 
		.b(b), 
		.result(result), 
		.flags(flags)
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

		// Wait 10 ns for global reset to finish
		#10;
        
		// Add stimulus here

		// expected: 1987h
		#10 a = 16'h1234; b = 16'h4321;
		
		// expected: c244h
		#10 a = 16'hE37B; b = 16'h1AB4; 	
		
		// expected: 0859h
		#10 a = 16'hABCD; b = 16'h9876;


		#100 

		#10 $finish; 

	end
      
endmodule