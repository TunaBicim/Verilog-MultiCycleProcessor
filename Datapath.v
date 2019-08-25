module Datapath(Clock, Reset, PCWrite, AdrSrc, MemWrite, IRWrite, WriteASrc, WriteDSrc, 
				ALUSrcA, ALUSrcB, RegWrite, RegSrc, ALUControl, 
				ShiftType, Op, Funct, ResultSrc, Flags);

	input Clock,Reset, PCWrite, AdrSrc, MemWrite, IRWrite, WriteASrc;
	input ALUSrcA, ALUSrcB, RegWrite, RegSrc;
	input [2:0] ALUControl;
	input [2:0] ShiftType; 
	input [1:0] ResultSrc;
	input [1:0]	WriteDSrc;
	output [1:0] Op;
	output [2:0] Funct;
	output [3:0] Flags;

	wire [7:0]  PC;
	wire [7:0]  Adr;
	wire [15:0] ReadData;
	wire [15:0] Inst;
	wire [7:0]  Data;
	wire [2:0]  WriteAddr;
	wire [7:0]  WriteData;
	wire [7:0]  Result;
	
	wire [7:0] RD1;
	wire [7:0] Rd1;
	wire [7:0] RD2;
	wire [7:0] Rd2;
	wire [7:0] SRD2;
	wire [7:0] SrcA;
	wire [7:0] SrcB;
	wire [7:0] ALUResult;
	wire [2:0] RA2;
	
	assign Op	 = Inst[15:14];
	assign Funct = Inst[13:11];
	
	PC #(.Addr_W(8)) ProgramCounter (.clock(Clock), .reset(Reset), .writeEnable(PCWrite), .PC_in(Result), .PC_out(PC));
	
	Mux2x1 #(.W(8)) AdrMux (.In0(PC), .In1(Result), .Select(AdrSrc), .Out(Adr));
	
	IDM #(.Addr_W(128),.Data_W(16)) InstDataMemory (.clock(Clock), .reset(Reset), .addr(Adr), .write_enable(MemWrite), 
													.write_data(Rd2), .read_data(ReadData));
	
	RegWithWE #(.W(16)) InstReg (.Clock(Clock), .Reset(Reset), .WriteEnable(IRWrite), .Data(ReadData), .Q(Inst));
	
	
	Mux2x1 #(.W(3)) RA2Mux (.In0(Inst[7:5]), .In1(Inst[10:8]), .Select(RegSrc), .Out(RA2));
	
	Mux2x1 #(.W(3)) WriteAddrMux (.In0(Inst[10:8]), .In1(3'b111), .Select(WriteASrc), .Out(WriteAddr));
	
	Mux4x1 #(.W(8)) WriteDataMux (.In0(Result), .In1(PC), .In2(ReadData[7:0]) , .In3(), .Select(WriteDSrc), .Out(WriteData));
	
	RF #(.Addr_W(8), .Data_W(8)) RegisterFile ( .clock(Clock), .reset(Reset), 
								  .write_enable(RegWrite), .write_data(WriteData), 
								  .read_addr1(Inst[4:2]), .read_addr2(RA2), 
								  .write_addr(WriteAddr), .read_data1(RD1), .read_data2(RD2));
	
	simpleReg #(.W(8)) RD1Reg (.Clock(Clock), .Reset(Reset), .Data(RD1), .Q(Rd1));
	
	simpleReg #(.W(8)) RD2Reg (.Clock(Clock), .Reset(Reset), .Data(RD2), .Q(Rd2));
	
	Shifter SH1 (.In(Rd2),.ShiftType(ShiftType),.Out(SRD2));
	
	Mux2x1 #(.W(8)) SrcAMux (.In0(Rd1), .In1(PC), .Select(ALUSrcA), .Out(SrcA));
	
	Mux2x1 #(.W(8)) SrcBMux (.In0(SRD2), .In1(8'h02), .Select(ALUSrcB), .Out(SrcB));
	
	ALU #(.W(8)) ALU1 (.A(SrcA), .B(SrcB), .ALU_Control(ALUControl), 
							.ALU_Out(ALUResult), .CO(Flags[1]), .OVF(Flags[0]), 
							.N(Flags[3]), .Z(Flags[2]));
												
	Mux4x1 #(.W(8)) ResultMux (.In0(ALUResult), .In1(SRD2), .In2(Inst[7:0]), .In3(), .Select(ResultSrc), .Out(Result));												

endmodule 
	