`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:43:11 05/12/2022
// Design Name:   Memory
// Module Name:   C:/Xilinx/14.7/fetch_decode/tb_Memory.v
// Project Name:  fetch_decode
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Memory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_Memory;

	// Inputs
	reg reset;
	reg clk;
	reg Ctl_MemtoReg_in;
	reg Ctl_RegWrite_in;
	reg Ctl_MemRead_in;
	reg Ctl_MemWrite_in;
	reg Ctl_Branch_in;
	reg [4:0] Rd_in;
	reg Zero_in;
	reg [31:0] Write_Data;
	reg [31:0] ALUresult_in;
	reg [31:0] PCimm_in;

	// Outputs
	wire Ctl_MemtoReg_out;
	wire Ctl_RegWrite_out;
	wire [4:0] Rd_out;
	wire PCSrc;
	wire [31:0] Read_Data;
	wire [31:0] ALUresult_out;
	wire [31:0] PCimm_out;

	// Instantiate the Unit Under Test (UUT)
	Memory uut (
		.reset(reset), 
		.clk(clk), 
		.Ctl_MemtoReg_in(Ctl_MemtoReg_in), 
		.Ctl_RegWrite_in(Ctl_RegWrite_in), 
		.Ctl_MemRead_in(Ctl_MemRead_in), 
		.Ctl_MemWrite_in(Ctl_MemWrite_in), 
		.Ctl_Branch_in(Ctl_Branch_in), 
		.Ctl_MemtoReg_out(Ctl_MemtoReg_out), 
		.Ctl_RegWrite_out(Ctl_RegWrite_out), 
		.Rd_in(Rd_in), 
		.Rd_out(Rd_out), 
		.Zero_in(Zero_in), 
		.Write_Data(Write_Data), 
		.ALUresult_in(ALUresult_in), 
		.PCimm_in(PCimm_in), 
		.PCSrc(PCSrc), 
		.Read_Data(Read_Data), 
		.ALUresult_out(ALUresult_out), 
		.PCimm_out(PCimm_out)
	);

	initial begin
		$dumpfile("Memory.vcd");
		$dumpvars(0,tb_Memory);
	end
	
	initial begin
		reset =1;
		#24 reset = 0;
	end
	
	initial begin
		clk =0;
		forever #5 clk = ~clk;
	end
	
	initial begin
		Ctl_MemtoReg_in = 0;
		Ctl_RegWrite_in = 0;
		Rd_in = 0;
	end
	
	initial begin
		Ctl_MemRead_in = 0;
		#25 Ctl_MemRead_in = 0;
		#10 Ctl_MemRead_in = 0;
		#10 Ctl_MemRead_in = 0;
		#10 Ctl_MemRead_in = 1;
		#10 Ctl_MemRead_in = 1;
		#10 Ctl_MemRead_in = 1;
		#10 Ctl_MemRead_in = 0;
		#10 Ctl_MemRead_in = 0;
		#10 Ctl_MemRead_in = 0;
	end
	
	initial begin
		Ctl_MemWrite_in = 0;
		#25 Ctl_MemWrite_in = 1;
		#10 Ctl_MemWrite_in = 1;
		#10 Ctl_MemWrite_in = 1;
		#10 Ctl_MemWrite_in = 0;
		#10 Ctl_MemWrite_in = 0;
		#10 Ctl_MemWrite_in = 0;
		#10 Ctl_MemWrite_in = 0;
		#10 Ctl_MemWrite_in = 0;
		#10 Ctl_MemWrite_in = 0;
	end
	
	initial begin
		Ctl_Branch_in = 0;
		#25 Ctl_Branch_in = 0;
		#10 Ctl_Branch_in = 0;
		#10 Ctl_Branch_in = 0;
		#10 Ctl_Branch_in = 0;
		#10 Ctl_Branch_in = 0;
		#10 Ctl_Branch_in = 0;
		#10 Ctl_Branch_in = 1;
		#10 Ctl_Branch_in = 1;
		#10 Ctl_Branch_in = 1;
	end
	
	initial begin
		Zero_in = 0;
		#25 Zero_in = 0;
		#10 Zero_in = 0;
		#10 Zero_in = 0;
		#10 Zero_in = 0;
		#10 Zero_in = 0;
		#10 Zero_in = 0;
		#10 Zero_in = 0;	//beq
		#10 Zero_in = 0;	//blt
		#10 Zero_in = 1;	//bge
	end
	
	initial begin
		Write_Data = 0;
		#25 Write_Data = 4;	//x2
		#10 Write_Data = 5;	//x3
		#10 Write_Data = 6;	//x4
		#10 Write_Data = 0;
		#10 Write_Data = 0;
		#10 Write_Data = 0;
		#10 Write_Data = 0;
		#10 Write_Data = 0;
		#10 Write_Data = 0;
	end

	initial begin
		ALUresult_in = 0;
		#25 ALUresult_in = 17;	//[x3+12] = 17
		#10 ALUresult_in = 12;	//[x2+8] = 12
		#10 ALUresult_in = 7;	//[x1+4] = 7
		#10 ALUresult_in = 17;
		#10 ALUresult_in = 12;
		#10 ALUresult_in = 7;
		#10 ALUresult_in = 0;
		#10 ALUresult_in = 0;
		#10 ALUresult_in = 0;
	end
	
	initial begin
		PCimm_in = 0;
		#25 PCimm_in = 0;		//���� pc=0
		#10 PCimm_in = 0;		//���� pc=4
		#10 PCimm_in = 0;		//���� pc=8
		#10 PCimm_in = 0;		//���� pc=12
		#10 PCimm_in = 0;		//���� pc=16
		#10 PCimm_in = 0;		//���� pc=20
		#10 PCimm_in = 32;	//���� pc=24 / 24+Imm(8)=32
		#10 PCimm_in = 32;	//���� pc=28 / 28+Imm(4)=32
		#10 PCimm_in = 44;	//���� pc=32 / 32+Imm(12)=44
	end
		
      
endmodule

