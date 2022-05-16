`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:17:41 03/26/2022 
// Design Name: 
// Module Name:    WB 
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
module WB(
	// control signal
	input 		Ctl_RegWrite_in, 	Ctl_MemtoReg_in,
	output reg 	Ctl_RegWrite_out, 
	//
	input 		[ 4:0] Rd_in,
	input 		[31:0] ReadDatafromMem_in, ALUresult_in,
	output reg 	[ 4:0] Rd_out,
	output reg 	[31:0] WriteDatatoReg_out
	);	

	always @(*) begin 
		CtlRegWrite_out <= Ctl_RegWrite_in;
		Rd_out <= Rd_in;
		
		WriteDatatoReg_out <= Ctl_MemtoReg_in ? ReadDatafromMem_in : ALUresult_in;
	end 
endmodule


	