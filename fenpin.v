module fenpin(
		clk,
		rst_n,
		clk_1Hz,
		voice_1k
			);
	input clk,rst_n;
	output clk_1Hz;
	output voice_1k;

	reg clk_1Hz,voice_1k;
	reg[25:0] count1,count2;
	always@(posedge clk)
	begin
		if(~rst_n) begin
			count1<=26'b0;
			clk_1Hz<=0;
		end
		else if(count1==26'd24_999_999) begin
			count1<=26'b0;
			clk_1Hz<=1;
		end
		else begin
			count1<=count1+26'b1;
			clk_1Hz<=0;
		end
	end
	always@(posedge clk)
	begin
		if(~rst_n) begin
			count2<=26'b0;
			voice_1k<=0;
			end
		else if(count2==26'd24_999) 
			begin
			count2<=26'b0;
			voice_1k<=1;
			end
		else begin
			count2<=count2+26'b1;
			voice_1k=0;
			end
	end

	
endmodule