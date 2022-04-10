`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2022 12:08:32
// Design Name: 
// Module Name: asd_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module asd_tb;
    reg clk,reset;
    reg [31:0]a,b;
    wire [31:0]c;
   
    always #100 clk = ~ clk;

    localparam period = 200;  

    asd UUT (
        .clk(clk), 
        .reset(reset), 
        .a(a),
        .b(b),
        .c(c));
        
    initial begin
        $display("inicia testeo...");
        clk <= 1'b0;

        /************************************************* 
        ============ PRIMER TEST ============
        
        - se multiplicara (- 3 x 2^3) por (+ 7 x 2^4)
        - El resultado esperado deberia ser (- 21 x 2^7)
        - considerar que la mantisa esta "pegada" a la izquierda
        - transformando todos los numeros a binario:
        
        mantisas
        3 = 11
        7 = 111
        21 = 10101
        
        exponentes
        3 = 11
        4 = 100
        7 = 111
               
        s expone        mantisa
        ||------||---------------------|
        3322222222221111111111          
        10987654321098765432109876543210
        seeeeeeeemmmmmmmmmmmmmmmmmmmmmmm
        10000001111000000000000000000000 primer numero
        00000010011100000000000000000000 segundo numero
        10000011110101000000000000000000 resultado
        
        *************************************************/
        // inicio del test. Se pone los valores a a y b
        reset <= 1'b0;
        a <= 32'b10000001111000000000000000000000;
        b <= 32'b00000010011100000000000000000000;
        #period; 

        // reseteo
        reset <= 1'b1;
        #period;

        // espero al resultado
        reset <= 1'b0;
        #20000;

        // testeo
        assert (c === 32'b10000011110101000000000000000000) else $error("error test 1.");
        
        /************************************************* 
        ============ SEGUNDO TEST ============
        
        - se multiplicara (- 0 x 2^3) por (+ 10 x 2^6)
        - El resultado esperado deberia ser (+ 0 x 2^0)
        - considerar que la mantisa esta "pegada" a la izquierda
        - transformando todos los numeros a binario:
        
        mantisas
        0 = 0
        10 = 1010
        
        exponentes
        0 = 0
        3 = 11
        6 = 110
       +-+--------+-----------------------+        
       |s| expone |        mantisa        |
       +-+--------+-----------------------+
       |3|32222222|2221111111111          |
       |1|09876543|21098765432109876543210| posicion partiendo de 0
       +-+--------+-----------------------|
       |1|00000011|00000000000000000000000| primer numero
       |0|00000110|10100000000000000000000| segundo numero
       |0|00000000|00000000000000000000000| resultado
       +-+--------+-----------------------+
        *************************************************/
        
        // inicio del test. Se pone los valores a a y b
        reset <= 1'b0;
        a <= 32'b10000001111000000000000000000000;
        b <= 32'b00000010011100000000000000000000;
        #period; 

        // reseteo
        reset <= 1'b1;
        #period;

        // espero al resultado
        reset <= 1'b0;
        #20000;

        // testeo
        assert (c === 32'b00000000000000000000000000000000) else $error("error test 2.");
        
        $finish;
       
    end
endmodule
