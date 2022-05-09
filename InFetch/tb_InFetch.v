`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:42:15 05/02/2022
// Design Name:   InFetch
// Module Name:   C:/Xilinx/14.7/fetch_decode/tb_InFetch.v
// Project Name:  fetch_decode
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: InFetch
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_InFetch;

	// Inputs
	reg clk;
	reg reset;
	reg PCSrc;
	reg [31:0] PCimm_in;

	// Outputs
	wire [31:0] instruction_out;
	wire [31:0] PC_out;

	// Instantiate the Unit Under Test (UUT)
	InFetch uut (
		.clk(clk), 
		.reset(reset), 
		.PCSrc(PCSrc), 
		.PCimm_in(PCimm_in), 
		.instruction_out(instruction_out), 
		.PC_out(PC_out)
	);

	initial begin
		reset =1;
		#24 reset = 0;
	end
	
	initial begin
		clk =0;
		forever #5 clk = ~clk;
	end
	
	initial begin
		PCSrc =0;
		#70 PCSrc = 1;
		#10 PCSrc = 0;
	end
	
	initial begin
		PCimm_in = 0;
		#15 PCimm_in = 44;
		#10 PCimm_in = 488;
		#10 PCimm_in = 16;
		#10 PCimm_in = 100;
		#10 PCimm_in = 64;
		#10 PCimm_in = 72;
		#10 PCimm_in = 12;
		#10 PCimm_in = 40;
		#10 PCimm_in = 56;
		#10 PCimm_in = 88;
		#10 $stop;
	end
      
endmodule