`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:01:41 05/02/2022
// Design Name:   InDecode
// Module Name:   C:/Xilinx/14.7/fetch_decode/tb_InDecode.v
// Project Name:  fetch_decode
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: InDecode
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_InDecode;

	// Inputs
	reg Ctl_RegWrite_in;
	reg [4:0] WriteReg;
	reg [31:0] PC_in;
	reg [31:0] instruction_in;
	reg [31:0] WriteData;
	reg clk;
	reg reset;

	// Outputs
	wire Ctl_ALUSrc_out;
	wire Ctl_MemtoReg_out;
	wire Ctl_RegWrite_out;
	wire Ctl_MemRead_out;
	wire Ctl_MemWrite_out;
	wire Ctl_Branch_out;
	wire Ctl_ALUOpcode1_out;
	wire Ctl_ALUOpcode0_out;
	wire [4:0] Rd_out;
	wire [4:0] Rs1_out;
	wire [4:0] Rs2_out;
	wire [31:0] PC_out;
	wire [31:0] ReadData1_out;
	wire [31:0] ReadData2_out;
	wire [31:0] Immediate_out;
	wire [6:0] funct7_out;
	wire [2:0] funct3_out;
	wire jalr_out;
	wire jal_out;
	wire auipc_out;

	// Instantiate the Unit Under Test (UUT)
	InDecode uut (
		.Ctl_RegWrite_in(Ctl_RegWrite_in), 
		.Ctl_ALUSrc_out(Ctl_ALUSrc_out), 
		.Ctl_MemtoReg_out(Ctl_MemtoReg_out), 
		.Ctl_RegWrite_out(Ctl_RegWrite_out), 
		.Ctl_MemRead_out(Ctl_MemRead_out), 
		.Ctl_MemWrite_out(Ctl_MemWrite_out), 
		.Ctl_Branch_out(Ctl_Branch_out), 
		.Ctl_ALUOpcode1_out(Ctl_ALUOpcode1_out), 
		.Ctl_ALUOpcode0_out(Ctl_ALUOpcode0_out), 
		.WriteReg(WriteReg), 
		.PC_in(PC_in), 
		.instruction_in(instruction_in), 
		.WriteData(WriteData), 
		.Rd_out(Rd_out), 
		.Rs1_out(Rs1_out), 
		.Rs2_out(Rs2_out), 
		.PC_out(PC_out), 
		.ReadData1_out(ReadData1_out), 
		.ReadData2_out(ReadData2_out), 
		.Immediate_out(Immediate_out), 
		.funct7_out(funct7_out), 
		.funct3_out(funct3_out), 
		.jalr_out(jalr_out), 
		.jal_out(jal_out), 
		.auipc_out(auipc_out), 
		.clk(clk), 
		.reset(reset)
	);
	
	initial begin
		reset =1;
		#24 reset = 0;
	end
	
	initial begin
		clk =0;
		forever #5 clk = ~clk;
	end
	
	//Register에 값을 써줌으로 decode가 제대로 동작하는지 확인할 수 있음.
	initial begin
		WriteReg =0;
		#25 WriteReg = 1;
		#10 WriteReg = 2;
		#10 WriteReg = 3;
		#10 WriteReg = 4;
		#10 WriteReg = 5;
		#10 WriteReg = 6;
		#10 WriteReg = 7;
		#10 WriteReg = 8;
		#10 WriteReg = 9;
		#10 WriteReg = 10;
		#10 WriteReg = 11;
		#10 WriteReg = 12;
		#10 WriteReg = 13;
		#10 WriteReg = 14;
		#10 WriteReg = 15;
	end
	
	initial begin
		WriteData = 0;
		#25 WriteData = 3;
		#10 WriteData = 4;
		#10 WriteData = 5;
		#10 WriteData = 6;
		#10 WriteData = 7;
		#10 WriteData = 8;
		#10 WriteData = 9;
		#10 WriteData = 10;
		#10 WriteData = 11;
		#10 WriteData = 12;
		#10 WriteData = 13;
		#10 WriteData = 14;
		#10 WriteData = 15;
		#10 WriteData = 16;
		#10 WriteData = 17;
	end
	
	//.mem에 저장되어 있는 값들
	//원래는 InFetch에서 파일을 읽으며 자동으로 저장하지만 Decode만 시뮬레이션하기 위해 instruction을 직접 넣어준다.
	initial begin
		instruction_in = 32'bx;
		#175 instruction_in = 32'b0000000_00010_00001_000_01010_0110011;		//add 	x10, x1, x2
		#10 instruction_in = 32'b0100000_01010_01011_000_01100_0110011;		//sub 	x12, x11, x10
		#10 instruction_in = 32'b0000000_00100_00000_000_01010_0010011;		//addi	x10, x0, 4
		#10 instruction_in = 32'b0000_0000_0110_00011_010_11111_0000011;		//lw		x15, 6(x3)
		#10 instruction_in = 32'b0000000_01100_00000_010_01001_0100011;		//sw		x12, 9(x0)
		#10 instruction_in = 32'b0_000000_00100_00101_001_0100_0_1100011;		//bne		x5, x4, 8
	end
	
	initial begin
		PC_in=32'bx;
		#175 PC_in = 0;
		#10 PC_in = 4;
		#10 PC_in = 8;
		#10 PC_in = 12;
		#10 PC_in = 16;
		#10 PC_in = 20;
	end
	
	initial begin
		Ctl_RegWrite_in =0;
		#25	 Ctl_RegWrite_in =1;
		#150	 Ctl_RegWrite_in =0;
	end
      
endmodule