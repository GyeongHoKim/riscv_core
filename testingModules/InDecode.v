`timescale 1ns / 1ps
`define LUI     7'b01101_11      // lui   rd,imm[31:12]
`define AUIPC   7'b00101_11      // auipc rd,imm[31:12]
`define JAL     7'b11011_11      // jal   rd,imm[xxxxx]
`define JALR    7'b11001_11      // jalr  rd,rs1,imm[11:0] 
`define BCC     7'b11000_11      // bcc   rs1,rs2,imm[12:1]
`define LCC     7'b00000_11      // lxx   rd,rs1,imm[11:0]
`define SCC     7'b01000_11      // sxx   rs1,rs2,imm[11:0]
`define MCC     7'b00100_11      // xxxi  rd,rs1,imm[11:0]
`define RCC     7'b01100_11      // xxx   rd,rs1,rs2 
`define MAC     7'b11111_11      // mac   rd,rs1,rs2


module InDecode(
	input	clk, reset,
	// data hazard
	input	stall,
	// control hazard
	input flush,
	
	// control signal
	output reg Ctl_ALUSrc_out, Ctl_MemtoReg_out, Ctl_RegWrite_out, Ctl_MemRead_out, Ctl_MemWrite_out, Ctl_Branch_out, Ctl_ALUOpcode1_out, Ctl_ALUOpcode0_out,
	//
	input 		[ 4:0] WriteReg, 
	input 		[31:0] PC_in, instruction_in, WriteData,
	
	output reg 	[ 4:0] Rd_out, Rs1_out, Rs2_out,
	output reg 	[31:0] PC_out, ReadData1_out, ReadData2_out, Immediate_out,
	output reg  [ 6:0] funct7_out, 	// RISC-V
	output reg 	[ 2:0] funct3_out,	// RISC-V
	output reg 			 jalr_out, jal_out, auipc_out,
	
	input					 Ctl_RegWrite_in
	);	
	
	wire [6:0]	opcode = instruction_in[6:0];
	wire [6:0]	funct7 = instruction_in[31:25];
	wire [2:0]	funct3 = instruction_in[14:12];
	wire [4:0]	Rd		 = instruction_in[11:7];
	wire [4:0]	Rs1	 = instruction_in[19:15];
	wire [4:0]	Rs2	 = instruction_in[24:20];
	
	wire 		  	jalr 	 = (opcode==`JALR )?1:0;
	wire 		  	jal 	 = (opcode==`JAL  )?1:0;
	wire			auipc	 = (opcode==`AUIPC)?1:0;
	wire [7:0]	Ctl_out;
	
	// control unit RISC-V
	Control_unit B0 (.opcode(instruction_in[6:0]), .Ctl_out(Ctl_out), .reset(reset));
	reg [7:0] Control;
	always @(*) begin
		Control = flush || stall ? 1'b0 : Ctl_out;
	end

	
	//Register
	parameter reg_size = 32;
	reg [31:0] Reg[0:reg_size-1]; //32bit reg
	integer i, idx;
	always@(posedge clk) begin
		// input
		// 5bit Rs1, Rs2, WriteReg
		// 32bit write data
		if (reset) begin
			for (i = 0; i < 32; i = i + 1) begin
				Reg[i] <= 32'b0;
			end
			for (idx = 1; idx < 7; idx = idx + 1) begin
				Reg[idx] <= idx + 1;
			end
		end
			
		else if (Ctl_RegWrite_in && WriteReg != 0)
			Reg[WriteReg] <= WriteData;
		
		
	end
	
	//sign extention RISC-V
	reg [31:0] Immediate;
	always@(*) begin
		case(opcode)
			// I type - 1
			7'b0000011 : Immediate = $signed(instruction_in[31:20]);
			// I type - 2
			7'b0010011 : Immediate = $signed(instruction_in[31:20]);
			// jalr
			7'b1100111 : Immediate = $signed(instruction_in[31:20]);
			// S type
			7'b0100011 : Immediate = $signed({instruction_in[31:25], instruction_in[11:7]});
			// SB type
			7'b1100011 : Immediate = $signed({instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8]});
			// jal
			7'b1101111 : Immediate = $signed({instruction_in[31], instruction_in[19:12], instruction_in[20], instruction_in[30:21]});
			// auipc
			7'b0010111 : Immediate = $signed(instruction_in[31:12]);
			default	  : Immediate = 32'b0;
		endcase
		
	end
	
	//ID/EX reg
	always@(posedge clk) begin
		//output
		PC_out						<= reset ? 0 : PC_in;
		funct7_out					<= reset ? 0 : funct7;
		funct3_out					<= reset ? 0 : funct3;
		Rd_out						<= reset ? 0 : Rd;
		Rs1_out						<= reset ? 0 : Rs1;
		Rs2_out						<= reset ? 0 : Rs2;
		ReadData1_out 				<= reset ? 0 : Ctl_RegWrite_in && WriteReg == Rs1 ? WriteData : Reg[Rs1];
		ReadData2_out 				<= reset ? 0 : Ctl_RegWrite_in && WriteReg == Rs2 ? WriteData : Reg[Rs2];
		jalr_out						<= reset ? 0 : jalr;
		jal_out						<= reset ? 0 : jal;
		auipc_out					<= reset ? 0 : auipc;
		Ctl_ALUSrc_out				<= reset ? 0 : Control[7];
		Ctl_MemtoReg_out			<= reset ? 0 : Control[6];
		Ctl_RegWrite_out			<= reset ? 0 : Control[5];
		Ctl_MemRead_out			<= reset ? 0 : Control[4];
		Ctl_MemWrite_out			<= reset ? 0 : Control[3];
		Ctl_Branch_out				<= reset ? 0 : Control[2];
		Ctl_ALUOpcode1_out		<= reset ? 0 : Control[1];
		Ctl_ALUOpcode0_out		<= reset ? 0 : Control[0];
		Immediate_out				<= reset ? 0 : Immediate;
	end


endmodule

module Control_unit(
	input [6:0] opcode,
	input reset,
	output reg [7:0] Ctl_out
	);

	always @(*) begin	
		if (reset)
			Ctl_out = 8'b0;
		else
			case(opcode)
				7'b01100_11 : Ctl_out = 8'b001000_10;
				7'b00100_11 : Ctl_out = 8'b101000_11;
				7'b00000_11 : Ctl_out = 8'b111100_00;
				7'b01000_11 : Ctl_out = 8'b100010_00;
				7'b11000_11 : Ctl_out = 8'b000001_01;
				7'b11011_11 : Ctl_out = 8'b001001_00;
				7'b11001_11 : Ctl_out = 8'b101001_11;
				7'b00101_11 : Ctl_out = 8'b101000_00;
				default 		: Ctl_out = 8'b0;
			endcase
	end
endmodule