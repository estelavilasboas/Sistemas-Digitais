module piscaleds(
	input CLOCK_50,
	input [0:0]SW,
	output [0:0]LEDR);
	
	reg clk = 0;
	reg [26:0]contador=0;
	assign LEDR[0] = clk;
	reg [1:0]c = 1;
	
	always @(posedge CLOCK_50) begin

		if(contador == 50000000) begin
			contador <= 0;
			clk <= ~clk;
			
		end else begin
		   if(SW[0] == 1) begin
				contador <= contador+15;
			end else begin
				contador <= contador+2;
			end
		end
	end
	
endmodule
