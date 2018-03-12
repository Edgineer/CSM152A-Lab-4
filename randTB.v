`timescale 1ns / 1ps

module randTB;

	// Inputs
	reg clock;

	// Outputs
	wire [7:0] rand;

	// Instantiate the Unit Under Test (UUT)
	rand8bits uut (
		.clock(clock), 
		.rand(rand)
	);

	initial begin
		// Initialize Inputs
		clock = 0;

		// Wait 100 ns for global reset to finish
		#500;
		$finish;
        
		// Add stimulus here

	end

	always begin
		#1 clock = ~clock;
	end
      
endmodule

