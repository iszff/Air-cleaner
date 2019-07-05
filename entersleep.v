module entersleep(clk_1Hz,led_sleep,
		clk,rst_n,count_begin, min_counter,sec_counter,sleep_flag,
		second, minute ,now_state);
    
	input clk;  
	input rst_n;
	input clk_1Hz;

	input count_begin;
	input [7:0]min_counter;
	input [7:0]sec_counter;
	output [7:0] second;
	output reg [7:0] minute;

   output [3:0]now_state;
	
	
	
	output reg led_sleep;
   output reg sleep_flag;
	

	wire clk_1Hz;
	wire voice_1k;
	reg [7:0] second;
	reg flag;
	
	reg [3:0]now_state;
	reg [2:0]dd;
	reg DU;

	
	always@(posedge clk ) 
		if(~rst_n)
			begin 
			    second<= sec_counter;      //复位时
				 
				 minute<=min_counter;
				 led_sleep<=1'b0;
				 sleep_flag<=1'b0;
				 
				 now_state<=4'd0;
			end 
	else if ( now_state==4'd0)		//倒计时处理
		begin 
				if(count_begin==1)							//begin  开始计数

         	     begin
					 sleep_flag<=1'b0;
						if(second==0 && minute!=0)         //min timer
							begin
								second=59;
								minute<=minute-1;             
								
							end

						
						else if(second==0 && minute==0 )			
						begin
						   led_sleep<=1'b1;
							sleep_flag<=1'b1;                 
						end
						if(clk_1Hz )								//second timer
							begin
								if(minute==0 && second==0 )
									begin 
										now_state<=4'd1 ;           
									end 
								else		
									begin
										second <= second- 1;
									
									end
							end
					end
			
				else
			begin 
					minute<=min_counter;
					second<=sec_counter;
				
			end	
	end
endmodule 

