`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:51:10 05/12/2022
// Design Name:   RISCVpipeline
// Module Name:   C:/Xilinx/14.7/fetch_decode/tb_RISCVpipeline.v
// Project Name:  fetch_decode
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RISCVpipeline
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_RISCVpipeline;

	// Inputs
	reg clk;
	reg rst;

	// Instantiate the Unit Under Test (UUT)
	Advanced_RISCVpipeline uut (
		.clk(clk), 
		.rst(rst)
	);

	initial begin
		rst =1;
		#54 rst = 0;
	end
	
	initial begin
		clk =0;
		forever #5 clk = ~clk;
	end
      
endmodule

