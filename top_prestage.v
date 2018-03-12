`timescale 1ns / 1ps

module top_prestage(
	input clk,
	input [7:0] sw,
	input CENTER,
	input UP,
	input LEFT,
	input DOWN,
	input RIGHT,
	output reg [7:0] Led,
	output reg [7:0] seg,
	output reg [3:0] an
);

localparam VAL_DASH = 10; // 'define VAL_DASH 10
localparam VAL_P = 11;
localparam VAL_T = 12;
localparam VAL_I = 13;
localparam VAL_E = 14;
localparam VAL_BLANK = 15;
reg [7:0] const_off = 8'b11111111;
reg [7:0] const_on_leds = 8'b00000000;

reg game_mode = 1'b0; // Unsigned (0) by default, Two's Complement Mode (1)
reg UP_state = 0; //Player 1's turn
reg RIGHT_state = 0; //Player 2's turn
reg intermission1_state = 0; //Display player one score
reg intermission2_state = 0; //Display player two score
reg winner_state = 0; //Display end result

wire clk_1hz, clk_fast;
wire mode_clicked, UP_clicked, CENTER_clicked, RIGHT_clicked, LEFT_clicked; //represent the buttons
//assign mode_clicked = DOWN;
//assign UP_clicked = UP;
//assign LEFT_clicked = LEFT;
//assign CENTER_clicked = CENTER;
//assign RIGHT_clicked = RIGHT;
reg [1:0] anode_digit = 2'b00;

wire [7:0] rand_val, switches_val;
wire rand_neg, switches_neg;
reg [7:0] final_randBitVector;
wire [7:0] new_randBitVector;

clk_divider cd(
	.master_clk(clk),
	.rst(0),
	.CLK1hz(clk_1hz),
	.CLKfast(clk_fast)
);

//debounce DOWN (Change game mode/see end results)
debouncer db_down(
	.btn(DOWN),
	.clk(clk),
	.btn_state(mode_clicked)
);

// debounce UP (to start game)
debouncer db_up(
	.btn(UP),
	.clk(clk),
	.btn_state(UP_clicked)
);

// debounce CENTER (to submit responses)
debouncer db_center(
	.btn(CENTER),
	.clk(clk),
	.btn_state(CENTER_clicked)
);

// debounce RIGHT (to start player 2's turn)
debouncer db_right(
	.btn(RIGHT),
	.clk(clk),
	.btn_state(RIGHT_clicked)
);

// debounce LEFT (to restart the game)
debouncer db_left(
	.btn(LEFT),
	.clk(clk),
	.btn_state(LEFT_clicked)
);

rand8bits getRandBits(
	// Inputs
	.clock(clk),
	// Outputs
	.rand(new_randBitVector)
);

interpretVal randNum(
	// Inputs
	.data(final_randBitVector),
	.mode(game_mode),
	// Outputs
	.val(rand_val),
	.neg(rand_neg)
);

interpretVal switchNum(
	// Inputs
	.data(sw),
	.mode(game_mode),
	// Outputs
	.val(switches_val),
	.neg(switches_neg)
);


wire [3:0] O_place;	// wire because we still use it in getOnesDigit module
reg [3:0] H_place,Thous_place,T_place;
wire [7:0] seg_Thous, seg_H, seg_T, seg_O;
// only used on rand_value not the switches val
getOnesDigit onesPlace(.val(rand_val), .onesDigit(O_place));

reg [7:0] p1_score = 0;
reg [7:0] p2_score = 0;

wire timesup_p1;
wire timesup_p2;

wire [3:0] O_placeP1;	// wire because we still use it in getOnesDigit module
reg [3:0] H_placeP1, Thous_placeP1, T_placeP1;
wire [7:0] seg_ThousP1, seg_HP1, seg_TP1, seg_OP1;
getOnesDigit onesPlacep1(.val(p1_score), .onesDigit(O_placeP1));

wire [3:0] O_placeP2;	// wire because we still use it in getOnesDigit module
reg [3:0] H_placeP2, Thous_placeP2, T_placeP2;
wire [7:0] seg_ThousP2, seg_HP2, seg_TP2, seg_OP2;

getOnesDigit onesPlacep2(.val(p2_score), .onesDigit(O_placeP2));

reg [3:0] H_placeWIN, Thous_placeWIN, T_placeWIN, O_placeWIN;	// let O_placeWIN be a reg because we're not using getOnesDigit on it
wire [7:0] seg_Thous_WIN, seg_H_WIN, seg_T_WIN, seg_O_WIN;

segmentMapping segMap_randvals(
.val_thous(Thous_place),
.val_hun(H_place), 
.val_tens(T_place), 
.val_ones(O_place), 
.segrep_thous(seg_Thous), 
.segrep_huns(seg_H), 
.segrep_tens(seg_T), 
.segrep_ones(seg_O)
);

segmentMapping segMap_Player1scores(
.val_thous(VAL_BLANK),
.val_hun(H_placeP1), 
.val_tens(T_placeP1), 
.val_ones(O_placeP1), 
.segrep_thous(seg_ThousP1), 
.segrep_huns(seg_HP1), 
.segrep_tens(seg_TP1), 
.segrep_ones(seg_OP1)
);

segmentMapping segMap_Player2scores(
.val_thous(VAL_BLANK),
.val_hun(H_placeP2), 
.val_tens(T_placeP2), 
.val_ones(O_placeP2), 
.segrep_thous(seg_ThousP2), 
.segrep_huns(seg_HP2), 
.segrep_tens(seg_TP2), 
.segrep_ones(seg_OP2)
);

segmentMapping segMap_Winner(
.val_thous(VAL_BLANK),
.val_hun(H_placeWIN), 
.val_tens(T_placeWIN), 
.val_ones(O_placeWIN), 
.segrep_thous(seg_Thous_WIN), 
.segrep_huns(seg_H_WIN), 
.segrep_tens(seg_T_WIN), 
.segrep_ones(seg_O_WIN)
);

timer p1_timer(
.clock(clk_1hz),
.start_timer(UP_state),
.timesup(timesup_p1)
);

timer p2_timer(
.clock(clk_1hz),
.start_timer(RIGHT_state),
.timesup(timesup_p2)
);

// Continuous Display
always @(posedge clk) begin
	// Assign different segreps to seg based on what state we're in
	if (UP_state == 0 && intermission1_state == 0 && RIGHT_state == 0 && intermission2_state == 0 && winner_state == 0) begin
		case(anode_digit)
		0: an <= 4'b0111;
		1: an <= 4'b1011;
		2: an <= 4'b1101;
		3: an <= 4'b1110;
		endcase
	
		case(anode_digit)
		0: seg <= const_off;
		1: seg <= const_off;
		2: seg <= const_off;
		3: seg <= const_off;
		endcase
		
		anode_digit <= anode_digit + 1;
	
	end
	
	else if (UP_state == 1 && intermission1_state == 0 && RIGHT_state == 0 && intermission2_state == 0 && winner_state == 0) begin
		case(anode_digit)
		0: an <= 4'b0111;
		1: an <= 4'b1011;
		2: an <= 4'b1101;
		3: an <= 4'b1110;
		endcase
	
		case(anode_digit)
		0: seg <= seg_Thous;
		1: seg <= seg_H;
		2: seg <= seg_T;
		3: seg <= seg_O;
		endcase

		anode_digit <= anode_digit + 1;
	end

	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 0 && intermission2_state == 0 && winner_state == 0) begin
		case(anode_digit)
		0: an <= 4'b0111;
		1: an <= 4'b1011;
		2: an <= 4'b1101;
		3: an <= 4'b1110;
		endcase
	
		case(anode_digit)
		0: seg <= seg_ThousP1;
		1: seg <= seg_HP1;
		2: seg <= seg_TP1;
		3: seg <= seg_OP1;
		endcase

		anode_digit <= anode_digit + 1;
	end

	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 1 && intermission2_state == 0 && winner_state == 0) begin
		case(anode_digit)
		0: an <= 4'b0111;
		1: an <= 4'b1011;
		2: an <= 4'b1101;
		3: an <= 4'b1110;
		endcase
	
		case(anode_digit)
		0: seg <= seg_Thous;
		1: seg <= seg_H;
		2: seg <= seg_T;
		3: seg <= seg_O;
		endcase

		anode_digit <= anode_digit + 1;
	end
	
	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 1 && intermission2_state == 1 && winner_state == 0) begin
	
		case(anode_digit)
		0: an <= 4'b0111;
		1: an <= 4'b1011;
		2: an <= 4'b1101;
		3: an <= 4'b1110;
		endcase
	
		case(anode_digit)
		0: seg <= seg_ThousP2;
		1: seg <= seg_HP2;
		2: seg <= seg_TP2;
		3: seg <= seg_OP2;
		endcase

		anode_digit <= anode_digit + 1;
	end
	
	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 1 && intermission2_state == 1 && winner_state == 1) begin
		case(anode_digit)
		0: an <= 4'b0111;
		1: an <= 4'b1011;
		2: an <= 4'b1101;
		3: an <= 4'b1110;
		endcase
	
		case(anode_digit)
		0: seg <= seg_Thous_WIN;
		1: seg <= seg_H_WIN;
		2: seg <= seg_T_WIN;
		3: seg <= seg_O_WIN;
		endcase
		
		anode_digit <= anode_digit + 1;
	end
end

always @ * begin
	//Pre-stage
	if (UP_state == 0 && intermission1_state == 0 && RIGHT_state == 0 && intermission2_state == 0 && winner_state == 0) begin
		if (UP_clicked) begin	// get into the player 1 session
			UP_state = 1;
			final_randBitVector = new_randBitVector; // Initially set our main rand bit vector to some new rand bit vector
		end
	end
	
	// Player 1 Stage
	else if (UP_state == 1 && intermission1_state == 0 && RIGHT_state == 0 && intermission2_state == 0 && winner_state == 0)  begin
		if (!timesup_p1) begin
				// basically displaying current rand value on board
				final_randBitVector = final_randBitVector;
				// take rand val, split up into 3 digits (hund, tens, ones)
				H_place = rand_val / 100;
				T_place = rand_val / 10;
				// onesPlace should handle O_place
				if (H_place == 2)
					T_place = T_place - 20;
				if (H_place == 1)
					T_place = T_place - 10;
				if (rand_neg)
					Thous_place = VAL_DASH;	// val for '-' in mapping.v
				else
					Thous_place = VAL_BLANK; 	// val for '' in mapping.v
				// assuming O_place is already taken are of if rand_val is right

				// segreps have already correctly been evaluated in parallel

				// Display should happen in parallel
		end
		else begin
			intermission1_state = 1;
		end
	end
	
	// Display P1 score
	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 0 && intermission2_state == 0 && winner_state == 0)  begin
		if (RIGHT_clicked) begin
			RIGHT_state = 1;
			final_randBitVector = new_randBitVector;
		end
		else begin
			// Display p1_score
			H_placeP1 = p1_score / 100;
			T_placeP1 = p1_score / 10;
			Thous_placeP1 = VAL_BLANK; 	// val for '' in mapping.v
			// getOnesDigit onesPlacep1 should handle O_placeP1
		end
	end
	
	// Player 2 Stage 
	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 1 && intermission2_state == 0 && winner_state == 0) begin
		if (!timesup_p2) begin
		
			// basically displaying current rand value on board
			final_randBitVector = final_randBitVector;
			// take rand val, split up into 3 digits (hund, tens, ones)
			H_place = rand_val / 100;
			T_place = rand_val / 10;
			if (H_place == 2)
				T_place = T_place - 20;
			if (H_place == 1)
				T_place = T_place - 10;
			if (rand_neg)
				Thous_place = VAL_DASH;	// val for '-' in mapping.v
			else
				Thous_place = VAL_BLANK; 	// val for '' in mapping.v
			// assuming O_place is already taken are of if rand_val is right

			// segreps have already correctly been evaluated in parallel
		end
		else begin
			intermission2_state = 1;
		end
	end
	
	// Display P2
	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 1 && intermission2_state == 1 && winner_state == 0)  begin
		// Display p2_score
		H_placeP2 = p2_score / 100;
		T_placeP2 = p2_score / 10;
		Thous_placeP2 = VAL_BLANK; 	// val for '' in mapping.v
		// getOnesDigit onesPlacep2 should handle O_placeP2
	end
	
	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 1 && intermission2_state == 1 && winner_state == 1)  begin
		if (LEFT_clicked) begin
			// RESTART EVERYTHING
		UP_state = 0;
		intermission1_state = 0; 
		RIGHT_state = 0;
		intermission2_state = 0;
		winner_state = 0;
		p1_score = 0;
		p2_score = 0;
	end
	else begin
		// DISPLAY WINNER: P1, P2 or TIE
		if (p1_score > p2_score) begin
			Thous_placeWIN = VAL_BLANK;
			H_placeWIN = VAL_BLANK;
			T_placeWIN = VAL_P;
			O_placeWIN = 1;
		end
		else if (p1_score < p2_score) begin
			Thous_placeWIN = VAL_BLANK;
			H_placeWIN = VAL_BLANK;
			T_placeWIN = VAL_P;
			O_placeWIN = 2;
		end
		else begin
			Thous_placeWIN = VAL_BLANK;
			H_placeWIN = VAL_T;
			T_placeWIN = VAL_I;
			O_placeWIN = VAL_E;
		end
	end
end
	
end

always @(posedge DOWN) begin	
	// Pre-Stage
	if (UP_state == 0 && intermission1_state == 0 && RIGHT_state == 0 && intermission2_state == 0 && winner_state == 0) begin	
		if (game_mode) begin
			game_mode = 0;
			Led = const_off;	// should all be OFF
		end 
			
		else begin
			game_mode = 1;
			Led = const_on_leds;	// should all be ON
		end
	end
	if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 1 && intermission2_state == 1 && winner_state == 0) begin
		winner_state = 1;
	end
end

always @(posedge CENTER) begin
	//Player1's turn
	if (UP_state == 1 && intermission1_state == 0 && RIGHT_state == 0 && intermission2_state == 0 && winner_state == 0)  begin
		// compare random gen number and switch input number
		if (switches_val == rand_val) begin
			p1_score = p1_score+ 1;
			final_randBitVector = new_randBitVector;
			// should display upon next "always" trigger
		end		
		else begin
			p1_score = p1_score;
			final_randBitVector = final_randBitVector;
		end
	end
	
	//Player 2's turn
	else if (UP_state == 1 && intermission1_state == 1 && RIGHT_state == 1 && intermission2_state == 0 && winner_state == 0) begin
		// compare random gen number and switch input number
		if (switches_val == rand_val) begin
			p2_score= p2_score+ 1;
			final_randBitVector = new_randBitVector;
			// should display upon next "always" trigger
		end
		else begin
			p2_score= p2_score;
			final_randBitVector = final_randBitVector;
		end
	end
end
endmodule