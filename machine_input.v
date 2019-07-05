module machine_input(
		clk,rst_n,rst_1n,col,row,state_flag,boma,sleep_flag,erjiguan,
		min_counter,sec_counter,count_begin,nouse_erji); 

	input  clk,rst_n,rst_1n;
	input  [2:0]state_flag;   
	input  [3:0] row; 
	output reg [3:0] col; 
	output count_begin;
	output reg [7:0] min_counter;
	output reg [7:0] sec_counter;
	input [3:0]boma;
	input  sleep_flag;
   
	output reg[9:0] nouse_erji;
	
	
	output reg [4:0] erjiguan;
   	reg [4:0]shoudong_slect;
	reg shoudong_flag;
	wire [7:0] data;
	assign data= key_data; 
	
	reg clk_20ms; 
	reg [19:0] r; 

	always@(posedge clk,negedge rst_n) 
		if(!rst_n)
			r <= 20'b0;
		else if(r == 1000000)
		begin
			r <= 20'b0;
			clk_20ms <= 1'b1;          
		end
		
		else
		begin                          
			r <= r+1'b1;
			clk_20ms <= 1'b0;
		end
		
	wire [7:0] ranks;
	assign ranks = {row[3:0],col[3:0]}; 
	
	parameter coln = 5'b00_001,		    					
			  col0 = 5'b00_010,
			  col1 = 5'b00_100,
			  col2 = 5'b01_000,
			  col3 = 5'b10_000;
	reg [4:0] state;
	reg [7:0] key_data_buf,key_data;
	reg [1:0] delay;

	always@(posedge clk,negedge rst_n)  //扫描
	begin
	   
		
		if(!rst_n) 
		begin
			delay <= 2'b0;
			col <= 4'b1111;            //rst重置，按键无效 
			state <= coln;              //只扫描第一列
			
		end
		
		else
		begin
			case(state)
				coln: state <= col0;
				
				col0: 
				begin
					delay <= 2'b0;                    //延时标志               
					col <= 4'b0111; 
					key_data_buf <= ranks;             //拼位值
					if(clk_20ms)
						delay <= delay+1'b1;
						
					if(delay == 2'b01) 
					begin
						if(key_data_buf == ranks)     //延时20ms，确认无抖动，并且扫描
						begin
							key_data <= key_data_buf;   
							state <= col1;               
						end
						else
							state <= coln;      
					end
				end
				col1:
				begin
					delay <= 2'b0;
					col <= 4'b1011; 
					key_data_buf <= ranks;
					if(clk_20ms)
						delay <= delay+1'b1;
					if(delay == 2'b01)
					begin
						if(key_data_buf == ranks)
						begin
							key_data <= key_data_buf;
							state <= col2;
						end
						else
							state <= coln;
					end
				end
				col2:
				begin
					delay <= 2'b0;
					col <= 4'b1101;
					key_data_buf <= ranks;
					if(clk_20ms)
						delay <= delay+1'b1;
					if(delay == 2'b01)
					begin
						if(key_data_buf == ranks)
						begin
							key_data <= key_data_buf;
							state <= col3;
						end
						else
							state <= coln;
					end
				end
				col3:
				begin
					delay <= 2'b0;
					col <= 4'b1110;
					key_data_buf <= ranks;
					if(clk_20ms)
						delay <= delay+1'b1;
					if(delay == 2'b01)
					begin
						if(key_data_buf == ranks)
						begin
							key_data <= key_data_buf;
							state <= col0;
						end
						else
							state <= coln;
					end
				end
				
				default: state <= coln; 
			endcase
		end
	end
   
	always@(posedge clk,negedge rst_n)   
	begin
		if(!rst_n)
		erjiguan<=5'b00000;
		else
		begin
			if(shoudong_flag||sleep_flag)                    
			begin
				if(shoudong_slect==5'b11110||sleep_flag)
					begin
					erjiguan<=5'b00001;
					end
				else if(shoudong_slect==5'b11100)
					begin
					erjiguan<=5'b00011;
					end
				else if(shoudong_slect==5'b11000)
					begin
					erjiguan<=5'b00111;
					end
				else if(shoudong_slect==5'b10000)
					begin
					erjiguan<=5'b01111;
					end
				else if(shoudong_slect==5'b00000)                //how clean shoudongflag when rst_n？？
					begin
					erjiguan<=5'b11111;
					end
				
			end
			else if(!shoudong_flag) 
			begin  

				if(boma==4'b1111)
					erjiguan<=5'b00001;
				else if(boma==4'b1110)
					erjiguan<=5'b00011;
				else if(boma==4'b1100)
					erjiguan<=5'b00111;
				else if(boma==4'b1000)
					erjiguan<=5'b01111;
				else if(boma==4'b0000)
					erjiguan<=5'b11111;
			end
		end
	
	end

	reg count_begin;
	reg [31:0] num;
	reg cnt;
	always@(posedge clk,negedge rst_1n)					
	begin
	  if(!rst_1n)
			begin
			  count_begin <= 0;
			  min_counter<=0;
			  sec_counter<=0;
			  num<=0;
			  cnt<=1;
			end
		else 
			case(data)			
				8'b0111_0111: 
							begin 
							if(state_flag == 1&& cnt==1 )
								begin
									min_counter <= ((min_counter+10)%60);	//(1,1)fen shiwei
									num<=0;
								end
							if(num < 2000000)
								begin
								cnt<=0;
								num<=num+1;
								end
							else
								begin
									cnt<=1;
									num<=0;
								end
						end		
				8'b0111_1011: 
						begin 
							if(state_flag == 1&& cnt==1 )
								begin
									min_counter <=((min_counter+1)%60);	//(1,2)fen gewei
									num<=0;
								end
							if(num < 2000000)
								begin
								cnt<=0;
								num<=num+1;
								end
							else
								begin
									cnt<=1;
									num<=0;
								end
						end		
				8'b1011_0111: 
							begin 
							if(state_flag == 1&& cnt==1 )
								begin
									sec_counter <= ((sec_counter+10)%60);	//(2,1)miao shiwei 
									num<=0;
								end
							if(num < 2000000)
								begin
								cnt<=0;
								num<=num+1;
								end
							else
								begin
									cnt<=1;
									num<=0;
								end
						end		
				8'b1011_1011: 
						begin 
							if(state_flag == 1&& cnt==1 )
								begin
									sec_counter <=((sec_counter+1)%60);	//(2,2)miao gewei 
									num<=0;
								end
							if(num < 2000000)
								begin
								cnt<=0;
								num<=num+1;
								end
							else
								begin
									cnt<=1;
									num<=0;
								end
						end		

				8'b1110_0111:  											//(4,1)begin 
						begin 
							if(state_flag == 1)
								begin
								count_begin <=1 ;	
								end
						end
						
						
				///////////我加的//////////////
			   8'b0111_1110:  											//(1，4)
						begin 
					   shoudong_flag=1'b1;
						shoudong_slect=5'b11110;
						end
				8'b1011_1110:	                                  //(2,4)
                  begin 
						shoudong_flag=1'b1;
						shoudong_slect=5'b11100;
						end
				8'b1101_1110:	                                 //(3,4)
                  begin 
						shoudong_flag=1'b1;   
						shoudong_slect=5'b11000;
						end
				8'b1110_1110:	                                 //(4,4)
                  begin 
						shoudong_flag=1'b1;  
					   shoudong_slect=5'b10000;
						end				
				8'b1110_1101:	                                 //(4,3)
                  begin 
					   shoudong_flag=1'b1; 
						shoudong_slect=5'b00000;
						end
            8'b1110_1011:	                                 //(4,2)
                  begin 
					   shoudong_flag=1'b0;                     
						end						
				default: ;
			endcase
	end

endmodule
