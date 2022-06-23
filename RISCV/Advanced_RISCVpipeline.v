`timescale 1ns / 1ps
`include "./config.vh"


module Advanced_RISCVpipeline(
	
`ifndef simulation
	input 	[ 4:0] key,
	input	 	[ 5:0] Switch,
	output 	[ 3:0] digit,
	output 	[ 7:0] fnd,
	output 	[15:0] LED,
`endif
	/////////////////////////////////////
	input 		  clk, rst
	);
	wire 			c;
	wire [ 1:0] LED_clk;
	
	wire [31:0] inf_pc;
	wire [31:0] inf_ins;
	
	wire [ 7:0] ind_ctl;
	wire [31:0] ind_pc;
	wire [ 4:0] ind_rs1;
	wire [ 4:0] ind_rs2;
	wire [ 4:0] ind_rd;
	wire [31:0] ind_data1;
	wire [31:0] ind_data2;
	wire [31:0] ind_imm;
	wire [ 6:0] ind_f7;
	wire [ 2:0] ind_f3;
	wire 	  		ind_jalr;
	wire 			ind_jal;
	wire 			ind_auipc;
	
	wire [ 5:1] exe_ctl;
	wire [31:0] exe_pc;
	wire [ 4:0] exe_rd;
	wire [31:0] exe_data;
	wire [31:0] exe_addr;
	wire [31:0] exe_result;
	wire 			exe_zero;
	wire [ 6:0] exe_f7;
	wire [ 2:0] exe_f3;
	wire 			exe_jalr;
	wire 			exe_jal;
	
	wire [ 2:1] mem_ctl;
	wire [31:0] mem_pc;
	wire [ 4:0] mem_rd;
	wire [31:0] mem_data;
	wire [31:0] mem_addr;
	wire [31:0] mem_result;
	wire 			mem_jalr;
	wire 			mem_jal;
	wire 			mem_flush;
	wire 			mem_PCSrc;
	
	wire 			wb_ctl;
	wire [ 4:0] wb_rd;
	wire [31:0] wb_data;
	
	wire 			hzd_stall;
	wire [ 1:0] fwd_A;
	wire [ 1:0] fwd_B;	
	
`ifdef simulation
	wire	[31:0] data = clk_count;
	wire 	[31:0] RAM_address = exe_result;
`else
	assign 		 LED = {pass, data[30:16]};
	wire	[31:0] clk_address, clk_count;
	wire 	[31:0] data = (key[1])? mem_data : clk_count;
	wire 	[31:0] RAM_address = (key[1]) ? (clk_address<<2) : exe_result;
`endif
	
//////////////////////////////////////////////////////////////////////////////////////
	LED_channel LED0(
	.data(data),							.digit(digit),
	.LED_clk(LED_clk),					.fnd(fnd));
//////////////////////////////////////////////////////////////////////////////////////
	counter A0_counter(
`ifndef simulation
	.key1(key[1]),
	.mem_data(mem_data),
	.pass(pass),
	.clk_address(clk_address),
	
	.Switch(Switch),
