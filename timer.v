`timescale 1ns / 1ps

module timer(
input clock,
input start_timer,
output timesup
);

localparam MINUTE = 60;
reg timesup_reg = 0;
reg [5:0] counter = 6'b000000;

always @ (posedge clock) begin
	if (start_timer == 1) begin
		if(counter == MINUTE-1) begin
 			counter <= 6'b0;
			timesup_reg <= 1;
		end
  		else begin
 			counter <= counter + 6'b1;
  			timesup_reg <= timesup_reg;
		end
	end
	if (start_timer == 0) begin
		timesup_reg <= 0;
		counter <= 6'b000000;
	end
end

assign timesup = timesup_reg;

endmodule