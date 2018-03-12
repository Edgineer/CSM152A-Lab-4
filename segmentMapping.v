`timescale 1ns / 1ps

module segmentMapping(
input [3:0] val_thous, input [3:0] val_hun, input [3:0] val_tens, input [3:0] val_ones, 
output reg [7:0] segrep_thous, output reg [7:0] segrep_huns, 
output reg [7:0] segrep_tens, output reg [7:0] segrep_ones
);

always @* begin
	case(val_thous) // Represent '-', ' '
		4'b1010: segrep_thous = 8'b10111111; // '-'
		default: segrep_thous = 8'b11111111; // ' '
	endcase
	
	case(val_hun) // Represent '0-9', 't', ' '
		4'b0000: segrep_huns = 8'b11000000;
		4'b0001: segrep_huns = 8'b11111001;
		4'b0010: segrep_huns = 8'b10100100;
		4'b0011: segrep_huns = 8'b10110000;
		4'b0100: segrep_huns = 8'b10011001;
		4'b0101: segrep_huns = 8'b10010010;
		4'b0110: segrep_huns = 8'b10000010;
		4'b0111: segrep_huns = 8'b11111000;
		4'b1000: segrep_huns = 8'b10000000;
		4'b1001: segrep_huns = 8'b10010000;
		4'b1100: segrep_huns = 8'b10000111; // 't'
		4'b1111: segrep_huns = 8'b11111111; // ' '
	endcase

	case(val_tens) // Represent '0-9', 'P', 'I', ' '
		4'b0000: segrep_tens = 8'b11000000;
		4'b0001: segrep_tens = 8'b11111001;
		4'b0010: segrep_tens = 8'b10100100;
		4'b0011: segrep_tens = 8'b10110000;
		4'b0100: segrep_tens = 8'b10011001;
		4'b0101: segrep_tens = 8'b10010010;
		4'b0110: segrep_tens = 8'b10000010;
		4'b0111: segrep_tens = 8'b11111000;
		4'b1000: segrep_tens = 8'b10000000;
		4'b1001: segrep_tens = 8'b10010000;
		4'b1011: segrep_tens = 8'b10001100; // 'P'
		4'b1101: segrep_tens = 8'b11111001; // 'I'
		4'b1111: segrep_tens = 8'b11111111; // ' '
	endcase

	case(val_ones) // Represent '0-9', 'E', ' '
		4'b0000: segrep_ones = 8'b11000000;
		4'b0001: segrep_ones = 8'b11111001;
		4'b0010: segrep_ones = 8'b10100100;
		4'b0011: segrep_ones = 8'b10110000;
		4'b0100: segrep_ones = 8'b10011001;
		4'b0101: segrep_ones = 8'b10010010;
		4'b0110: segrep_ones = 8'b10000010;
		4'b0111: segrep_ones = 8'b11111000;
		4'b1000: segrep_ones = 8'b10000000;
		4'b1001: segrep_ones = 8'b10010000;
		4'b1110: segrep_ones = 8'b10000110; // 'E'
	endcase
end
endmodule