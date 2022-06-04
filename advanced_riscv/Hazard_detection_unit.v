`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:51 05/27/2022 
// Design Name: 
// Module Name:    Hazard_detection_unit 
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
module Hazard_detection_unit(
	input			exe_Ctl_MemRead_in,
	input	[4:0]	Rd_in,
	input	[9:0]	instruction_in,
	output		stall_out
	);
	
	wire [4:0] Rs1_in = instruction_in[4:0];
	wire [4:0] Rs2_in = instruction_in[9:5];

	assign stall_out = (exe_Ctl_MemRead_in && ((Rd_in == Rs1_in) || (Rd_in == Rs2_in))) ? 1 : 0;

endmodule
