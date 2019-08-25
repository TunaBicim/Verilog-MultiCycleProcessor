module RF(clock, reset, write_enable, write_data, read_addr1, 
		   read_addr2, write_addr, read_data1, read_data2);
 
	parameter Addr_W = 8; 
	parameter Data_W = 8;
	input  clock, reset ,write_enable;
	input  [2:0]write_addr;
	input  [2:0]read_addr1;
	input  [2:0]read_addr2;
	input  [Data_W-1:0]write_data;
	output reg [Data_W-1:0]read_data1;
	output reg [Data_W-1:0]read_data2;
	integer k;
	reg [Data_W-1:0] register_file [Addr_W-1:0];

	always@(read_addr1,read_addr2) begin 

		read_data1 = register_file[read_addr1];
		read_data2 = register_file[read_addr2];
		
	end 
	always@(posedge clock) begin 
		if (reset==1'b1) begin 
			for (k=0; k<8; k=k+1) begin
				register_file[k] = 8'b0;
			end
		end else if (write_enable==1'b1) begin
			register_file[write_addr] = write_data;
		end
	end
endmodule
