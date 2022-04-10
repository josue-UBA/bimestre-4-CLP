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
    
    typedef enum logic [4:0]{
        S_inicial, // inicial
        S_asignacion,
        S_cero, // alguno es 0?
        S_signos, // signos y asignar variables auxiliares
        S_exponentes, // suma de exponentes
        S_mantisa_a, // mantisa a la derecha
        S_mantisa_b, // mantisa b la derecha
        S_multipli, // asignar valor multiplicado a mantica c
        S_mantisa_c, // mantisa c a la izquierda
        S_fin  // fin
        }statetype;
    statetype state, nextstate;
           
    reg [7:0]exp_a;
    reg [7:0]exp_b;
    reg [7:0]exp_c;
    reg [22:0]man_a;
    reg [22:0]man_b;
    reg [22:0]man_c;
    reg sig_c;
    
    // state register
    always_ff@(posedge clk, posedge reset)begin
        if(reset) state <= S_inicial;
        else      state <= nextstate;
    end
    // nextstate logic 
    always_comb begin
        case(state)
            S_inicial: 
                nextstate = S_asignacion;
                
            S_asignacion:
                nextstate = S_cero;
                
            S_cero: 
                if(man_a == 0 || man_b == 0) nextstate = S_fin;
                else nextstate = S_signos;
            
            S_signos: 
                nextstate = S_exponentes;
                
            S_exponentes: 
                nextstate = S_mantisa_a;
                
            S_mantisa_a: 
                if(man_a[0]==0)nextstate = S_mantisa_a;  
                else           nextstate = S_mantisa_b;           
            
            S_mantisa_b: 
                if(man_b[0]==0)nextstate = S_mantisa_b;   
                else           nextstate = S_multipli; 
            
            S_multipli: 
                nextstate = S_mantisa_c; 
                
            S_mantisa_c: 
                if(man_c[22]==0)nextstate = S_mantisa_c;   
                else            nextstate = S_fin; 
                
            S_fin:
                nextstate = S_fin;
             
        endcase
    end
        
    // output logic
    always_ff@(posedge clk) begin
        if(state == S_asignacion)begin
            exp_a <= a[30:23];
            exp_b <= b[30:23];
            man_a <= a[22:0];
            man_b <= b[22:0];
        end
        if(state == S_signos)
            sig_c <= a[31] ^ b[31];        

        else if(state == S_cero && (man_a == 0 || man_b == 0))begin
            sig_c <= 0;
            man_c <= 0;
            exp_c <= 0;
        end

        else if(state == S_exponentes) 
            exp_c <= exp_a + exp_b;
        
        else if(state == S_mantisa_a && man_a[0]==0) 
            man_a <= man_a >> 1;
        
        else if(state == S_mantisa_b && man_b[0]==0) 
            man_b <= man_b >> 1;
        
        else if(state == S_multipli) 
            man_c <= man_a * man_b;
        
        else if(state == S_mantisa_c && man_c[22]==0) 
            man_c <= man_c << 1;
        
        else if(state == S_fin)begin
            c[31] <= sig_c;
            c[30:23] <= exp_c;
            c[22:0] <=man_c;
        end
    end
endmodule


