module Controller(Clock,Reset, PCWrite, AdrSrc, IRWrite, WriteASrc, WriteDSrc,
				  ALUSrcA, ALUSrcB, MemWrite,  RegWrite, RegSrc, ALUControl,
				  ShiftType, ResultSrc, Op, Funct, Flags, FlagReg, Run);
	
	input Clock,Reset, Run;
	input [1:0] Op;
	input [2:0] Funct;
	input [3:0] Flags;
	output reg PCWrite, AdrSrc, IRWrite, WriteASrc, MemWrite;
	output reg ALUSrcA, ALUSrcB, RegWrite, RegSrc;
	output reg [2:0] ALUControl;
	output reg [2:0] ShiftType; 
	output reg [1:0] ResultSrc;
	output reg [1:0] WriteDSrc;
	output reg[3:0] FlagReg;

	parameter [1:0] Fetch=0, Decode=1, Execute=2;
	parameter [1:0] DataProc=0, ShiftOp=1, MemOp=2, Branch=3;
	reg [1:0] State;
	reg [1:0] NextState;
	reg [1:0]FlagW;
	reg RunBuffer;
	
	always@(posedge Clock) begin
		
		if (Reset) begin 
			RunBuffer <= 0;
			FlagReg <= 4'h0;
		end else if (RunBuffer != Run && Run == 1) begin 
			RunBuffer <= 1;
		end 
		
		State <= NextState;
		if (FlagW[0] == 1'b1) begin 
			FlagReg[1:0] <= Flags[1:0];
		end 
		if (FlagW[1] == 1'b1) begin 
			FlagReg[3:2] <= Flags[3:2];
		end 
		
	end 
	
	always@(Op, Funct, Flags, Reset, State, PCWrite, AdrSrc, MemWrite, WriteASrc, IRWrite, FlagW,
			WriteDSrc, ALUSrcA, ALUSrcB, RegWrite, RegSrc, ResultSrc, ShiftType, ALUControl) begin 
		PCWrite = 0; 
		IRWrite = 0; 
		AdrSrc = 0;  
		MemWrite = 0;
		WriteASrc = 0;
		WriteDSrc = 2'b00;
		ALUSrcA = 0;
		ALUSrcB = 0;
		RegWrite = 0;
		RegSrc = 0;
		FlagW = 2'b00;
		ResultSrc = 2'b00;
		ShiftType = 3'b000;
		ALUControl = 3'b000;
		if (Reset) begin 
			NextState = Fetch;
		end else if (Run) begin 
			case (State)
				Fetch: begin 
					PCWrite = 1; 
					IRWrite = 1;
					ALUSrcA = 1;
					ALUSrcB = 1;
					ResultSrc = 2'b00;
					NextState = Decode;
				end 
				
				Decode: begin 
					NextState = Execute;
					if (Op == 2'b01 || ((Op == 2'b10 || Op == 2'b11) && Funct == 3'b010)) 
						RegSrc = 1;						
				end 
				
				Execute: begin 
					NextState = Fetch;
					case (Op)
						DataProc: begin 
							RegWrite = 1;
							case (Funct)
								3'b000: begin 
									ALUControl = 3'b000;
									FlagW = 2'b11;
								end 
								3'b001: begin 
									ALUControl = 3'b001;
									FlagW = 2'b11;
								end 
								3'b010: begin 
									ALUControl = 3'b100;
									FlagW = 2'b10;
								end 
								3'b011: begin 
									ALUControl = 3'b101;
									FlagW = 2'b10;
								end 
								3'b100: begin 
									ALUControl = 3'b110;
									FlagW = 2'b10;
								end 
								3'b101: begin 
									ALUControl = 3'b011;
									FlagW = 2'b10;
								end
								default: begin
								end 
							endcase 
						end 
						ShiftOp: begin
							RegWrite = 1;
							ResultSrc = 2'b01;
							ShiftType = Funct + 1;
						end 
						MemOp: begin 
							case(Funct)
								3'b000: begin 
									ResultSrc = 2'b10; 
									AdrSrc = 1;
									WriteDSrc = 2'b10;
									RegWrite = 1;
								end 
								3'b001: begin 
									ResultSrc = 2'b10;
									RegWrite = 1;									
								end 
								3'b010: begin 
									ResultSrc = 2'b10;
									AdrSrc = 1;
									MemWrite = 1;
								end 
								default: begin 
								end
							endcase 
						end 	
						Branch: begin
							case (Funct)
								3'b000: begin 
									ResultSrc = 2'b10;
									PCWrite = 1;
								end 
								3'b001: begin 
									ResultSrc = 2'b10;
									WriteASrc = 1;
									WriteDSrc = 2'b01;
									RegWrite  = 1;
									PCWrite = 1;
								end 
								3'b010: begin 
									ResultSrc = 2'b01;
									WriteASrc = 1;
									WriteDSrc = 2'b01;
									RegWrite  = 1;
									PCWrite = 1;
								end 
								3'b011: begin 
									if (FlagReg[2] == 1) begin 
										ResultSrc = 2'b10;
										PCWrite = 1;
									end 
								end 
								3'b100: begin 
									if (FlagReg[2] == 0) begin 
										ResultSrc = 2'b10;
										PCWrite = 1;
									end
								end 
								3'b101: begin 
									if (FlagReg[1] == 1) begin 
										ResultSrc = 2'b10;
										PCWrite = 1;
									end
								end 
								3'b110: begin 
									if (FlagReg[1] == 0) begin 
										ResultSrc = 2'b10;
										PCWrite = 1;
									end	
								end
								default: begin 
								
								end 
							endcase
						end 
						default: begin 
						
						end 
					endcase 
				end 
				default: begin 
					NextState = Fetch;
				end 
			endcase 
		end else begin 
			NextState = Fetch;
		end 
	end 
endmodule 