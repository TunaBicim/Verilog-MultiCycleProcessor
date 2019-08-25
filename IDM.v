module IDM(clock, reset, addr, write_enable, write_data, read_data);

	parameter Addr_W = 128; 
	parameter Data_W = 16;
	input  clock, reset, write_enable;
	input  [7:0]addr;
	input  [7:0]write_data;
	output [Data_W-1:0]read_data;
	integer k;
	reg [Data_W-1:0] memory [Addr_W-1:0];
	assign read_data=memory[addr[7:1]];

	always@(posedge clock) begin 
		if (reset== 1'b1) begin 
			for (k=11; k<128; k=k+1) begin
				memory[k] = 16'b0;
			end			   //Op Fnc Rd  Source2
			memory[0]  = 16'b10_001_000_00000010; // LDRI R0 2    		0000 0010 = 2  
			memory[1]  = 16'b10_001_001_00000111; // LDRI R1 7			0000 0111 = 6 
			memory[2]  = 16'b00_010_010_00100000; // AND R2,R1,R0   	0000 0010 = 2
			memory[3]  = 16'b00_001_000_00001000; // SUB R0,R0,R2   	0000 0000 = 0
			memory[4]  = 16'b11_011_000_00001110; // BEQ 0000 1110  	 000 0111 = 7 
			memory[5]  = 16'b11_010_111_00000000; // BLX LR				 000 1000 = 8
			memory[6]  = 16'b00_000_000_00000000; // 	
			memory[7]  = 16'b11_001_000_00001010; // BL 0000 101    	 000 0101 = 5
			memory[8]  = 16'b01_001_001_00000000; // ROR R1  			1000 0011 = 131
			memory[9]  = 16'b10_010_001_10000000; // STR R1 1000 000
			memory[10] = 16'b10_000_011_10000000; // LDR R3 1000 000
			
		end else if (write_enable==1'b1) 
			memory[addr[7:1]] = {8'h00,write_data};
	end 
endmodule 
