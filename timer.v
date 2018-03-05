`timescale 1ns / 1ps

module timer(
input clock, input start,
output timesup
);

localparam MINUTE = 60;
reg timesup_reg;
reg [5:0] counter;

always @ (posedge clock) begin
 
 if(start == 1) begin
  if(counter == MINUTE-1) begin
	counter <= 6'b0;
   timesup_reg <= ~timesup_reg;
  end
  
  else begin
   counter <= counter + 6'b1;
   timesup_reg <= timesup_reg;
  end
 end

 else begin
  counter <= 6'b0;
  timesup_reg <= 1'b0;
 end
end

assign timesup = timesup_reg;

endmodule