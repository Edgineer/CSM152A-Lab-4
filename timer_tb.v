`timescale 1ns / 1ps

module timer_tb;

	// Inputs
	reg clock;

	// Outputs
	wire timesup;

	// Instantiate the Unit Under Test (UUT)
	timer uut (
		.clock(clock),
		.timesup(timesup)
	);

	initial begin
	 // Initialize Inputs
	 clock = 0;
	 // Wait 100 ns for global reset to finish
	 #1000;
	end
	
	always begin
		#10 clock = ~clock;
	end
      
endmodule