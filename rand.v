`timescale 1ns / 1ps

module rand8bits (
//Inputs
    input clock,
//Outputs
    output [7:0] rand 
);
 
reg [7:0] random = 8'hFF, next_rand, done_rand;
reg [3:0] count = 0, next_count; //count number of shifts 

wire taps = random[7] ^ random[5] ^ random[4] ^ random[3]; //"random" bit
reg deciderBit = 0;
 
always @ (posedge clock) begin
  random <= next_rand;
  if (deciderBit == 1) begin
		count <= 0;
  end
  else begin
  count <= next_count;
  end
end
 
always @ (*) begin

 next_rand = random;
 next_count = count;
   
 next_rand = {random[6:0], taps}; //left shift insert the xor'd bit on every posedge clock
 next_count = count + 1;
 
 if (count == 8) begin
  //count = 0;
  deciderBit = 1;
  done_rand = random; //assign the random number to output after 8 shifts
 end
 else begin
	deciderBit = 0;
 end
end

assign rand = done_rand;

endmodule