`endif
	
	.clk(clk),								.LED_clk(LED_clk),
	.rst(rst),								.clk_out(c),
	.pc_in(inf_pc),						.clk_count_out(clk_count));
//////////////////////////////////////////////////////////////////////////////////////
	InFetch A1_InFetch(
	.PCSrc(mem_PCSrc),					
	.PCWrite(hzd_stall), 				
//-----------------------------------------------------------------------------------
	.PCimm_in(mem_addr),
	.PC_out(inf_pc),
	.instruction_out(inf_ins),
	.reset(rst),
	.clk(c));					
//////////////////////////////////////////////////////////////////////////////////////
	InDecode A2_InDecode(
												.Ctl_ALUSrc_out(ind_ctl[0]),
												.Ctl_MemtoReg_out(ind_ctl[1]),
	.Ctl_RegWrite_in(wb_ctl),			.Ctl_RegWrite_out(ind_ctl[2]),
												.Ctl_MemRead_out(ind_ctl[3]),
												.Ctl_MemWrite_out(ind_ctl[4]),
												.Ctl_Branch_out(ind_ctl[5]),
												.Ctl_ALUOpcode1_out(ind_ctl[6]),
												.Ctl_ALUOpcode0_out(ind_ctl[7]),
//-----------------------------------------------------------------------------------
	.stall(hzd_stall), 					
	.flush(mem_flush), 					
												.Rs1_out(ind_rs1),	
												.Rs2_out(ind_rs2),	
//-----------------------------------------------------------------------------------
	.PC_in(inf_pc),						.PC_out(ind_pc),
												.jalr_out(ind_jalr),
												.jal_out(ind_jal),
												.auipc_out(ind_auipc),
//-----------------------------------------------------------------------------------									
	.instruction_in(inf_ins),			.ReadData1_out(ind_data1),
												.ReadData2_out(ind_data2),
												.Immediate_out(ind_imm),
												.Rd_out(ind_rd),
												.funct7_out(ind_f7),
	.WriteReg(wb_rd),						.funct3_out(ind_f3),
	.WriteData(wb_data),					

	.reset(rst),
	.clk(c));
//////////////////////////////////////////////////////////////////////////////////////
	Execution A3_Execution(	
	.Ctl_ALUSrc_in(ind_ctl[0]),		//.Ctl_ALUSrc_out(exe_ctl[0]),
	.Ctl_MemtoReg_in(ind_ctl[1]),		.Ctl_MemtoReg_out(exe_ctl[1]),
	.Ctl_RegWrite_in(ind_ctl[2]),		.Ctl_RegWrite_out(exe_ctl[2]),
	.Ctl_MemRead_in(ind_ctl[3]),		.Ctl_MemRead_out(exe_ctl[3]),	
	.Ctl_MemWrite_in(ind_ctl[4]),		.Ctl_MemWrite_out(exe_ctl[4]),
	.Ctl_Branch_in(ind_ctl[5]),		.Ctl_Branch_out(exe_ctl[5]),
	.Ctl_ALUOpcode1_in(ind_ctl[6]),	//.Ctl_ALUOpcode1_out(exe_ctl[6]),
	.Ctl_ALUOpcode0_in(ind_ctl[7]),	//.Ctl_ALUOpcode0_out(exe_ctl[7]),
//-----------------------------------------------------------------------------------
	.ForwardA_in(fwd_A),  					
	.ForwardB_in(fwd_B),  					
	.mem_data_in(exe_result),			
	.wb_data_in(wb_data),		
	.flush(mem_flush),					
//-----------------------------------------------------------------------------------
												.PCimm_out(exe_addr),
												.Zero_out(exe_zero),
												.ALUresult_out(exe_result),
												
	.PC_in(ind_pc),						.PC_out(exe_pc),
	.jalr_in(ind_jalr),					.jalr_out(exe_jalr),
	.jal_in(ind_jal),						.jal_out(exe_jal),
	.auipc_in(ind_auipc),	
						
	.ReadData1_in(ind_data1),
	.ReadData2_in(ind_data2),			.ReadData2_out(exe_data),
	.Immediate_in(ind_imm),
	.Rd_in(ind_rd),						.Rd_out(exe_rd),
	.funct7_in(ind_f7),					.funct7_out(exe_f7),	
	.funct3_in(ind_f3),					.funct3_out(exe_f3),
						
	.reset(rst),
	.clk(c));
//////////////////////////////////////////////////////////////////////////////////////				
	Memory A4_Memory( 		
	//.Ctl_ALUSrc_in(exe_ctl[0]),		.Ctl_ALUSrc_out(mem_ctl[0]),
	.Ctl_MemtoReg_in(exe_ctl[1]),		.Ctl_MemtoReg_out(mem_ctl[1]),
	.Ctl_RegWrite_in(exe_ctl[2]),		.Ctl_RegWrite_out(mem_ctl[2]),
	.Ctl_MemRead_in(exe_ctl[3]),		//.Ctl_MemRead_out(mem_ctl[3]),
	.Ctl_MemWrite_in(exe_ctl[4]),		//.Ctl_MemWrite_out(mem_ctl[4]),
	.Ctl_Branch_in(exe_ctl[5]),		//.Ctl_Branch_out(mem_ctl[5]),
	//.Ctl_ALUOpcode1_in(exe_ctl[6]),.Ctl_ALUOpcode1_out(mem_ctl[6]),
	//.Ctl_ALUOpcode0_in(exe_ctl[7]),.Ctl_ALUOpcode0_out(mem_ctl[7]),	
//-----------------------------------------------------------------------------------
	.PC_in(exe_pc),						.PC_out(mem_pc),
	.jalr_in(exe_jalr),					.jalr_out(mem_jalr),
	.jal_in(exe_jal),						.jal_out(mem_jal),
	.funct7_in(exe_f7),					.flush(mem_flush),
	.funct3_in(exe_f3),
						
	.PCimm_in(exe_addr),				.PCimm_out(mem_addr),
	.Zero_in(exe_zero),					.PCSrc(mem_PCSrc),
	.ALUresult_in(RAM_address),		.ALUresult_out(mem_result),
	.Write_Data(exe_data),				.Read_Data(mem_data),
	.Rd_in(exe_rd),						.Rd_out(mem_rd),
	
	.reset(rst), 
	.clk(c));
//////////////////////////////////////////////////////////////////////////////////////
	WB A5_WB(
	//.Ctl_ALUSrc_in(mem_ctl[0]),		.Ctl_ALUSrc_out(wb_ctl[0]),
	.Ctl_MemtoReg_in(mem_ctl[1]),		//.Ctl_MemtoReg_out(wb_ctl[1]),
	.Ctl_RegWrite_in(mem_ctl[2]),		.Ctl_RegWrite_out(wb_ctl),
	//.Ctl_MemRead_in(mem_ctl[3]),	.Ctl_MemRead_out(wb_ctl[3]),
	//.Ctl_MemWrite_in(mem_ctl[4]),	.Ctl_MemWrite_out(wb_ctl[4]),
	//.Ctl_Branch_in(mem_ctl[5]),		.Ctl_Branch_out(wb_ctl[5]),
	//.Ctl_ALUOpcode1_in(mem_ctl[6]),.Ctl_ALUOpcode1_out(wb_ctl[6]),
	//.Ctl_ALUOpcode0_in(mem_ctl[7]),.Ctl_ALUOpcode0_out(wb_ctl[7]),			
//-----------------------------------------------------------------------------------		
	.PC_in(mem_pc),
	.jalr_in(mem_jalr),
	.jal_in(mem_jal),
						
	.ReadDatafromMem_in(mem_data),	.WriteDatatoReg_out(wb_data), 
	.ALUresult_in(mem_result),
	.Rd_in(mem_rd),						.Rd_out(wb_rd) 					
	);
//////////////////////////////////////////////////////////////////////////////////////
	Forwarding_unit A6_Forwarding (
	.mem_Ctl_RegWrite_in(exe_ctl[2]),
	.wb_Ctl_RegWrite_in(mem_ctl[2]),
						
	.Rs1_in(ind_rs1),
	.Rs2_in(ind_rs2),
	.mem_Rd_in(exe_rd),
	.wb_Rd_in(mem_rd),
						
												.ForwardA_out(fwd_A),
												.ForwardB_out(fwd_B)
	);
//////////////////////////////////////////////////////////////////////////////////////
	Hazard_detection_unit A7_Hazard (
	.exe_Ctl_MemRead_in(ind_ctl[3]),
	.Rd_in(ind_rd),
	.instruction_in(inf_ins[24:15]),
												.stall_out(hzd_stall)
	);
												
endmodule