`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UBA
// Engineer: Josue Huaman
// 
// Create Date: 09.04.2022 10:58:01
// Design Name: Multiplicador coma flotante
// Module Name: Multiplicador coma flotante
// Project Name: Multiplicador coma flotante
// Target Devices: ARTY-Z7-10
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
        S_mantisa_c_2,
        S_fin  // fin
        }statetype;
    statetype state, nextstate;
           
    reg [31:0]exp_a;
    reg [31:0]exp_b;
    reg [31:0]exp_c;
    reg [31:0]man_a;
    reg [31:0]man_b;
    reg [31:0]man_c;
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
                nextstate = S_mantisa_a;
                                
            S_mantisa_a: 
                if(man_a[0]==0)nextstate = S_mantisa_a;  
                else           nextstate = S_mantisa_b;           
            
            S_mantisa_b: 
                if(man_b[0]==0)nextstate = S_mantisa_b;   
                else           nextstate = S_exponentes; 
            
            S_exponentes: 
                nextstate = S_multipli;            
            
            S_multipli: 
                nextstate = S_mantisa_c; 
                
            S_mantisa_c: 
                if(man_c[31]==0)nextstate = S_mantisa_c;   
                else            nextstate = S_mantisa_c_2; 
                
            S_mantisa_c_2:
                nextstate = S_fin; 
           
            S_fin:
                nextstate = S_fin;
             
        endcase
    end
        
    // output logic
    always_ff@(posedge clk) begin
        if(state == S_inicial)begin
            exp_a <= 0;
            exp_b <= 0;
            exp_c <= 0;
            man_a <= 0;
            man_b <= 0;
            man_c <= 0;
            sig_c <= 0;
        end
        
        else if(state == S_asignacion)begin
            exp_a[7:0] <= a[30:23] - 23;
            exp_b[7:0] <= b[30:23] - 23;
            man_a[23] <= 1'b1;
            man_b[23] <= 1'b1;
            man_a[22:0] <= a[22:0];
            man_b[22:0] <= b[22:0];
        end
        
        else if(state == S_cero && (man_a[31:0] == 0 || man_b[31:0] == 0))begin
            sig_c <= 0;
            man_c <= 0;
            exp_c <= 0;
        end

        else if(state == S_signos)
            sig_c <= a[31] ^ b[31];        

        else if(state == S_mantisa_a && man_a[0]==0)begin 
            man_a <= man_a >> 1;
            exp_a <= exp_a + 1;
        end        
        
        else if(state == S_mantisa_b && man_b[0]==0)begin 
            man_b <= man_b >> 1;
            exp_b <= exp_b + 1;
        end
        
        else if(state == S_exponentes) 
            exp_c <= exp_a + exp_b - 127;

        else if(state == S_multipli) 
            man_c <= man_a * man_b;
        
        else if(state == S_mantisa_c && man_c[31]==0)begin
            man_c <= man_c << 1;
            exp_c <= exp_c - 1;
        end
        
        else if(state == S_mantisa_c_2)begin
            man_c <= man_c << 1;
            exp_c <= exp_c - 1 + 32;
        end
        
        else if(state == S_fin)begin
            c[31] <= sig_c;
            c[30:23] <= exp_c[7:0];
            c[22:0] <=man_c[31:9];
        end
    end
endmodule


