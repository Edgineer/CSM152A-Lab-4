`timescale 1ns / 1ps

module top_prestage_TB;

	// Inputs
	reg clk;
	reg CENTER;
	reg UP;
	reg LEFT;
	reg DOWN;
	reg RIGHT;
	reg [7:0] sw;

	// Outputs
	wire [7:0] Led;
	wire [7:0] seg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	top_prestage uut (
		.clk(clk),
		.sw(sw),
		.CENTER(CENTER),
		.UP(UP),
		.LEFT(LEFT),
		.DOWN(DOWN),
		.RIGHT(RIGHT),
		.Led(Led), 
		.seg(seg), 
		.an(an)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		CENTER = 0;
		UP = 0;
		LEFT  = 0;
		DOWN = 0;
		RIGHT = 0;
		sw = 0;
		#1;

		// Wait 100 ns for global reset to finish
		DOWN = 1;
		#1;
		DOWN = 0;
		#1;
		#5;
		#20;
		UP = 1;
		#10;
		UP = 0;
		sw = 8'b00000010;
		#5;
		sw = 8'b00001011;
		#10;
		sw = 8'b10001101;
		#10;
		#50;
		#90;
		RIGHT = 1;
		#20;
		sw = 8'b00111101;
		RIGHT = 0;
		#200;
		DOWN = 1;
		#5;
		DOWN = 0;
		#150;
		LEFT = 1;
		#5;
		LEFT = 0;
		#100;
		$finish;
	end
        
	// Add stimulus here
	always begin
		#2 CENTER = ~CENTER;
	end
	
	always begin
		#1 clk = ~clk;
	end
endmodule