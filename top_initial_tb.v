`timescale 1ns / 1ps

module top_initial_tb;

	// Inputs
	reg clk;
	reg UP;
	reg DOWN;

	// Outputs
	wire [7:0] Led;

	// Instantiate the Unit Under Test (UUT)
	top_initial uut (
		.clk(clk), 
		.UP(UP), 
		.DOWN(DOWN), 
		.Led(Led)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		UP = 0;
		DOWN = 0;

		// Wait 100 ns for global reset to finish
		#100;
		DOWN = ~DOWN;
		#10
		DOWN = ~DOWN;
		#15
		DOWN = ~DOWN;
		DOWN = ~DOWN;
		#10
		DOWN = 1;
		#10
		UP = 1;
		#10
		DOWN = 0;
		#10;
      $finish;  
		// Add stimulus here
	end
	
	always begin
		#10 clk = ~clk;
	end

      
endmodule

