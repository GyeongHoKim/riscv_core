`timescale 1ns / 1ps

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
		rst =0;
		#50 rst = 1;
		#50 rst = 0;
	end
	
	initial begin
		clk =0;
		forever #5 clk = ~clk;
	end
      
endmodule

