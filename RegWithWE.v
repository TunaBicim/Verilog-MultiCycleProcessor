/*-----------------------------------------------------
--   Register with Write Enable
--   This is the implementation for a register with WE
--   This module has synchronous reset which clears the
--   output of the system, while reset is low input data
--   is transferred to the output register Q when Write 
-- 	 Enable is high else the output is preserved.
--   Designer: Tuna Biçim
-----------------------------------------------------*/ 
module RegWithWE(Clock, Reset, WriteEnable, Data, Q);
           
    parameter W = 8;
    input Clock, Reset, WriteEnable;
	input [W-1:0] Data; 
    output reg[W-1:0] Q; // ALU W-bit Output
    
    always @(posedge Clock)
    begin
		if (Reset) 
			Q <= 0;
		else if (WriteEnable)
			Q <= Data;
		else 
			Q <= Q;
	end 
endmodule
