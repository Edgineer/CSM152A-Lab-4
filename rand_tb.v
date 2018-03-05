`timescale 1ns / 1ps

module test;
 
 // Inputs
 reg clock;
 reg reset;
 
 // Outputs
 wire [7:0] rand;
 
 // Instantiate the Unit Under Test (UUT)
 rand8bits uut (
  .clock(clock), 
  .reset(reset), 
  .rand(rand)
 );
  
 initial begin
  clock = 0;
  forever
   #50 clock = ~clock;
  end
   
 initial begin
  // Initialize Inputs
   
  reset = 0;
 
  // Wait 100 ns for global reset to finish
  #100;
      reset = 1;
  #200;
  reset = 0;
  // Add stimulus here
 
 end
  
 initial begin
 $display("clock rnd");
 $monitor("%b,%b", clock, rand);
 end     
endmodule