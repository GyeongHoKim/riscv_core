`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:06 05/03/2022 
// Design Name: 
// Module Name:    Execution 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Execution(
	input 	clk, reset,
	// control signal
	input 		Ctl_ALUSrc_in, Ctl_MemtoReg_in, 	Ctl_RegWrite_in,Ctl_MemRead_in, Ctl_MemWrite_in, Ctl_Branch_in, Ctl_ALUOpcode1_in, Ctl_ALUOpcode0_in,
	output reg						Ctl_MemtoReg_out, Ctl_RegWrite_out, Ctl_MemRead_out,	Ctl_MemWrite_out,	Ctl_Branch_out,
	// bypass
	input 		[ 4:0] Rd_in,
	output reg 	[ 4:0] Rd_out,
	// 
	input 		[31:0] Immediate_in, ReadData1_in, ReadData2_in, PC_in, 
	input 		[ 6:0] funct7_in, 
	input 		[ 2:0] funct3_in, 
	output reg			 Zero_out,
	
	output reg 	[31:0] ALUresult_out, PCimm_out, ReadData2_out
	);
	
	//RISC-V
	wire [3:0] ALU_ctl;
	wire [31:0] ALUresult;
	wire zero;
	
	wire [31:0] ALU_input1 = ReadData1_in;
	wire [31:0] ALU_input2 = Ctl_ALUSrc_in ? Immediate_in : ReadData2_in;
		
	ALU_control B0 (.ALUop({Ctl_ALUOpcode1_in, Ctl_ALUOpcode0_in}), .funct7(funct7_in), .funct3(funct3_in), .ALU_ctl(ALU_ctl));
	ALU B1 (.ALU_ctl(ALU_ctl), .in1(ALU_input1), .in2(ALU_input2), .out(ALUresult), .zero(zero));
	
	always@(posedge clk) begin
		Ctl_MemtoReg_out	<= reset ? 0 : Ctl_MemtoReg_in;
		Ctl_RegWrite_out	<= reset ? 0 : Ctl_RegWrite_in;
		Ctl_MemRead_out	<= reset ? 0 : Ctl_MemRead_in;
		Ctl_MemWrite_out	<= reset ? 0 : Ctl_MemWrite_in;
		Ctl_Branch_out		<= reset ? 0 : Ctl_Branch_in;
		
		Rd_out				<= reset ? 0 : Rd_in;
		PCimm_out			<= reset ? 0 : (Immediate_in << 1) + PC_in;
		ReadData2_out		<= reset ? 0 : ALU_input2;
		ALUresult_out		<= reset ? 0 : ALUresult;
		Zero_out			<= reset ? 0 : zero;
		
	end
endmodule
//////////////////////////////////////////////////////////////////////////////////
module ALU_control(
	input [1:0] ALUop,
	input [6:0] funct7,
	input [2:0] funct3,
	output reg [3:0] ALU_ctl
	);
	
	//ALU_ctl	:	OPERATION
	//4'b0000	:	and	==>ReadData1&ReadData2
	//4'b0001	:	or		==>ReadData1|ReadData2
	//4'b0010	:	add	==>ReadData1+ReadData2(Immediate_in)
	//4'b0110	:	sub	==>ReadData1-ReadData2
	//4'b0111 	:	blt (branch if less than)
	//4'b1000 	:	bge (branch if greater equal)     // blt,bgezero=1?만들긄해out=0?로 ?팅  
	//4'b1100 	:	nor	==> ~(ReadData1|ReadData2)
	//4'b1001 	:	shift left
	//4'b1010 	:	shift right
	
	always @(*) begin
		casex ({ALUop,funct3,funct7})
			12'b00_xxx_xxxxxxx :	ALU_ctl	=	4'b0010;	// lb, lh, lw, sb, sh, sw 	=> ADDITION
			12'b01_00x_xxxxxxx :	ALU_ctl =	4'b0110;	// beq, bne 					=> SUBTRACT (funct3==3'b000)	||	(funct3==3'b001)
			12'b01_100_xxxxxxx :	ALU_ctl =	4'b0111;	// blt							=> BLT(branch if less than) (funct3==3'b100)
			12'b01_100_xxxxxxx :	ALU_ctl =	4'b1000;	// bge							=> BGE(branch if greater than) (funct3==3'b101)
			12'b10_000_0000000 :	ALU_ctl =	4'b0010;	// add							=> ADDITION (funct3==3'b000 && funct7==7'b0000000)
			12'b10_000_0100000 :	ALU_ctl =	4'b0110;	// sub							=> SUBTRACT (funct3==3'b000 && funct7==7'b0100000)
			12'b10_111_0000000 :	ALU_ctl =	4'b0000;	// and							=> AND (funct3==3'b111 && funct7==7'b0000000)
			12'b10_110_0000000 :	ALU_ctl =	4'b0001;	// or								=> OR (funct3==3'b110 && funct7==7'b0000000)
			12'b10_001_0000000 :	ALU_ctl =	4'b1001;	// sll							=> SHIFT_LEFT (funct3==3'b001)
			12'b10_101_0000000 :	ALU_ctl =	4'b1010;	// srl							=> SHIFT_RIGHT (funct3==3'b101)
			12'b00_000_xxxxxxx :	ALU_ctl =	4'b0010;	// addi, jalr					=> ADDITION (funct3==3'b000)
			12'b00_111_xxxxxxx :	ALU_ctl =	4'b0000;	// andi							=> AND (funct3==3'b111)	
			12'b10_001_0000000 :	ALU_ctl =	4'b1001;	// slli							=> SHIFT_LEFT (funct3==3'b001)
			12'b10_101_0000000 :	ALU_ctl =	4'b1010;	// srli							=> SHIFT_RIGHT (funct3==3'b101)
			default : ALU_ctl = 4'bx;
		endcase
	end

									
endmodule

//////////////////////////////////////////////////////////////////////////////////
module ALU(
	input [3:0] ALU_ctl,
	input [31:0] in1, in2,
	output reg [31:0] out,
	output zero
	);
	
	always @(*) begin
		case (ALU_ctl)
			4'b0000 :	out = in1 & in2;				// and
			4'b0001 :	out = in1 | in2;				// or
			4'b0010 :	out = in1 + in2;				// add
			4'b0110 :	out = in1 - in2;				// sub
			4'b0111 :	out = in1 < in2 ? 32'b0 : 32'b1;	// blt (branch if less than)
			4'b1000 :	out = in1 >= in2 ? 32'b0 : 32'b1;	// bge (branch if greater equal) 
			// blt,bgezero=1?만들긄해out=0?로 ?팅  
			4'b1100 :	out = ~(in1 | in2);			// nor
			4'b1001 :	out = in1 << in2;				// shift left
			4'b1010 :	out = in1 >> in2;				// shift right
			default :	out = 32'b0;
		endcase
	end
						
	assign zero = 	~|out;	//(ALU_ctl == 4'b0110) 			/ zero?? beq,bne ??? ????
									//(ALU_ctl == 4'b0111&1000) 	/blt,bge ==> mem stage???? zero?? branch signal?? branch ???? ??????.
endmodule
		