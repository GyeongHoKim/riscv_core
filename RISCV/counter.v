`timescale 1ns / 1ps
`include "./config.vh"

module counter(
	input 			 clk, rst,
	input 	[31:0] pc_in, // pc = 400�̸� sorting ���Ḧ �ǹ�
`ifndef simulation	//����
	input					 key1,
	input			[31:0] mem_data,
	output				 pass,
	output		[31:0] clk_address,
	
	input			[ 5:0] Switch,
`endif
	
	output 	[ 1:0] LED_clk,
	output 			 clk_out,
	output	[31:0] clk_count_out // sorting ����ɶ����� �ɸ� cycle
    );
	
`ifdef simulation
	assign clk_out = count[0];
`else 	//[27:0]�ֱ� 2^28(�� 268,000,000)�� �ø� FPGA ���ļ� 50MHz = 20ns => 5.36��
	assign clk_out =  (Switch==6'b111111) ? 0: 
							(Switch==6'b111110) ? count[24]:
							(Switch==6'b111100) ? count[20]:
							(Switch==6'b111000) ? count[16]:
							(Switch==6'b110000) ? count[12]:
							(Switch==6'b100000) ? count[8]:
							(Switch==6'b000000) ? count[4]:
														 0;
`endif
	assign LED_clk = led_count[13:12];

	reg [31:0] count = 0;
	reg [31:0] led_count = 0;
	always @(posedge clk) begin
		//if(rst) begin
		//	count <= 0;
		//	led_count <= 0;
		//end
		//else begin
			led_count <= led_count + 32'b1;
			count <= count + 32'b1;
		//end
	end
	
	reg 	[31:0] clk_count_out = 0;
	reg			 clk_count_stop = 0;
	always @(posedge clk_out) begin
		if(rst) begin
			clk_count_out <=  32'b0;
			clk_count_stop <= 1'b0;
		end
		else if (!clk_count_stop) begin
			clk_count_out <= clk_count_out + 32'b1;
			if(pc_in == 32'd400)
				clk_count_stop <= 1'b1;
		end
	end
	
`ifndef simulation //����
	reg 	[31:0] clk_address = 0;
	reg 			 pass = 0;
	reg	[31:0] pass_count = 0;
	always@(posedge clk_out) begin
		if(key1) begin
			if(!pass)begin
				clk_address <= clk_address + clk;
				if(mem_data==clk_address)
					pass_count <= pass_count + 1;
			end
			if(pass_count == 1000)
				pass <= 1;
		end
		else begin
			clk_address <= 0;
			pass_count <=0;
			pass <= 0;
		end
	end
`endif
endmodule
