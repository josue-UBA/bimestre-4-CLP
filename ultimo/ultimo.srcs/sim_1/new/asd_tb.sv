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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2022 22:53:18
// Design Name: 
// Module Name: hola
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
    reg [3:0]a,b;
    wire [3:0]c;
   
    always #100 clk = ~ clk;

    localparam period = 200;  

    asd UUT (
        .clk(clk), 
        .reset(reset), 
        .a(a),
        .b(b),
        .c(c));
        
    initial begin
        clk <= 1'b0;

        // primer estado
        reset <= 1'b0;
        a <= 4'b1000;
        b <= 4'b0100;
        #period; // wait for period 

        // primer estado
        reset <= 1'b1;
        //a <= 8'b0000;
        #period;

        // primer estado
        reset <= 1'b0;
        //a <= 8'b0000;
        #period;

     
        $finish;
       
    end
endmodule
