`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2022 21:01:24
// Design Name: 
// Module Name: asd
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


module asd(
    input clock,reset,
    input [3:0]a,
    output [3:0]c
    );
       
    parameter state1 = 2'b00;
    parameter state2 = 2'b01;
    parameter state3 = 2'b10;

    reg [1:0] state = state1;
    
    reg [3:0]aux;
    
    always_ff@(posedge clock,reset)begin
        if(reset)begin
            state <= state1;
            aux <= a;
        end
        case(state)
            state1:begin
                if(aux[0] == 0)begin
                    aux <= aux >> 1;
                end
                else begin
                    state <= state2;
                end
            end
        endcase
    end
endmodule
