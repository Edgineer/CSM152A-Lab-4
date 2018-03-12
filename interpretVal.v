`timescale 1ns / 1ps

module interpretVal(
input [7:0] data, input mode, 
output reg [7:0] val, output reg neg
);

always @* begin
	if (mode == 1) begin
		if (data[7] == 1) begin
			val = ~data + 1;
			neg = 1;
		end
		else begin
			val = data;
			neg = 0;
		end
	end
	else begin
		val = data;
		neg = 0;
	end
end
endmodule