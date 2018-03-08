`timescale 1ns / 1ps

module top_initial(
	input clk,
	input UP,
	input DOWN,

	output reg [7:0] Led
);

reg game_mode = 0; //Unsigned (0) by default, Two's Complement Mode (1)
reg player1game_started = 0;
reg player2game_started = 0;

always @ (posedge DOWN) begin // press down to iterate through the game modes
	if (player1game_started == 0 && player2game_started == 0) begin //only change modes if the game hasn't started
		game_mode = ~game_mode;
	end

	if (game_mode == 1 && player1game_started == 0 && player2game_started == 0) begin //turn on LED lights
		Led = 8'b11111111;
	end

	else if (game_mode == 0 && player1game_started == 0 && player2game_started == 0) begin //turn off LED lights
		Led = 8'b00000000;
	end

end

//reg [4:0] player1_score = 0;
//always @ (posedge UP) begin // trigger the start of player 1's turn
//always at the posedge of the UP
//	start the timer, display a randomly generated number, initilize the score
//	
//end

endmodule