module kongqijinghuaqi(
	   clk, rst_1n,rst_n, key_col, key_row,  boma, 
		
	   led_select, led_numseg, beep,  erjiguan,led_sleep ,nouse_erji);
		
	input [3:0]boma;
	input clk;
	input rst_n;
	input rst_1n;
	input [3:0] key_row ;  
	output [7:0] led_select;  
	output [7:0] led_numseg;   
	output beep; 
	output [3:0] key_col ;
	output [4:0] erjiguan;
	output led_sleep; 
	output [9:0] nouse_erji;
	wire count_begin ; 
	wire [7:0] min_counter;
	wire [7:0] sec_counter;
	wire [7:0] minute;
	wire [7:0]second;
	wire [4:0] value; 
	wire  [3:0]now_state; 
	wire clk_1Hz;
	wire voice_1k;
	wire [7:0]runsec;
	wire [7:0]runmin;
	
	wire sleep_flag;

	led_show led_show_inst(
		.clk        ( clk        ),
		.rst_n      ( rst_n      ),
		.minute     (minute		 ),
		.second     ( second     ),   
		.led_select ( led_select ),
		.value		(value		 ),
		.now_state  (now_state   ),
		//.runsec		(	runsec	),
		.runmin		(	runmin	),
		.runsec		(	runsec	),
		);  
	led_decoder led_decoder_inst(
			.clk        ( clk        ),
			.rst_n      ( rst_n      ),
			.value		(value		 ),
			.led_numseg(led_numseg)
			);    
	fenpin		fenpin_inst(
			.clk        ( clk        ),
			.rst_n      ( rst_n      ),
			.clk_1Hz    (  clk_1Hz   ),
			.voice_1k	(voice_1k	 )
			);   
	entersleep entersleep_inst(
		.clk        ( clk        ),
		.rst_n      ( rst_n      ),
		.count_begin(count_begin ),
		.min_counter( min_counter),
		.sec_counter( sec_counter), 
		.led_sleep	(	led_sleep),
		.second     ( second     ),
		.minute     (minute		 ),
		
		.clk_1Hz    ( clk_1Hz 	 ),
		
		.now_state  (now_state   ),
		.sleep_flag		(sleep_flag),
		);
	machine_input	machine_input_inst(	
		.clk		( clk        ),
		.rst_1n		( rst_1n      ),
		.rst_n      (  rst_n      ),
		.state_flag (2'b1		 ),
		.col		(key_col	 ),
		.row		(key_row	 ),
		.min_counter(min_counter ),
		.sec_counter(sec_counter ),
		.count_begin(count_begin ),
		.erjiguan	(	erjiguan	),
		.sleep_flag		(	sleep_flag		),
		.nouse_erji		(  nouse_erji ),
		.boma		(boma),
		); 
		

	runtime runtime_inst(
       .clk_1Hz   (	clk_1Hz		),
		 .voice_1k	(	voice_1k		),
		 .rst_n  (	rst_n		),
		 .clk		(clk),
		 .runmin	(	runmin		),
		 .runsec		(	runsec	),
		 .beep     (  beep    ),
	
		 );	 
		 
	   
endmodule
