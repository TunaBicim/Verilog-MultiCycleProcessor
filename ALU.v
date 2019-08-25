/*-----------------------------------------------------
--   Arithmetic Logic Unit
--   This arithmetic logic unit performs different operations
--   to input data and gives out an output and necessary flags.
--   Data width is given as a parameter to this module. 
--   Performed operations are: 
--   Addition, Subtraction, Bit Clear, And, Or, Exor and Exnor
--   Designer: Tuna Biçim
-----------------------------------------------------*/ 
module ALU(A, B, ALU_Control, ALU_Out, CO, OVF, N, Z);
           
    parameter W = 8;
    input [W-1:0] A,B;  // ALU W-bit Inputs                 
    input [2:0] ALU_Control;// ALU Selection
    output [W-1:0] ALU_Out; // ALU W-bit Output
    output CO;  // Carry Out Flag
    output OVF; // Overflow Flag
    output N;   // Negative Flag
    output Z;   // Zero Flag
	
	reg [W-1:0] ALU_Result;
	assign ALU_Out = ALU_Result; // ALU out
	
	reg [W:0]Carry_Out; //Register to execute carry calculations
	reg Overflow; // Overflow bit to determine if the condition occurred
	assign CO = Carry_Out[W]; //If the first bit of the carry out is 1 the operation had a carry
	assign OVF = Overflow;
	assign N = ALU_Result[W-1];
	assign Z = ~(|ALU_Result);
	
    always @(*)
    begin
        case(ALU_Control)
        3'b000: begin// Addition
			ALU_Result = A + B ; 
			Overflow  = ((~A[W-1])&(~B[W-1])&ALU_Result[W-1])|(A[W-1]&B[W-1]&(~ALU_Result[W-1]));
			Carry_Out = {1'b0, A} + {1'b0, B};
			end 
        3'b001: begin// SubtractionAB
			ALU_Result = A - B ;
			Overflow  = ((~A[W-1])&B[W-1]&ALU_Result[W-1])|((A[W-1])&(~B[W-1])&(~ALU_Result[W-1]));
			Carry_Out = ~({1'b0, A} + {1'b0, (-B)});
			end
        3'b010: begin // SubtractionBA
			ALU_Result = B - A;
			Overflow  = ((~A[W-1])&B[W-1]&(~ALU_Result[W-1]))|((A[W-1])&(~B[W-1])&ALU_Result[W-1]);
			Carry_Out = ~({1'b0, (-A)} + {1'b0, B});
			end 
        3'b011: begin // Clear
			ALU_Result = {W{1'b0}}; 
			Overflow = 1'b0;
			Carry_Out = {W+1{1'b0}};
			end 
        3'b100: begin //  Logical and 
			ALU_Result = A & B;
			Overflow = 1'b0;
			Carry_Out = {W+1{1'b0}};
			end
        3'b101: begin //  Logical or
			ALU_Result = A | B;
			Overflow = 1'b0;
			Carry_Out = {W{1'b0}};
			end
        3'b110: begin //  Logical xor 
            ALU_Result = A ^ B;
			Overflow = 1'b0;
			Carry_Out = {W{1'b0}};
			end
        3'b111: begin // Logical xnor
            ALU_Result = ~(A ^ B);
			Overflow = 1'b0;
			Carry_Out = {W{1'b0}};
			end
        default: begin ALU_Result = A + B ; 
		   	Overflow = 1'b0;
			Carry_Out = {W{1'b0}};
			end

        endcase
    end

endmodule