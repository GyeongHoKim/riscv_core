`timescale 1ns / 1ps
module LED_channel(
	input [31:0] data,
	input [1:0] LED_clk,
	output reg [3:0] digit,
	output reg [7:0] fnd
    );
	 
	always@(*) begin
		case(segment)
			0: 		fnd[7:0] <= 8'b00000011; 	// 0
			1: 		fnd[7:0] <= 8'b10011111;  	// 1
			2: 		fnd[7:0] <= 8'b00100101;  	// 2
			3: 		fnd[7:0] <= 8'b00001101;  	// 3
			4: 		fnd[7:0] <= 8'b10011001;  	// 4
			5: 		fnd[7:0] <= 8'b01001001;  	// 5
			6: 		fnd[7:0] <= 8'b01000001;  	// 6
			7: 		fnd[7:0] <= 8'b00011111;  	// 7
			8: 		fnd[7:0] <= 8'b00000001;  	// 8
			9: 		fnd[7:0] <= 8'b00011001;  	// 9
			10:		fnd[7:0] <= 8'b00010001;	// A
			11:		fnd[7:0] <= 8'b11000001;	// b
			12:		fnd[7:0] <= 8'b11100101;	// c
			13:		fnd[7:0] <= 8'b10000101;	// d
			14:		fnd[7:0] <= 8'b01100001;	// E
			15:		fnd[7:0] <= 8'b01110001;	// F
			default: fnd[7:0] <= 8'b11111111; 	// none
		endcase
	end
	reg [4:0] segment;
	always@(*) begin
		// 1 �ڸ���
		if(LED_clk == 2'b00) begin 
			digit[3:0] = 4'b1110;
			segment = data[3:0];
		end
		// 10 �ڸ���
		else if(LED_clk == 2'b01) begin 
			digit[3:0] = 4'b1101; 
			segment = data[7:4];
		end
		// 100 �ڸ���
		else if(LED_clk == 2'b10) begin 
			digit[3:0] = 4'b1011;
			segment = data[11:8];
		end
		// 1000 �ڸ���
		else begin	
			digit[3:0] = 4'b0111;
			segment = data[15:12];
		end
	end
endmodule
