`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2022 17:15:47
// Design Name: 
// Module Name: multi_flotante_tb
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


module multi_flotante_tb();

    reg clk,reset;
    reg [31:0]a,b;
    wire [31:0]c;
   
    always #100 clk = ~ clk;

    localparam period = 200;  

    multi_flotante UUT (
        .clk(clk), 
        .reset(reset), 
        .a(a),
        .b(b),
        .c(c));
        
    initial begin
        clk <= 1'b0;

        /************************************************* PRIMER TEST 
        ------------------------------------------      
        P0: se dan los siguientes numeros
        ------------------------------------------
        A = -17.5 
        B = 1.15625
        C = resultado
                 
        ------------------------------------------
        P1: se multiplicaran los siguientes valores
        ------------------------------------------
           -17.5 x 1.15625 =    -20.234375  (decimal)
           
        ------------------------------------------
        P2: se transforman a binario
        ------------------------------------------
        dos a la | 7 6 5 4 3 2 1 0|-1-2-3-4-5
        ---------+----------------+----------
                 | 1              |0 0 0 0 0 0
                 | 2 6 3 1        |. . . . . .
                 | 8 4 2 6 8 4 2 1|5 2 1 0 0 0
                 |                |  5 2 6 3 1
                 |                |    5 2 1 5
                 |                |      5 2 6
                 |                |        5 2
                 |                |          5
        ---------+----------------+----------
                       - 1 0 0 0 1.1           = -17.5
                                 1.0 0 1 0 1   =   1.15625
                       - 1 0 1 0 0.0 0 1 1 1 1 = -20.234375
        
        -10001.1 x 1.00101 = -10100.001111  (binario)

        ------------------------------------------
        P3: se normalizan los valores binarios
        ------------------------------------------
        -10001.1      = -1.00011      x 2^(4)
        +    1.00101  = +1.00101      x 2^(0)
        -10100.001111 = -1.0100001111 x 2^(4)
        
        ------------------------------------------
        P4: se sesgan las potencias:
        ------------------------------------------
        A_potencia: 127 + 4 = 131 = 10000011
        B_potencia: 127 + 0 = 127 = 01111111
        C_potencia: 127 + 4 = 131 = 10000011
        
        ------------------------------------------
        P5: se arma la trama
        ------------------------------------------
        +-+--------+-----------------------+        
        |s| expone |        mantisa        |
        +-+--------+-----------------------+
        |3|32222222|2221111111111          |
        |1|09876543|21098765432109876543210| posicion partiendo de 0 LMSB
        +-+--------+-----------------------+        
        |1|10000011|00011000000000000000000| primer numero
        |0|01111111|00101000000000000000000| segundo numero
        |1|10000011|01000011110000000000000| resultado
        +-+--------+-----------------------+        
        
        *************************************************/
        
        // inicio del test. Se pone los valores a a y b
        reset <= 1'b0;
        a <= 32'b11000001100011000000000000000000;
        b <= 32'b00111111100101000000000000000000;
        #period; 

        // reseteo
        reset <= 1'b1;
        #period;

        // espero al resultado
        reset <= 1'b0;
        #15000;

        // testeo
        $display("inicia assert 1...");
        if(c === 32'b11000001101000011110000000000000) 
            $display("test 1 correcto!!!");
        else 
            $display("error en test 1.");
            
            
        /************************************************* SEGUNDO TEST 
        *************************************************/
        // inicio del test. Se pone los valores a a y b
        reset <= 1'b0;
        a <= 32'b00000000000000000000000000000000;
        b <= 32'b00000000000000000000000000000000;
        #period; 

        // reseteo
        reset <= 1'b1;
        #period;

        // espero al resultado
        reset <= 1'b0;
        #5000;

        // testeo
        $display("inicia assert 2...");
        if(c === 32'b00000000000000000000000000000000) 
            $display("test 2 correcto!!!");
        else 
            $display("error en test 2.");
        
  
        $finish;
       
    end
endmodule

