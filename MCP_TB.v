`timescale 1ns/1ns
module MCP_TB;

	reg Clock;
	reg Reset; 
	reg Run;
	wire [3:0]FlagReg;
	
	MCP DUT(.Clock(Clock), .Reset(Reset), .Run(Run), .FlagReg(FlagReg));
	
	initial begin 
		Clock = 0;
		forever begin
		#5 Clock = ~Clock;
		end
	end	
	
	initial begin	
	Reset = 1;
	Run = 0;
	#10;
	Reset = 0;
	Run = 1;
	//#10;
	//Run = 0;
	#340;
	Reset = 1;
	end 
	
endmodule
