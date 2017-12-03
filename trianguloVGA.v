module Area(
    input [11:0]x1,
    input [11:0]y1,
    
    input [11:0]x2,
    input [11:0]y2,

    input [11:0]x3,
    input [11:0]y3,
    
    output [21:0] s
);

    reg [21:0] area = 0;
    assign s = area;

    //Utilizando a fórmula do Trabalho 2

    wire [11:0] Sy2y3;       //subtração y do ponto 2 e y do ponto 3
    wire [11:0] Sy3y1;       //subtração y do ponto 3 e y do ponto 1
    wire [11:0] Sy1y2;       //subtração y do ponto 1 e y do ponto 2
    
    wire [21:0] Mx1, Mx2, Mx3, Ad;   //multiplicação por x do ponto 1, x do ponto 2 e x do ponto 3, e adição de todos
    wire signed [21:0] Div;         //Divisão por 2
    
    assign Sy2y3 = (y2 - y3);
    assign Sy3y1 = (y3 - y1);
    assign Sy1y2 = (y1 - y2);
    
    assign Mx1 = (x1 * Sy2y3);
    assign Mx2 = (x2 * Sy3y1);
    assign Mx3 = (x3 * Sy1y2);
    
    assign Ad = (Mx1 + Mx2 + Mx3);

    assign Div = (Ad/2);

    always @(x1 or y1 or x2 or y2 or x3 or y3) begin
        area = $abs(Div);           //valor absoluto
    end  
endmodule


module Verifica(
    input [11:0]x1,
    input [11:0]y1,
    
    input [11:0]x2,
    input [11:0]y2,  

    input [11:0]x3,
    input [11:0]y3,

    input [11:0]x,
    input [11:0]y,

    output inside
);
    
    wire signed[21:0] s, s1, s2, s3;

    Area a(x1, y1, x2, y2, x3, y3, s);  //triangulo principal
    Area a1(x, y, x2, y2, x3, y3, s1);
    Area a2(x1, y1, x, y, x3, y3, s2);
    Area a3(x1, y1, x2, y2, x, y, s3);

    assign inside = ( s >= (s1 + s2 +s3) ) ? 1 : 0;
endmodule

module trianguloVGA (
    input CLOCK_50,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS);

    /*pontos do triangulo */
    reg signed [11:0] x1;
    reg signed [11:0] y1;
    reg signed [11:0] x2;
    reg signed [11:0] y2;
    reg signed [11:0] x3;
    reg signed [11:0] y3;
    reg signed [11:0] x;
    reg signed [11:0] y;   

    reg [10:0] cx = 0;
    reg [9:0]  cy = 0;
    reg [11:0] c;

    wire r;

    assign VGA_R = v ? c[3:0] : 4'b0;
    assign VGA_G = v ? c[7:4] : 4'b0;
    assign VGA_B = v ? c[11:8] : 4'b0;

    wire v = (cx >= 285) & (cx < 1555) & (cy >= 35) & (cy < 515);
    Verifica V(x1, y1, x2, y2, x3, y3, x, y, r);

    assign VGA_HS = cx >= 190;
    assign VGA_VS = cy >= 2;

    initial begin
        x1 <= 0;
        y1 <= 0;
        x2 <= 20;
        y2 <= 0;
        x3 <= 20;
        y3 <= 30;
        x <= 10;
        y <= 5;

    end

    always @(posedge CLOCK_50) begin
        if (cx == 1585) begin
            if (cy == 525) begin
                cy <= 0;
            end
            else 
                cy <= cy + 1;
            cx <= 0;
        end
        else begin
            // cy <= cy;
            cx <= cx + 1;
        end
         
         if (r) begin
            c = 12'hf00;
         end
         else begin
            c = 12'h0f0;
         end
    end
