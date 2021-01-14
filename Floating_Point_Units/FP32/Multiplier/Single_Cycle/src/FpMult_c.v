`timescale 1ns / 1ps

module FPMult_c(
		NormM,
		NormE,
		Sp,
		GRS,
		InputExc,
		Z,
		Flags
    );

	// Input Ports
	input [22:0] NormM ;									// Normalized mantissa
	input [8:0] NormE ;									// Normalized exponent
	input Sp ;										// Product sign
	input GRS ;
	input [4:0] InputExc ;

	// Output Ports
	output [31:0] Z ;										// Final product
	output [4:0] Flags ;

	// Output Ports
	wire [8:0] RoundE ;
	wire [8:0] RoundEP ;
	wire [23:0] RoundM ;
	wire [23:0] RoundMP ; 
	
  `ifndef SYNTHESIS_
	assign RoundE = NormE - 127 ;
  `else
  DW01_sub #(9) u_sub1(.A(NormE), .B(9'd127), .CI(1'b0), .DIFF(RoundE), .CO());
  `endif
  `ifndef SYNTHESIS_
	assign RoundEP = NormE - 126 ;
  `else
  DW01_sub #(9) u_sub2(.A(NormE), .B(9'd126), .CI(1'b0), .DIFF(RoundEP), .CO());
  `endif
	assign RoundM = NormM ;
	assign RoundMP = NormM + 1 ;
	
	// Internal Signals
	wire [8:0] FinalE ;									// Rounded exponent
	wire [23:0] FinalM;
	wire [23:0] PreShiftM;
	
	assign PreShiftM = GRS ? RoundMP : RoundM ;	// Round up if R and (G or S)
	
	// Post rounding normalization (potential one bit shift> use shifted mantissa if there is overflow)
	assign FinalM = (PreShiftM[23] ? {1'b0, PreShiftM[23:1]} : PreShiftM[23:0]) ;
	
	assign FinalE = (PreShiftM[23] ? RoundEP : RoundE) ; // Increment exponent if a shift was done
	
	assign Z = {Sp, FinalE[7:0], FinalM[22:0]} ;   // Putting the pieces together
	assign Flags = InputExc[4:0];

endmodule
