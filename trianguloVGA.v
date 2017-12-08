module Mod(
	input signed [17:0]i,
	output signed [17:0] j
);
	assign j = i[17]? -i : i;
endmodule


module Area(
    input [8:0]x1,
    input [8:0]y1,
    
    input [8:0]x2,
    input [8:0]y2,

    input [8:0]x3,
    input [8:0]y3,
    
    output [17:0] s
);
    
    wire [17:0] Mx1, Mx2, Mx3, Ad;   //multiplicação por x do ponto 1, x do ponto 2 e x do ponto 3, e adição de todos
    wire signed [17:0] Div;
       
    assign Mx1 = (x1 * (y2 - y3));
    assign Mx2 = (x2 * (y3 - y1));
    assign Mx3 = (x3 * (y1 - y2));
    
    assign Ad = (Mx1 + Mx2 + Mx3);
    assign Div = (Ad/2);

    Mod M(Div, s);
	
endmodule


module Verifica(
    input [8:0]x1,
    input [8:0]y1,
    
    input [8:0]x2,
    input [8:0]y2,  

    input [8:0]x3,
    input [8:0]y3,

    input [8:0]x,
    input [8:0]y,

    output inside
);
    
    wire signed[17:0] s, s1, s2, s3;

    Area a(x1, y1, x2, y2, x3, y3, s);  //triangulo principal
    Area a1(x, y, x2, y2, x3, y3, s1);
    Area a2(x1, y1, x, y, x3, y3, s2);
    Area a3(x1, y1, x2, y2, x, y, s3);

    assign inside = ( s >= (s1 + s2 +s3) ) ? 1 : 0;
endmodule


module memoria (
	input CLOCK_50,
	input [0:0]KEY,
	output [17:0] SRAM_ADDR,
	inout [15:0]  SRAM_DQ,
	output SRAM_WE_N,
	output SRAM_OE_N,
	output SRAM_UB_N ,
	output SRAM_LB_N,
	output SRAM_CE_N ,
	input [8:0] px, 
	input [8:0] py,
	output o	
);

reg [15:0] data;
reg [17:0] addr;
reg [5:0] count = 0;

reg ready = 0;
reg write = 0;

assign o = ready ? SRAM_DQ[0] : 1'b0;
assign SRAM_ADDR = ready ? {px, py} : addr;
assign SRAM_DQ = ready ? 16'hzzzz : data;

assign SRAM_WE_N = ~write;
assign SRAM_OE_N = write;

assign SRAM_UB_N = 0;
assign SRAM_LB_N = 0;
assign SRAM_CE_N = 0;

wire cp_o;

reg [8:0] x2 = 50;
reg y = 0;

Verifica V(CLOCK_50, x2, 20, 80, 75, 150, 70, addr[17:9], addr[8:0], cp_o);

always @(posedge CLOCK_50) begin 
	if(~ready) begin
		count <= count + 1;
		if (count == 30) begin
			write <= 1;
			data <= cp_o;			
		end
		else if (count == 40) begin
			write <= 0;
			addr <= addr + 1;
		end
		if (addr == 18'hfffff) begin
			ready <= 1;
			y <= 0;
		end

	end
	
	else if(~KEY[0] & ~y) begin
		count <= 0;
		ready <= 0;
		addr <= 0;
		x2 <= x2 + 10;
		y <= 1;
	end
	
end

endmodule



module trianguloVGA (
  	input CLOCK_50,
	output [17:0] SRAM_ADDR,
	inout [15:0]  SRAM_DQ,
	output SRAM_WE_N,
	output SRAM_OE_N,
	output SRAM_UB_N ,
	output SRAM_LB_N,
	output SRAM_CE_N ,
  	output [3:0] VGA_R,
  	output [3:0] VGA_G,
	output [3:0] VGA_B,
 	output VGA_HS,
	output VGA_VS
);

	reg [10:0] cx = 0;
	reg [9:0]  cy = 0;

	assign VGA_R = (v & t) ? 4'hf : 4'b0;
	assign VGA_G = (v & r) ? 4'hf : 4'b0;
	assign VGA_B = v ? 4'hf : 4'b0;

	//a área visivel
	wire v = (cx >= 285) & (cx < 1555) & (cy >= 35) & (cy < 515);

	//retangulo
	wire r = (cx >= 300) & (cx < 750) & (cy >= 50) & (cy < 300);

	//triangulo
	wire t;

	wire [10:0] px = cx - 285;
	wire [9:0] py = cy - 35;

	memoria m1(
		CLOCK_50,
		SRAM_ADDR,
		SRAM_DQ,
		SRAM_WE_N,
		SRAM_OE_N,
		SRAM_UB_N ,
		SRAM_LB_N,
		SRAM_CE_N ,
		px[10:2], 
		py[9:1],
		r
	);


	assign VGA_HS = cx >= 190;
	assign VGA_VS = cy >= 2;

	always @(posedge CLOCK_50) begin
		if (cx == 1585) 
	    begin
	        if (cy == 525) begin
				cy <= 0;
	        end
			else 
				cy <= cy + 1;
			cx <= 0;
		end
	    else 
	    begin
	        
			cx <= cx + 1;
	    end
		 
	end

endmodule
