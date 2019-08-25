module PC(clock, reset, writeEnable, PC_in, PC_out);
	
	parameter Addr_W = 8;
	input clock, reset, writeEnable;
	input [Addr_W-1:0] PC_in;
	output reg [Addr_W-1:0] PC_out;
	
	always @ (posedge clock) begin
		if(reset==1'b1)
			PC_out <= {Addr_W{1'b0}};
		else if (writeEnable == 1'b1)
			PC_out <= PC_in;
		else 
			PC_out <= PC_out;
	end
endmodule
