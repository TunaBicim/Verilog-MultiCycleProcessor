/*-----------------------------------------------------
--   2 to 1 Multiplexer
--   This modules passes one of the inputs In1 or In0 
--   according to the select signal. Data width is 
--   given as a parameter to this module.
--   Designer: Tuna Biçim
-----------------------------------------------------*/ 
module Mux2x1(In0, In1, Select, Out);
	parameter W = 32;
	output reg[W-1:0] Out;
	input [W-1:0] In0, In1;
	input Select;

	always @(In0 or In1 or Select)
 
		Out = (Select) ? In1 : In0;
		
endmodule