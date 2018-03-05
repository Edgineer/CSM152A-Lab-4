`timescale 1ns / 1ps

module timer_tb;

	// Inputs
	reg clock;
	reg start;

	// Outputs
	wire timesup;

	// Instantiate the Unit Under Test (UUT)
	timer uut (
		.clock(clock),
		.start(start),
		.timesup(timesup)
	);

	initial begin
	 // Initialize Inputs
	 clock = 0;
	 start = 0; 
	 // Wait 100 ns for global reset to finish
	 #100;
	 start = 1;
	 #3043
	 start = 0;
	 #200;
	 $finish;
	end
	
	always begin
		#1 clock = ~clock;
	end
      
endmodule