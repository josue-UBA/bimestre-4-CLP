`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2022 10:58:01
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
    input logic clk,reset,
    input logic [3:0]a,
    output reg [3:0]c
    );
    
    typedef enum logic [1:0]{S0,S1,S2}statetype;
    statetype state, nextstate;
           
    reg [3:0]aux;
    
    // state register
    always_ff@(posedge clk, posedge reset)begin
        if(reset) state <= S0;
        else      state <= nextstate;
    end
    // nextstate logic 
    always_comb begin
        case(state)
            S0:            nextstate = S1;
            S1:if(c[0]==0) nextstate = S1;
               else        nextstate = S2;
        endcase
    end
        
    // output logic
    always_ff@(posedge clk) begin
        if(state == S0)c <= a;
        else if(state == S1) begin
            c <= c >> 1;
        end
    end
endmodule


