module MCP(Clock, Reset, Run, FlagReg);

	input Clock, Run, Reset;
	output [3:0] FlagReg;
	wire  [1:0] Op;
	wire  [2:0] Funct;
	wire  [3:0] Flags;
	wire  PCWrite, AdrSrc, MemWrite, IRWrite, ALUSrcA, ALUSrcB ;  
	wire  WriteASrc, RegWrite, RegSrc;
	wire [1:0] WriteDSrc;
	wire [2:0] ALUControl;
	wire [1:0] ResultSrc;
	wire [2:0] ShiftType;
	
	Datapath m_Datapath(.Clock(Clock), .Reset(Reset), .PCWrite(PCWrite), .AdrSrc(AdrSrc), .MemWrite(MemWrite), 
				.IRWrite(IRWrite), .WriteASrc(WriteASrc), .WriteDSrc(WriteDSrc), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
				.ALUControl(ALUControl), .RegWrite(RegWrite), .ShiftType(ShiftType),
				.RegSrc(RegSrc), .Op(Op), .Funct(Funct), .Flags(Flags), .ResultSrc(ResultSrc));

	Controller m_Controller (.Clock(Clock), .Reset(Reset), .PCWrite(PCWrite), .AdrSrc(AdrSrc), .IRWrite(IRWrite),
				  .Funct(Funct), .Flags(Flags), .WriteASrc(WriteASrc), .WriteDSrc(WriteDSrc), .ShiftType(ShiftType),
				  .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .MemWrite(MemWrite), .Op(Op), .RegSrc(RegSrc), .Run(Run),
				   .RegWrite(RegWrite),.ALUControl(ALUControl), .FlagReg(FlagReg), .ResultSrc(ResultSrc));
				
endmodule	  
