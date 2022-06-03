`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:17:08 03/26/2022 
// Design Name: 
// Module Name:    Memory 
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
module Memory( 
	input 	reset, clk, 
	// control signal
	input 		Ctl_MemtoReg_in, 	Ctl_RegWrite_in, 	Ctl_MemRead_in, 	Ctl_MemWrite_in, 	Ctl_Branch_in,
	output reg	Ctl_MemtoReg_out, Ctl_RegWrite_out,
	// bypass
	input 		[ 4:0] Rd_in,
	output reg 	[ 4:0] Rd_out,
	//
	input					 jal_in, jalr_in,
	input 				 Zero_in,
	input 		[31:0] Write_Data, ALUresult_in, PCimm_in, PC_in,
	output 				 PCSrc,

	output reg			 jal_out, jalr_out,
	output reg	[31:0] Read_Data, ALUresult_out,
	output reg		[31:0] PCimm_out, PC_out
   );
	reg [31:0] mem [127:0]; //32bit register 128 row created
	
	wire branch;
	//Branch:[4]
	or(branch, jalr_in, jal_in, Zero_in);
	and(PCSrc, Ctl_Branch_in, branch);
	
	integer i;
	//DataMemory 
	always @(posedge clk, posedge reset) begin  
		if(reset) begin
			for(i = 0; i < 128; i = i + 1) begin
				mem[i] <= 32'b0;
			end
			mem[22] <= 12;
		end
		
		Read_Data <= Ctl_MemRead_in ? mem[ALUresult_in] : 32'b0;
			
		if(Ctl_MemWrite_in) begin
			mem[ALUresult_in] <= Write_Data;
		end
	end
	
	// MEM/WB reg 
	always@(posedge clk) begin
		ALUresult_out <= ALUresult_in;
		Rd_out <= Rd_in;
		jalr_out <= reset ? 1'b0 : jalr_in;
		jal_out <= reset ? 1'b0 : jal_in;
		PC_out <= reset ? 1'b0 : PC_in;
		
		Ctl_MemtoReg_out <= Ctl_MemtoReg_in;
		Ctl_RegWrite_out <= Ctl_RegWrite_in;
		
		PCimm_out <= (jalr_in) ? ALUresult_in : PCimm_in;
	end
endmodule
