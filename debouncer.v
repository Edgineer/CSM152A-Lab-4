`timescale 1ns / 1ps

module debouncer(
	input btn,
	input clk,
	output btn_state
);

reg state = 0;
reg [15:0] counter; // 763 Hz sampling rate

always @ (posedge clk) begin
	if (btn) begin
	 // add to counter & only use state when counter is full
	 counter <= counter + 1'b1;
		if (counter == 16'b1111111111111111) begin
			state <= 1;
			counter <= 0;
		end
	end
	
	else begin
		state <= 0;
		counter <= 0;
	end
end

assign btn_state = state;

endmodule