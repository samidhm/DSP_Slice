`timescale 1ns / 1ps

module FPMult_reduced(
		clk,
		rst,
		a,
		b,
		result,
		flags
    );
	
	// Input Ports
	input clk ;							// Clock
	input rst ;							// Reset signal
	input [31:0] a;					// Input A, a 32-bit floating point number
	input [31:0] b;					// Input B, a 32-bit floating point number
	
	// Output ports
	output [31:0] result ;					// Product, result of the operation, 32-bit FP number
	output [4:0] flags ;				// Flags indicating exceptions according to IEEE754

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
	
	reg [110:0]pipe_1;
	reg [38:0]pipe_2;
	
FPMult_a M1 (a, b, Sa, Sb, Ea, Eb, Mp, InputExc) ;
FPMult_b M2 (pipe_1[110:88],pipe_1[87:71],pipe_1[52:5],pipe_1[68:61],pipe_1[60:53],pipe_1[70],pipe_1[69],Sp,NormE,NormM,GRS);
FPMult_c M3 (pipe_2[22:0],pipe_2[31:23],pipe_2[32],pipe_2[33],pipe_2[38:34],result,flags);


always @ (posedge clk) begin	
		if(rst) begin
			pipe_1 <= 0;
			pipe_2 <= 0; 
		end 
		else begin	
			/* PIPE 1
				[110:88] a
				[87:71] b
				[70] Sa
				[69] Sb
				[68:61] Ea
				[60:53] Eb
				[52:5] Mp
				[4:0] InputExc
			*/
			pipe_1 <= {a[22:0], b[16:0], Sa, Sb, Ea[7:0], Eb[7:0], Mp[47:0], InputExc[4:0]} ;
			/* PIPE 2
				[38:34] InputExc
				[33] GRS
				[32] Sp
				[31:23] NormE
				[22:0] NormM
			*/
			pipe_2 <= {pipe_1[4:0], GRS ,Sp, NormE, NormM};

		end
end
endmodule
