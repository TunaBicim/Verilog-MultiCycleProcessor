/*-----------------------------------------------------
--   Simple Register  
--   This is the implementation for a simple register
--   This module has synchronous reset which clears the
--   output of the system, while reset is low input data
--   is transferred to the output register Q.
--   Designer: Tuna Biçim
-----------------------------------------------------*/ 
module simpleReg(Clock, Reset, Data, Q);
           
    parameter W = 16;
    input Clock, Reset;
	input [W-1:0] Data; 
    output reg[W-1:0] Q; // ALU W-bit Output
    
    always @(posedge Clock)
    begin
	if (Reset) 
		Q <= 0;
	else 
		Q <= Data;
	end 
endmodule