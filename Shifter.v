module Shifter(In, ShiftType, Out);

	input  [7:0] In;
	input  [2:0] ShiftType;
	output reg[7:0] Out;
	//ShiftType - 0: LSL , 1: LSR
	always@(ShiftType, In) begin  
		
		case (ShiftType)
			3'b000: //No shift
				Out = In; 
			3'b001: //Rotate Left 
				Out = {In[6:0],In[7]};
			3'b010: //Rotate Right 
				Out = {In[0],In[7:1]};
			3'b011: //Shift Left 
				Out = {In[6:0],1'b0};
			3'b100: //Arithmetic Shift Right 
				Out = {In[7],In[7:1]};
			3'b101: //Shift Right 
				Out = {1'b0,In[7:1]};
			default: //No shift 
				Out = In; 
		endcase 
	end 
endmodule   
