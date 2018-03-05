`timescale 1ns / 1ps

module timer(
input clock,
output timesup
);

localparam MINUTE = 60;
reg timesup_reg = 0;
reg [5:0] counter = 6'b000000;

always @ (posedge clock) begin
 
 if(counter == MINUTE-1) begin
  counter <= 6'b0;
  timesup_reg <= ~timesup_reg;
 end
 
 else begin
  counter <= counter + 6'b1;
  timesup_reg <= timesup_reg;
 end	
end

assign timesup = timesup_reg;

endmodule