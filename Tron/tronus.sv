module Tron(
	input clk,
	//do klawiatury
	input keyboardData, keyboardCLK, 
	
	//do wyświetlacza
	output wire [9:0] xCount, yCount,
	output reg displayArea,
	output VGA_hSync, VGA_vSync,
	output wire [3:0] Red, Green, Blue
	);
	
	//rzeczy do monitora
	reg p_hSync, p_vSync;
	wire VGA_clk;
	
	integer porchHF = 640;
	integer syncH = 656;
	integer porchHB = 752;
	integer maxH = 800;
	
	integer porchVF = 480;
	integer syncV = 490;
	integer porchVB = 492;
	integer maxV = 525;
	
	//tablice na węże
	//localparam [2:0] A=2;
	wire [6:0] s1x [0:2];
	wire [6:0] s1y [0:2];
	reg s1body;
	
	//wypelnianie -1
	initial begin
//		for(int i = 0;i < A; i = i + 1)
//		begin
//			s1x[i] = 64;
//			s1y[i] = 64;
//		end
//		s1x[A-1] = 59;
//		s1y[A-1] = 30;
//		s1x[A-2] = 60;
//		s1y[A-2] = 30;

		s1x[0] = 20;
		s1y[0] = 20;
		s1x[1] = 60;
		s1y[1] = 45;
		s1x[2] = 10;
		s1y[2] = 10;
	end
	


	
	//dzielenie clock na 2 do monitora
	always@(posedge clk)
	begin
		VGA_clk=~VGA_clk;
	end
	
	//wyświetlani powierzchni i synchro
	always@ (posedge VGA_clk)
	begin
		displayArea <= ((xCount < porchHF) && (yCount < porchVF));
	end
	
	always@ (posedge VGA_clk)
	begin
		p_hSync <= ((xCount >= syncH) && (xCount < porchHB));
		p_vSync <= ((yCount >= syncV) && (yCount < porchVB));
	end
	
	//przechodzenie do nowej lini	
	always@ (posedge VGA_clk)
	begin
		if(xCount == maxH)
			xCount <= 0;
		else
			xCount <= xCount + 1'b1;
	end
	
	always@ (posedge VGA_clk)
	begin
		if(xCount == maxH)
		begin
			if(yCount == maxV)
				yCount <= 0;
			else
				yCount <= yCount + 1'b1;
		end
	end

	//wyswietlanie weza
	always@ (posedge VGA_clk)
	begin
		for (int i = 0; i < 3; i = i + 1)
		begin
			//if(s1x[i] != 64)
				s1body =  ((xCount > s1x[i]*10) && (xCount <= s1x[i]*10+10) && (yCount > s1y[i]*10) && (yCount <= s1y[i]*10+10));
		end
		//s1body = ((xCount > s1x[0]*10) && (xCount <= s1x[0]*10+10) && (yCount > s1y[0]*10) && (yCount <= s1y[0]*10+10)) || ((xCount > s1x[1]*10) && (xCount <= s1x[1]*10+10) && (yCount > s1y[1]*10) && (yCount <= s1y[1]*10+10)) || ((xCount > s1x[2]*10) && (xCount <= s1x[2]*10+10) && (yCount > s1y[2]*10) && (yCount <= s1y[2]*10+10));
	end
	
	always@ (posedge VGA_clk)
	begin
		if(s1body)
			Blue[3] = 1;
		else 
			Blue[3] = 0;
	end
		
	assign VGA_vSync = ~p_vSync;
	assign VGA_hSync = ~p_hSync;	
	
	
endmodule

module Keyboard(

	input keyboardData, keyboardCLK
	);

endmodule


	
	