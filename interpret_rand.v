`timescale 1ns / 1ps

module interpretRand(
input [7:0] data, input mode, 
output [7:0] val, output neg
);

reg [7:0] val_reg;
reg neg_reg;

always @* begin
	if (mode == 1) begin
		if (data[7] == 1) begin
			val_reg = ~data + 1;
			neg_reg = 1;
		end
		else begin
			val_reg = data;
			neg_reg = 0;
		end
	end
	else begin
		val_reg = data;
		neg_reg = 0;
	end
end

assign val = val_reg;
assign neg = neg_reg;

endmodule