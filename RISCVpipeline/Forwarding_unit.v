`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:03 05/27/2022 
// Design Name: 
// Module Name:    Forwarding_unit 
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
module Forwarding_unit(
	input mem_Ctl_RegWrite_in, wb_Ctl_RegWrite_in,
	input [4:0] Rs1_in, Rs2_in, mem_Rd_in, wb_Rd_in,
	output [1:0] ForwardA_out, ForwardB_out
    );
	 
	assign ForwardA_out 	= (mem_Ctl_RegWrite_in && (mem_Rd_in == Rs1_in)) ? 2'b10 : 
								  (wb_Ctl_RegWrite_in && (wb_Rd_in == Rs1_in)) ? 2'b01 : 2'b00;
	
	assign ForwardB_out 	= (mem_Ctl_RegWrite_in && (mem_Rd_in == Rs2_in)) ? 2'b10 : 
								  (wb_Ctl_RegWrite_in && (wb_Rd_in == Rs2_in)) ? 2'b01 : 2'b00;


endmodule
