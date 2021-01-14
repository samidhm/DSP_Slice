`timescale 1ns / 1ps

module FPMult_b(
		a,
		b,
		MpC,
		Ea,
		Eb,
		Sa,
		Sb,
		Sp,
		NormE,
		NormM,
		GRS
    );

	// Input ports
	input [22:0] a ;
	input [16:0] b ;
	input [47:0] MpC ;
	input [7:0] Ea ;						// A's exponent
	input [7:0] Eb ;						// B's exponent
	input Sa ;								// A's sign
	input Sb ;								// B's sign
	
	// Output ports
	output Sp ;								// Product sign
	output [8:0] NormE ;													// Normalized exponent
	output [22:0] NormM ;												// Normalized mantissa
	output GRS ;
	
	wire [47:0] Mp ;
	
	assign Sp = (Sa ^ Sb) ;												// Equal signs give a positive product
	
  `ifndef SYNTHESIS_
	assign Mp = (MpC<<17) + ({7'b0000001, a[22:0]}*{1'b0, b[16:0]}) ;
  `else
  wire [47:0] Mp_temp;
  DW02_mult #(30,18) u_mult(.A({7'b0000001, a[22:0]}), .B({1'b0, b[16:0]}), .TC(1'b1), .PRODUCT(Mp_temp));
  DW01_add #(48) u_add1(.A(MpC<<17), .B(Mp_temp), .CI(1'b0), .SUM(Mp), .CO());
  `endif
	
	assign NormM = (Mp[47] ? Mp[46:24] : Mp[45:23]); // Check for overflow
  `ifndef SYNTHESIS_
	assign NormE = (Ea + Eb + Mp[47]);								// If so, increment exponent
  `else
  DW01_add #(8) u_add2(.A(Ea), .B(Eb), .CI(Mp[47]), .SUM(NormE[7:0]), .CO(NormE[8]));
  `endif
	
	assign GRS = ((Mp[23]&(Mp[24]))|(|Mp[22:0])) ;
	
endmodule
