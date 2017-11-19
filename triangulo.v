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

    wire [11:0] Sy2y3;       //subtração y do ponto 2 e y do ponto 3
    wire [11:0] Sy3y1;       //subtração y do ponto 3 e y do ponto 1
    wire [11:0] Sy1y2;       //subtração y do ponto 1 e y do ponto 2
    
    wire [21:0] Mx1, Mx2, Mx3;   //multiplicação por x do ponto 1, x do ponto 2 e xdo ponto 3, e adição de todos
    wire signed [21:0] Ad;
    
    assign Sy2y3 = (y2 - y3);
    assign Sy3y1 = (y3 - y1);
    assign Sy1y2 = (y1 - y2);
    
    assign Mx1 = (x1 * Sy2y3);
    assign Mx2 = (x2 * Sy3y1);
    assign Mx3 = (x3 * Sy1y2);
    
    assign Ad = (Mx1 + Mx2 + Mx3);

    always @(x1 or y1 or x2 or y2 or x3 or y3) begin
        area = $abs(Ad);
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

    output in
);

    reg inside;
    assign in = inside;

    wire signed[21:0] s, s1, s2, s3;

    Area a(x1, y1, x2, y2, x3, y3, s);  //triangulo principal
    Area a1(x, y, x2, y2, x3, y3, s1);
    Area a2(x1, y1, x, y, x3, y3, s2);
    Area a3(x1, y1, x2, y2, x, y, s3);

    always @(s1 or s2 or s3 or s) begin
        if ( s >= (s1 + s2 +s3)) begin
            inside = 1;

        end else begin
            inside = 0;
        end
    end

endmodule


module testbench;
    reg signed [11:0] x1;
    reg signed [11:0] y1;
    reg signed [11:0] x2;
    reg signed [11:0] y2;
    reg signed [11:0] x3;
    reg signed [11:0] y3;

    reg signed [11:0] x;
    reg signed [11:0] y;

    wire resul;

    Verifica V( x1, y1, x2, y2, x3, y3, x, y, resul);

    initial begin
        x1 <= 0;
        y1 <= 0;
        x2 <= 20;
        y2 <= 0;
        x3 <= 20;
        y3 <= 30;
        x <= 0;
        y <= 5;

        #2 
        $display("\nPonto escolhido: %d %d  Triangulo: %d %d  %d %d  %d %d\nDentro? %d", x, y, x1, y1, x2, y2, x3, y3, resul);

        #40
        $finish;
    end 


endmodule
