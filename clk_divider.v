`timescale 1ns / 1ps

module clk_divider(
input master_clk, input rst,
output CLK1hz, output CLKfast
);

//CLKmaster = 100MHz = 100,000,000 Hz
localparam oneHzConst = 50000000;
localparam fastHzConst = 71429; // 700Hz

//clocks as registers
reg CLK1hzR = 1'b0;
reg CLKfastR = 1'b0;

//counters
reg [27:0] oneHzCount = 0;
reg [19:0] fastHzCount = 0;

//1Hz Clock
always @ (posedge (master_clk), posedge (rst)) begin
	if(rst == 1) begin
	 oneHzCount <= 28'b0;
	 CLK1hzR <= 1'b0;
	end

	else if(oneHzCount == oneHzConst-1) begin
	 oneHzCount <= 28'b0;
	 CLK1hzR <= ~CLK1hz;
	end
	
	else begin
	 oneHzCount <= oneHzCount + 1;
	 CLK1hzR <= CLK1hz;
	end	
end

//Fast Clock (700Hz)
always @ (posedge (master_clk), posedge (rst)) begin
	if(rst == 1) begin
	 fastHzCount <= 20'b0;
	 CLKfastR <= 1'b0;
	end

	else if(fastHzCount == fastHzConst-1) begin
	 fastHzCount <= 20'b0;
	 CLKfastR <= ~CLKfast;
	end
	
	else begin
	 fastHzCount <= fastHzCount + 1;
	 CLKfastR <= CLKfast;
	end	
end

assign CLK1hz = CLK1hzR;
assign CLKfast = CLKfastR;

endmodule