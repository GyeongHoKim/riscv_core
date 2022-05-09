`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:13:50 03/26/2022 
// Design Name: 
// Module Name:    InFetch 
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

module InFetch(
	input 				 clk, reset,
	input 				 PCSrc, 		// control signal
	input 		[31:0] PCimm_in, // PC + imm 계산 값
	output	 	[31:0] instruction_out,
	output reg	[31:0] PC_out
   );
	wire 			[31:0] PC;
	wire			[31:0] PC4 = PC + 4;
	
	PC B1_PC(
	.clk(clk),
	.reset(reset),
	.PCSrc(PCSrc),
	.PCimm_in(PCimm_in),
	.PC_in(PC4),		.PC_out(PC));
	
	iMEM B2_iMEM(
	.clk(clk),
	.reset(reset),
	.IF_ID_Write(PCWrite),
	.PC_in(PC),	.instruction_out(instruction_out));

	//IF/ID reg
	always@(posedge clk) begin
		if(reset)		PC_out <= 0;
		else				PC_out <= PC;
	end

endmodule
//////////////////////////////////////////////////////////////////////////////////
module PC(
	input 				 clk, reset,
	input					 PCSrc,
	input			[31:0] PCimm_in,
	input 		[31:0] PC_in,
	output reg	[31:0] PC_out
	);
	always @(posedge clk) begin
		if(reset)			PC_out <= 0;
		else if(PCSrc)		PC_out <= PCimm_in;
		else					PC_out <= PC_in;

	end
endmodule
//////////////////////////////////////////////////////////////////////////////////
module iMEM(
	input 				 clk, reset,
	input					 IF_ID_Write,
	input			[31:0] PC_in,
	output reg	[31:0] instruction_out
	);
	parameter 			 ROM_size = 32;
	reg 			[31:0] ROM [0:ROM_size-1]; // 32bit ROM 생성
	

	integer i;
	initial begin
		for(i=0; i!=ROM_size; i=i+1) begin
			ROM[i] = 32'b0;
		end
		$readmemh("./darksocv.mem",ROM);
	end

	// Instruction Fetch (BRAM)
	always @(posedge clk) begin
		if(reset)					instruction_out <= 32'b0;
		else							instruction_out <= ROM[PC_in[31:2]];
	end

endmodule