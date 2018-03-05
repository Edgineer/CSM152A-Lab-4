`timescale 1ns / 1ps

module segmentMapping(
input val_thous, input val_hun, input val_tens, input val_ones, 
output reg [7:0] segrep_thous, output reg [7:0] segrep_huns, 
output reg [7:0] segrep_tens, output reg [7:0] segrep_ones
);

always @* begin
	case(val_thous) // Represent '-', ' '
		4'b1010: segrep_thous = 7'b0111111; // '-'
		4'b1111: segrep_thous = 7'b1111111; // ' '
	endcase

	case(val_hun) // Represent '0-9', 't', ' '
		4'b0000: segrep_hun = 7'b1000000;
		4'b0001: segrep_hun = 7'b1111001;
		4'b0010: segrep_hun = 7'b0100100;
		4'b0011: segrep_hun = 7'b0110000;
		4'b0100: segrep_hun = 7'b0011001;
		4'b0101: segrep_hun = 7'b0010010;
		4'b0110: segrep_hun = 7'b0000010;
		4'b0111: segrep_hun = 7'b1111000;
		4'b1000: segrep_hun = 7'b0000000;
		4'b1001: segrep_hun = 7'b0010000;
		4'b1100: segrep_hun = 7'b0000111; // 't'
		4'b1111: segrep_hun = 7'b1111111; // ' '
	endcase

	case(val_tens) // Represent '0-9', 'P', 'I', ' '
		4'b0000: segrep_tens = 7'b1000000;
		4'b0001: segrep_tens = 7'b1111001;
		4'b0010: segrep_tens = 7'b0100100;
		4'b0011: segrep_tens = 7'b0110000;
		4'b0100: segrep_tens = 7'b0011001;
		4'b0101: segrep_tens = 7'b0010010;
		4'b0110: segrep_tens = 7'b0000010;
		4'b0111: segrep_tens = 7'b1111000;
		4'b1000: segrep_tens = 7'b0000000;
		4'b1001: segrep_tens = 7'b0010000;
		4'b1011: segrep_tens = 7'b0001100; // 'P'
		4'b1101: segrep_tens = 7'b1111001; // 'I'
		4'b1111: segrep_tens = 7'b1111111; // ' '
	endcase

	case(val_ones) // Represent '0-9', 'E', ' '
		4'b0000: segrep_ones = 7'b1000000;
		4'b0001: segrep_ones = 7'b1111001;
		4'b0010: segrep_ones = 7'b0100100;
		4'b0011: segrep_ones = 7'b0110000;
		4'b0100: segrep_ones = 7'b0011001;
		4'b0101: segrep_ones = 7'b0010010;
		4'b0110: segrep_ones = 7'b0000010;
		4'b0111: segrep_ones = 7'b1111000;
		4'b1000: segrep_ones = 7'b0000000;
		4'b1001: segrep_ones = 7'b0010000;
		4'b1110: segrep_ones = 7'b0000110; // 'E'
	endcase
end
endmodule