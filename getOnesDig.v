`timescale 1ns / 1ps

module getOnesDigit(input [7:0] val, output reg [3:0] onesDigit);

always @* begin
	if (val >= 250 && val < 260) 
		onesDigit = val - 250;
	else if (val >= 240 && val < 250) 
		onesDigit = val - 240;
	else if (val >= 230 && val < 240) 
		onesDigit = val - 230;
	else if (val >= 220 && val < 230) 
		onesDigit = val - 220;
	else if (val >= 210 && val < 220) 
		onesDigit = val - 210;
	else if (val >= 200 && val < 210) 
		onesDigit = val - 200;
	else if (val >= 190 && val < 200) 
		onesDigit = val - 190;
	else if (val >= 180 && val < 190) 
		onesDigit = val - 180;
	else if (val >= 170 && val < 180) 
		onesDigit = val - 170;
	else if (val >= 160 && val < 170) 
		onesDigit = val - 160;
	else if (val >= 150 && val < 160) 
		onesDigit = val - 150;
	else if (val >= 140 && val < 150) 
		onesDigit = val - 140;
	else if (val >= 130 && val < 140) 
		onesDigit = val - 130;
	else if (val >= 120 && val < 130) 
		onesDigit = val - 120;
	else if (val >= 110 && val < 120) 
		onesDigit = val - 110;
	else if (val >= 100 && val < 110) 
		onesDigit = val - 100;
	else if (val >= 90 && val < 100) 
		onesDigit = val - 90;
	else if (val >= 80 && val < 90) 
		onesDigit = val - 80;
	else if (val >= 70 && val < 80) 
		onesDigit = val - 70;
	else if (val >= 60 && val < 70) 
		onesDigit = val - 60;
	else if (val >= 50 && val < 60) 
		onesDigit = val - 50;
	else if (val >= 40 && val < 50) 
		onesDigit = val - 40;
	else if (val >= 30 && val < 40) 
		onesDigit = val - 30;
	else if (val >= 20 && val < 30) 
		onesDigit = val - 20;
	else if (val >= 10 && val < 20) 
		onesDigit = val - 10;
	else if (val >= 0 && val < 10) 
		onesDigit = val - 0;
end
endmodule