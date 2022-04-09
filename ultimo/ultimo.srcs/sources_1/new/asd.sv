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
    input logic [31:0]a,b,
    output reg [31:0]c
    );
    
    typedef enum logic [2:0]{
        S0, // inicial
        S1, // signos y asignar variables auxiliares
        S2, // suma de exponentes
        S3, // mantisa a la derecha
        S4, // mantisa b la derecha
        S5, // asignar valor multiplicado a mantica c
        S6, // mantisa c a la izquierda
        S7  // fin
        }statetype;
    statetype state, nextstate;
           
    reg [7:0]exp_a;
    reg [7:0]exp_b;
    reg [22:0]man_a;
    reg [22:0]man_b;
    reg [22:0]man_c;
    
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
                nextstate = S2;
            end
            S2: begin
                nextstate = S3;
            end
            S3: begin
                if(man_a[0]==0)nextstate = S3;  
                else           nextstate = S4;           
            end
            S4: begin
                if(man_b[0]==0)nextstate = S4;   
                else           nextstate = S5; 
            end
            S5: begin
                nextstate = S6;
            end 
            S6: begin
                if(man_c[22]==0)nextstate = S6;   
                else            nextstate = S7; 
            end 
        endcase
    end
        
    // output logic
    always_ff@(posedge clk) begin
        if(state == S1)begin
            c[31] <= a[31] ^ b[31];
            exp_a <= a[30:23];
            exp_b <= b[30:23];
            man_a <= a[22:0];
            man_b <= b[22:0];
        end

        else if(state == S2) begin
            c[30:23] <= exp_a + exp_b;
        end
        
        else if(state == S3 && man_a[0]==0) begin
            man_a <= man_a >> 1;
        end
        
        else if(state == S4 && man_b[0]==0) begin
            man_b <= man_b >> 1;
        end
        
        else if(state == S5) begin
            man_c <= man_a * man_b;
        end
        
        else if(state ==S6 && man_c[22]==0) begin
            man_c <= man_c << 1;
        end
        else if(state ==S7)begin
            c[22:0] <=man_c;
        end
    end
endmodule


