module Tron(
	input clk,
	//do klawiatury
	input keyboardData, keyboardCLK, 
	//end
	output wire [9:0] xCount, yCount,
	output reg displayArea,
	output VGA_hSync, VGA_vSync,
	output wire [3:0] Red, Green, Blue
	);
	
	reg p_hSync, p_vSync;
	wire VGA_clk;
	
	wire update;
	reg [21:0] updateCount; 
	wire [4:0] direction1, direction2;
	integer x1, y1, x2, y2;
	
	
	integer porchHF = 640;
	integer syncH = 656;
	integer porchHB = 752;
	integer maxH = 800;
	
	integer porchVF = 480;
	integer syncV = 490;
	integer porchVB = 492;
	integer maxV = 525;
	
	reg [10:0] keyCode;
	reg [7:0] code;
	integer count = 0;
	
	reg body1, body2, head1, head2;
	
	 
	 always@(posedge clk)
	 begin
		VGA_clk=~VGA_clk;
		end
		
	always@(posedge clk)
	begin
		updateCount <= updateCount + 1;
		if(updateCount == 1777777)
		begin
			update <= ~update;
			updateCount <= 0;
		end	
	end
	
	TryHard tryhard (VGA_clk, xCount, yCount, maxH, maxV);
	
	always@ (posedge VGA_clk)
	begin
		displayArea <= ((xCount < porchHF) && (yCount < porchVF));
	end
	
	always@ (posedge VGA_clk)
	begin
		p_hSync <= ((xCount >= syncH) && (xCount < porchHB));
		p_vSync <= ((yCount >= syncV) && (yCount < porchVB));
	end
	
	/*
	//kwadrat
	always@ (posedge VGA_clk)
	begin
		if(xCount>100 && xCount < 200)
			begin
				if(yCount > 100 && yCount < 200)
					Blue[3] = 1;
			end
		else
			Blue[3] = 0;
	end
	*/
	
	/*
	always@ (posedge VGA_clk)
	begin
		head1 <= (xCount > 100 && xCount < 200 && yCount > 100 && yCount < 200);
	end
	*/
	
	always@ (negedge keyboardCLK)
	begin
		keyCode[count] = keyboardData;
		count = count + 1;
		if (count == 11)
		begin
			code <= keyCode[8:1];
			count = 0;
		end
	end
		
	/*
	always@ (posedge VGA_clk)
	begin
		if(flag % 2 == 1)
		begin
			if(xCount>300 && xCount < 400)
				begin
					if(yCount > 100 && yCount < 200)
						Red[3] = 1;
				end
			else
				Red[3] = 0;
		end
		else
		begin
			if(xCount>300 && xCount < 400)
				begin
					if(yCount > 100 && yCount < 200)
						Green[3] = 1;
				end
			else
				Green[3] = 0;
		end
	end
	*/
	
	/*
	
	always@ (posedge VGA_clk)
	begin
		if(flag > 0)
		begin
			if(code == 8'b00101101)
			begin
				if(xCount>300 && xCount < 400)
					begin
						if(yCount > 100 && yCount < 200)
						Red[3] = 1;
					end
				else
					Red[3] = 0;
			end	
			else if(code == 8'b00110100)
			begin
			if(xCount>300 && xCount < 400)
				begin
					if(yCount > 100 && yCount < 200)
						Green[3] = 1;
				end
			else
				Green[3] = 0;
			end
		end
	end
	
	*/
	
	always@ (posedge VGA_clk)
	begin
		if(code == 8'h1D)
		begin
			direction1 <= 5'b00010;
			direction2 <= direction2;
		end
		else if(code == 8'h1C)
		begin
			direction1 <= 5'b00100;
			direction2 <= direction2;
		end
		else if(code == 8'h1B)
		begin
			direction1 <= 5'b01000;
			direction2 <= direction2;
		end
		else if(code == 8'h23)
		begin
			direction1 <= 5'b10000;
			direction2 <= direction2;
		end
		else if(code == 8'h43)
		begin
			direction2 <= 5'b00010;
			direction1 <= direction1;
		end
		else if(code == 8'h3B)
		begin
			direction2 <= 5'b00100;
			direction1 <= direction1;
		end
		else if(code == 8'h42)
		begin
			direction2 <= 5'b01000;
			direction1 <= direction1;
		end
		else if(code == 8'h4B)
		begin
			direction2 <= 5'b10000;
			direction1 <= direction1;
		end
		else if(code == 8'h2D)
		begin
			direction1 <= 5'b11111;
		end
		else
		begin
			direction1 <= direction1;
			direction2 <= direction2;
		end
	end
	
	
	/*
	always@ (posedge VGA_clk)
	begin
		if(body1)
			Red[3] = 1;
		else
			Red[3] = 0;
		if(body2)
			Green[3] = 1;
		else
			Green[3] = 0;
		if(head1 || head2)
			Blue[3] = 1;
		else
			Blue[3] = 0;
	end
	*/
	
	
	/*
	always@ (posedge update)
	begin
		if(direction1 == 5'b11111)
		begin
			x1 <= 120;
			y1 <= 120;
		end
		body1 = (displayArea && xCount > x1 && xCount < (x1+10) && yCount > y1 && yCount < (y1+10));
		x1 <= x1+10;
	end
	*/
	
	always@ (posedge VGA_clk)
	begin
		if(direction1 == 5'b11111)
		begin
			x1 <= 120;
			y1 <= 120;
			x2 <= 520;
			y2 <= 360;
		end
			body1 = (displayArea && (xCount > x1 && xCount < (x1+10)) && (yCount > y1 && yCount < (y1+10)));
			if(xCount>x1 && xCount < (x1 + 10))
					begin
						if(yCount > y1 && yCount < (y1+10))
						Red[3] = 1;
					end
					else
						Red[3] = 0;
						
			//body2 = (displayArea && (xCount > x2 && xCount < (x2+10)) && (yCount > y2 && yCount < (y2+10)));
			if(xCount>x2 && xCount < (x2 + 10))
					begin
						if(yCount > y2 && yCount < (y2+10))
						Green[3] = 1;
					end
					else
						Green[3] = 0;
			if(direction1 == 5'b00010)
			begin
				y1 <= (y1 - 100);
			end
			if(direction1 == 5'b00100)
			begin
				x1 <= (x1 - 100);
			end
			if(direction1 == 5'b01000)
			begin
				y1 <= (y1 + 100);
			end
			if(direction1 == 5'b10000)
			begin
				x1 <= (x1 + 100);
			end
			if(direction2 == 5'b00010)
			begin
				y2 <= y2 - 10;
			end
			if(direction2 == 5'b00100)
			begin
				x2 <= x2 - 10;
			end
			if(direction1 == 5'b01000)
			begin
				y2 <= y2 + 10;
			end
			if(direction1 == 5'b10000)
			begin
				x2 <= x2 + 10;
			end
			//head1 = (displayArea && ((xCount > x1 && xCount < (x1+10)) && (yCount > y1 && yCount < (y1+10)))||((xCount > x2 && xCount < (x2+10)) && (yCount > y2 && yCount < (y2+10))));
	end

	

	
	/*
	always@ (posedge VGA_clk)
	begin
		if(direction1 == 5'b10000 || direction1 == 5'b00010 || direction1 == 5'b00100 || direction1 == 5'b01000)
		begin
			if(xCount>300 && xCount < 400)
					begin
						if(yCount > 100 && yCount < 200)
						begin
							Green[3] = 0;
							Red[3] = 1;
						end
					end
				else
					Red[3] = 0;
		end
		if(direction2 == 5'b10000 || direction2 == 5'b00010 || direction2 == 5'b00100 || direction2 == 5'b01000)
		begin
			if(xCount>300 && xCount < 400)
					begin
						if(yCount > 100 && yCount < 200)
						begin
							Red[3] = 0;
							Green[3] = 1;
						end
					end
				else
					Green[3] = 0;
		end
	end
	*/
	
	assign VGA_vSync = ~p_vSync;
	assign VGA_hSync = ~p_hSync;
	
endmodule

module TryHard(
	VGA_clk, xCount, yCount, maxH, maxV
	);

input wire VGA_clk;
input integer maxH, maxV;
inout wire [9:0] xCount, yCount;

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
	
endmodule
