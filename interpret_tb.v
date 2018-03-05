`timescale 1ns / 1ps

module interpretRand_tb;

	//Inputs
	reg [7:0] data;
	reg mode;

	//Outputs
	wire [7:0] val;
	wire neg;

	// Instantiate the Unit Under Test (UUT)
	interpretVal uut (
		.data(data),
		.mode(mode),
		.val(val),
		.neg(neg)
	);

	initial begin
	 mode = 1;
	 data = 0;
	 #10;
	 data = 8'b01111111;
	 #10;
	 data = 8'b10010100;
	 #10;
	 data = 8'b00000000;
	 #10;
	 data = 8'b11111111;
	 #10;
	 data = 8'b01111011;
	 #10;
	 data = 8'b10011010;
	 $finish;
	end
endmodule