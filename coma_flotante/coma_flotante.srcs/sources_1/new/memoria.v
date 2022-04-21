`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2022 20:42:13
// Design Name: 
// Module Name: memoria
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


module memoria(
    input [31:0]a,b,
    input clk,
    output y

    );
    
    parameter S_inicial = 2'b00;  
    parameter S_guardar_numeros = 2'b01;  
    parameter S_revisar_si_cambiaron = 2'b10;  
    
    reg [1:0]state,nextstate;

    reg [31:0]aux_a;
    reg [31:0]aux_b;

    // state register
    always@(posedge clk)begin
        state <= nextstate;
    end
   
    // nextstate logic 
    always@* begin
        case(state)
            S_inicial: 
                nextstate = S_guardar_numeros;
                
            S_guardar_numeros:
                nextstate = S_revisar_si_cambiaron;
                
            S_revisar_si_cambiaron:
                if( a == aux_a && b == aux_b ) nextstate = S_revisar_si_cambiaron;
                else nextstate = S_inicial;
 
        endcase        
    end
    
    // output logic
    always @* begin: HOLA     
        if(state == S_guardar_numeros) begin
            aux_a = a;
            aux_b = b;
        end             
    end
    
    assign y = (state == S_inicial) ? 1 : 0;
    
endmodule
