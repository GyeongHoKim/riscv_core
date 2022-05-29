`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:41:04 05/12/2022 
// Design Name: 
// Module Name:    RISCVpipeline 
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
module RISCVpipeline(
	
	output [31:0] current_pc,
	output [31:0] instruction,

	input clk, rst
	);
	wire c;
	wire [4:0]	ind_rs1, ind_rs2;
	wire [1:0]	ForwardA, ForwardB;
	wire			stall;
	wire [1:0] LED_clk;
	wire [31:0] pc, ins, exe_pc, mem_pc;
	wire ind_ctl_0, ind_ctl_1, ind_ctl_2, ind_ctl_3, ind_ctl_4, ind_ctl_5, ind_ctl_6, ind_ctl_7;
	wire exe_ctl_0, exe_ctl_1, exe_ctl_2, exe_ctl_3, exe_ctl_4, exe_ctl_5, exe_ctl_6, exe_ctl_7;
	wire mem_ctl_0, mem_ctl_1, mem_ctl_2, mem_ctl_3, mem_ctl_4, mem_ctl_5, mem_ctl_6, mem_ctl_7;
	wire wb_ctl_0,  wb_ctl_1,  wb_ctl_2,  wb_ctl_3,  wb_ctl_4,  wb_ctl_5,  wb_ctl_6,  wb_ctl_7;
	
	wire [31:0]  ind_pc;
   wire [31:0]	 ind_data1, ind_data2, ind_imm,	exe_data2, exe_addr, exe_result, mem_addr, mem_result, mem_data, wb_data;
	wire [4:0]	 ind_rd, exe_rd, mem_rd, wb_rd;
	wire [6:0]	 ind_funct7;
	wire [2:0]	 ind_funct3;
	wire 		ind_jal, ind_jalr, exe_jal, exe_jalr, mem_jal, mem_jalr, exe_zero, mem_PCSrc, ind_auipc;
	
	
	
	assign current_pc = pc;
	assign instruction = ins;
////////////////////////
	Forwarding_unit A8_Forwarding_unit(
		.mem_Ctl_RegWrite_in(exe_ctl_5),
		.wb_Ctl_RegWrite_in(mem_ctl_5),
		.Rs1_in(ind_rs1),
		.Rs2_in(ind_rs2),
		.mem_Rd_in(exe_rd),
		.wb_Rd_in(wb_rd),
		.ForwardA_out(ForwardA),
		.ForwardB_out(ForwardB)
	);

////////////////////////
	Hazard_detection_unit A9_Hazard_detection_unit(
		.exe_Ctl_MemRead_in(ind_ctl_4),
		.Rd_in(ind_rd),
		.instruction_in(instruction[24:15]),
		.stall_out(stall)
	);
	
////////////////////////
	InFetch A1_InFetch(		
		.PCSrc(mem_PCSrc),
		.PCimm_in(mem_addr),
		.PC_out(pc),
		.instruction_out(ins),
		.reset(rst),
		.clk(clk),
		.PCWrite(stall)
	);					
////////////////////////
	InDecode A3_InDecode(
	.Ctl_ALUSrc_out(ind_ctl_7),
	.Ctl_MemtoReg_out(ind_ctl_6),
	.Ctl_RegWrite_out(ind_ctl_5),
	.Ctl_MemRead_out(ind_ctl_4),
	.Ctl_MemWrite_out(ind_ctl_3),
	.Ctl_Branch_out(ind_ctl_2),
	.Ctl_ALUOpcode0_out(ind_ctl_0),
	.Ctl_ALUOpcode1_out(ind_ctl_1),
	.WriteReg(wb_rd),
	.PC_in(current_pc),
	.instruction_in(ins),
	.WriteData(wb_data),
	.Rd_out(ind_rd),
	.Rs1_out(ind_rs1),
	.Rs2_out(ind_rs2),
	.PC_out(ind_pc),
	.ReadData1_out(ind_data1),
	.ReadData2_out(ind_data2),
	.Immediate_out(ind_imm),
	.funct7_out(ind_funct7),
	.funct3_out(ind_funct3),
	.jalr_out(ind_jalr),
	.jal_out(ind_jal),
	.auipc_out(ind_auipc),
	.clk(clk),
	.reset(rst),
	.Ctl_RegWrite_in(wb_ctl_5),
	.stall(stall),
	.flush(mem_PCSrc)
	);
////////////////////////
	Execution A4_Execution(
		.clk(clk),
		.reset(rst),
		.Ctl_ALUSrc_in(ind_ctl_7),
		.Ctl_MemtoReg_in(ind_ctl_6),
		.Ctl_RegWrite_in(ind_ctl_5),
		.Ctl_MemRead_in(ind_ctl_4),
		.Ctl_MemWrite_in(ind_ctl_3),
		.Ctl_Branch_in(ind_ctl_2),
		.Ctl_ALUOpcode0_in(ind_ctl_0),
		.Ctl_ALUOpcode1_in(ind_ctl_1),
		.Ctl_MemtoReg_out(exe_ctl_6),
		.Ctl_RegWrite_out(exe_ctl_5),
		.Ctl_MemRead_out(exe_ctl_4),
		.Ctl_MemWrite_out(exe_ctl_3),
		.Ctl_Branch_out(exe_ctl_2),
		.Rd_in(ind_rd),
		.Rd_out(exe_rd),
		.Immediate_in(ind_imm),
		.ReadData1_in(ind_data1),
		.ReadData2_in(ind_data2),
		.PC_in(ind_pc),
		.funct7_in(ind_funct7),
		.funct3_in(ind_funct3),
		.Zero_out(exe_zero),
		.ALUresult_out(exe_result),
		.PCimm_out(exe_addr),
		.ReadData2_out(exe_data2),
		.mem_data_in(exe_result),
		.wb_data_in(wb_data),
		.flush(mem_PCSrc),
		.jal_in(ind_jal),
		.jal_out(exe_jal),
		.jalr_in(ind_jalr),
		.jalr_out(exe_jalr),
		.ForwardA_in(ForwardA),
		.ForwardB_in(ForwardB),
		.PC_out(exe_pc)
	);
////////////////////////			
	Memory A6_Memory( 
		.reset(rst),
		.clk(clk),
		.Ctl_MemtoReg_in(exe_ctl_6),
		.Ctl_RegWrite_in(exe_ctl_5),
		.Ctl_MemRead_in(exe_ctl_4),
		.Ctl_MemWrite_in(exe_ctl_3),
		.Ctl_Branch_in(exe_ctl_2),
		.Ctl_MemtoReg_out(mem_ctl_6),
		.Ctl_RegWrite_out(mem_ctl_5),
		.Rd_in(exe_rd),
		.Rd_out(mem_rd),
		.Zero_in(exe_zero),
		.Write_Data(exe_data2),
		.ALUresult_in(exe_result),
		.PCimm_in(exe_addr),
		.PCSrc(mem_PCSrc),
		.Read_Data(mem_data),
		.ALUresult_out(mem_result),
		.PCimm_out(mem_addr),
		.jal_in(exe_jal),
		.jal_out(mem_jal),
		.jalr_in(exe_jalr),
		.jalr_out(mem_jalr),
		.PC_in(exe_pc)
	);
////////////////////////
	WB A7_WB(
		.Ctl_RegWrite_in(mem_ctl_5),
		.Ctl_MemtoReg_in(mem_ctl_6),
		.Ctl_RegWrite_out(wb_ctl_5),
		.Rd_in(mem_rd),
		.ReadDatafromMem_in(mem_data),
		.ALUresult_in(mem_result),
		.Rd_out(wb_rd),
		.WriteDatatoReg_out(wb_data),
		.jal_in(mem_jal),
		.jalr_in(mem_jalr),
		.PC_in(mem_pc)
	);
endmodule
