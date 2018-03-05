`timescale 1ns / 1ps

module rand8bits (
//Inputs
    input clock,
    input reset,
//Outputs
    output [7:0] rand 
);
 
reg [7:0] random, next_rand, done_rand;
reg [3:0] count, next_count; //count number of shifts 

wire taps = random[7] ^ random[5] ^ random[4] ^ random[3]; //"random" bit
 
always @ (posedge clock or posedge reset) begin
 if (reset) begin
  random <= 8'hFF; //An LFSR cannot have an all 0 state, thus reset to FF
  count <= 0;
 end
  
 else begin
  random <= next_rand;
  count <= next_count;
 end
end
 
always @ (*) begin
 next_rand = random;
 next_count = count;
   
 next_rand = {random[6:0], taps}; //left shift insert the xor'd bit on every posedge clock
 next_count = count + 1;
 
 if (count == 8) begin
  count = 0;
  done_rand = random; //assign the random number to output after 8 shifts
 end
end

assign rand = done_rand;

endmodule