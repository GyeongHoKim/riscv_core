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
	input 				 Zero_in,
	input 		[31:0] Write_Data, ALUresult_in, PCimm_in,
	output 				 PCSrc,

	output reg	[31:0] Read_Data, ALUresult_out,
	output 		[31:0] PCimm_out
   );
	reg [31:0] mem [127:0]; //32bit register 128 row created
	
	//Branch:[4]
	and(PCSrc, Ctl_Branch_in, Zero_in);
	
	integer i;
	//DataMemory 
	always @(posedge clk, posedge reset) begin  
		if(reset) begin
			mem[42] <=123;
			mem[50] <=321;
		end
		if(Ctl_MemRead_in) begin
			Read_Data <= mem[ALUresult_in];
		end
		if(Ctl_MemWrite_in) begin
			mem[ALUresult_in] <= Write_Data;
		end

	end
	
	// MEM/WB reg 
	always@(posedge clk) begin
		ALUresult_out <= ALUresult_in;
		Rd_out <= Rd_in;
		Ctl_MemtoReg_out <= Ctl_MemtoReg_in;
		Ctl_RegWrite_out <= Ctl_RegWrite_in;
	end
	assign PCimm_out = PCimm_in;
endmodule
