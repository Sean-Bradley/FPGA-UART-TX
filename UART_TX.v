module UART_TX (
		input clk, x0, x1, x2, x3,
		output l0, l1, l2, l3, tx
	); 
	
	reg [0:0] tx_data; // the bit being sent
	reg [0:31] ctr_led; // used to flash the led
	reg [0:31] ctr_tx; // used to synchronise the UART TX output
	reg [0:0] b = 0; // whetehr the LED is on of off

	integer i = 0;
	reg [0:7] tmp;
	reg [0:63] s; // the text to send through serial
	integer strLen = 0;	// a variable to track how many letters in the string to send
	reg [0:9] next; // the enxt charatcer to send, unclused stop and start bits
	reg [0:0] getNext = 0; // whether there are more chars to send
	integer idx = 0; // used as index for getting bits
	
	reg [0:3] buttonDisabled; // ensures button triggered only once when pressed
	
	assign {l0} = {b}; // led is on/off depending on b
	assign {l1, l2, l3} = {x1, x2, x3}; // other leds show when buttons are pressed
	assign tx = tx_data; // assigned to pin 114 (UART TX pin)
	
	always @ (posedge clk) begin
				
		ctr_led = ctr_led + 1;
		if(ctr_led == 50000000) begin
			ctr_led = 0;
			b = !b;  // 1 on or off per second so I know its' working
		end
		
		ctr_tx = ctr_tx +1;
		if(ctr_tx == 5208) begin  //9600 BAUD = 50000000 / 5208
			ctr_tx = 0;					
		
			if(strLen > 0) begin
										
				if(getNext == 1) begin
					getNext = 0;
					next[0] = 1'b0;
					tmp = s[0:7];
					for (i=0; i<8; i=i+1) next[1+i] = tmp[7-i]; // reverse the ascii bits
					
					next[9] = 1'b1;
					
					s = s << 8; // shift string left 8 bits so next character will get cached into 'next'
				end
				
				tx_data = next[idx];
				
				if (idx == 9) begin					
					if(strLen > 0) begin
						idx = 0; 
						getNext = 1;
						strLen = strLen - 1;
					end					
				end				
				else begin
					idx = idx + 1;
				end
			end		
			
		end
		
		if(x0 == 0 && buttonDisabled[0] == 0) begin
			if(strLen == 0) begin
				buttonDisabled[0] = 1;
				s = "sean\r\n"; // sting to send when button 0 pressed
				getNext = 1;				
				strLen = 8;
			end
		end
		if(x0 == 1) begin
			buttonDisabled[0] = 0;
		end
				
		if(x1 == 0 && buttonDisabled[1] == 0) begin
			if(strLen == 0) begin
				buttonDisabled[1] = 1;
				s = "was \r\n"; // sting to send when button 1 pressed
				getNext = 1;				
				strLen = 8;
			end			
		end
		if(x1 == 1) begin
			buttonDisabled[1] = 0;
		end
		
		if(x2 == 0) begin
			if(strLen == 0) begin
				s = "ere \r\n"; // sting to send when button 2 pressed
				getNext = 1;				
				strLen = 8;
			end			
		end
		
		if(x3 == 0) begin
			if(strLen == 0) begin
				s = "#12345\n"; // sting to send when button 3 pressed
				getNext = 1;				
				strLen = 8;
			end			
		end
	end
	
endmodule 