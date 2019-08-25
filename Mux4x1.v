/*-----------------------------------------------------
--   4 to 1 Multiplexer
--   This modules passes one of the inputs In3 to In0 
--   according to the select signal. Data width is 
--   given as a parameter to this module.
--   Designer: Tuna Biçim
-----------------------------------------------------*/ 
module Mux4x1(In0, In1, In2, In3, Select, Out);
	parameter W = 8;
	output reg[W-1:0] Out;
	input [W-1:0] In0, In1, In2, In3;
	input [1:0]Select;

 always @(In0 or In1 or In2 or In3 or Select)
 case ( Select )
 2'b00: Out = In0;
 2'b01: Out = In1;
 2'b10: Out = In2;
 2'b11: Out = In3;
 default: Out = {W{1'b0}};
 endcase

 endmodule