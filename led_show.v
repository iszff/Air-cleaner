module led_show(clk,rst_n,minute ,second,led_select,
		value,now_state,runmin,runsec);

input clk;			
input rst_n;
input [7:0] minute;
input [7:0] second;
input [3:0]now_state;
input [7:0]runmin;
input [7:0]runsec;

output [3:0] value;
output [7:0] led_select;
  
reg[23:0] counter;
always@(posedge clk)
	if(!rst_n)
		counter <= 24'b0;
	else
		counter <= counter + 24'b1;
	
reg [8:0] led_select;  
always@(counter[17:15])
	case(counter[17:15])
		3'b000 : 
			led_select = 8'b10000000;           
		3'b001 : 
			led_select = 8'b01000000;           
		3'b010 : 
			led_select = 8'b00100000;
		3'b011 : 
			led_select = 8'b00010000;
		3'b100 : 
			led_select = 8'b00001000;
		3'b101 :
		   led_select = 8'b00000100;    
		3'b110 : 
			led_select = 8'b00000010;
		3'b111 :
		   led_select = 8'b00000001;                 
		default:;             
	endcase
  
reg [3:0] value;
always@(counter[17:15] or second or runsec)
	case(counter[17:15])
//		3'b000 : 
//			value = minute/10;   //高四位显示睡眠倒计时
//		3'b001 : 
//			value = minute%10;          
//		3'b010 : 
//			value = second/10;         
//		3'b011 : 
//			value = second%10;
//	    3'b100 :
//	        value =  runmin/10;
//	    3'b101 :
//	        value =runmin%10 ;
//	    3'b110 :
//	        value = runsec/10;
//	    3'b111 :
//	        value =runsec%10;
	        
	    3'b100 : 
			value = minute/10;   //高四位显示睡眠倒计�?
		3'b101 : 
			value = minute%10;          
		3'b110 : 
			value = second/10;         
		3'b111 : 
			value = second%10;
	    3'b000 :
	        value =  runmin/10;
	    3'b001 :
	        value =runmin%10 ;
	    3'b010 :
	        value = runsec/10;
	    3'b011 :
	        value =runsec%10;
	        
	        
		default:;
	endcase


endmodule
