module runtime(
       clk_1Hz,voice_1k,rst_n,clk,
		 beep,runsec,runmin);
		 
   input clk;  
	input rst_n;
	input clk_1Hz;
	input voice_1k;
	output runmin;
	output runsec;
	output reg beep ;
//	output reg[7:0] trunsec;
//	output reg[7:0]trunmin;
	
	reg[7:0]runmin;
	reg[7:0]runsec;
	wire clk_1Hz;
	wire voice_1k;
	reg runstart;
	
	always@(posedge clk )
   begin
	   
		if(~rst_n)
			begin 
				runmin<=0;
				runsec<=0; 
				beep=1'b0;
				
			end 
		
		else 
		begin
		
		
		   if(clk_1Hz )								//second timer
					runsec<=runsec+1;
					if(runsec==59)
						begin
							runmin <=runmin+1;
							runsec<=0;
						end			
			if(runsec==5 && runmin==0 && voice_1k == 1)
			beep =~beep;
			

//		    trunsec<=runsec;
//	        trunmin<=runmin;	
			
		end
	end

  
	
endmodule