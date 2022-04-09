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
    input logic [3:0]a,b,
    output reg [3:0]c
    );
    
    typedef enum logic [1:0]{S0,S1,S2,S3}statetype;
    statetype state, nextstate;
           
    reg [3:0]aux_a;
    reg [3:0]aux_b;
    
    // state register
    always_ff@(posedge clk, posedge reset)begin
        if(reset) state <= S0;
        else      state <= nextstate;
    end
    // nextstate logic 
    always_comb begin
        case(state)
            S0: 
                nextstate = S1;
            S1: begin
                if(aux_a[0]==0)nextstate = S1;  
                else           nextstate = S2;           
            end
            S2: begin
                if(aux_b[0]==0)nextstate = S2;   
                else           nextstate = S3; 
            end    
        endcase
    end
        
    // output logic
    always_ff@(posedge clk) begin
        if(state == S0)begin
            aux_a <= a;
            aux_b <= b;
        end
        else if(state == S1 && aux_a[0]==0) begin
            aux_a <= aux_a >> 1;
        end
        else if(state == S2 && aux_b[0]==0) begin
            aux_b <= aux_b >> 1;
        end
        else if(state == S3) begin
            c <= aux_a * aux_b;
        end
    end
endmodule


