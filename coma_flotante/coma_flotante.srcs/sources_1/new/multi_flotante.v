`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2022 17:12:25
// Design Name: 
// Module Name: multi_flotante
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


module multi_flotante(

    input clk,reset,
    input [31:0]a,b,
    output reg [31:0]c
    );
    
    parameter S_inicial = 4'b0000; /* 
    - todos los registos a 0 */
    parameter S_asignacion = 4'b0001; /*
    - se asigna los valores a,b a los registros segun corresponda 
    - antes de pasar la mantisa al registro, la mantisa tiena la siguiente forma 10100000 = 1.101
    - al pasar al registro toma la siguiente forma 10100000 con exponente 2^-8
    - una vez hecho esto con a y b estamos listos para hacer operaciones normales */
    parameter S_cero = 4'b0010; /* 
    - si alguna mantisa es 0 se acaba la logica */
    parameter S_signos = 4'b0011; /* 
    - se genera el signo de c */
    parameter S_mantisa_a= 4'b0100; /*
    - podriamos trabajar asi, pero se busca que la multiplicacion de registros mantisas no sea tan grande ( 10010000000 * 10100000000)
    - lo que hacemos es dividir el registro mantisa entre 2 y multiplicar el registro exponente por 2 hasta que no se tenga 0 a la derecha.
    - mantisa a la derecha */
    parameter S_mantisa_b = 4'b0101; /* 
    - hacemos lo mismo aqui... */
    parameter S_exponentes = 4'b0110; /* 
    - obtenemos exponente de c */
    parameter S_multipli = 4'b0111; /* 
    - obtenemos mantisa de c */
    parameter S_mantisa_c = 4'b1000; /* 
    - aqui ya nos olvidamos del registro, la idea es pasarlo al formato IEEE 754 
    - usamos esta ecuacion: [BUS] - [0 en la izquierda] = [numero normalizado] */
    parameter S_mantisa_c_2 = 4'b1001;/*
    - */
    parameter S_fin = 4'b1010; /* 
    - fin */
      
    reg [3:0] state,nextstate;

      
    /* los registros son memorias lo suficientemente grandes
    para hacer operaciones sin tener la preocupacion de tener 
    un overflow */
    reg [31:0]exp_a;
    reg [31:0]exp_b;
    reg [31:0]exp_c;
    reg [31:0]man_a;
    reg [31:0]man_b;
    reg [31:0]man_c;
    reg sig_c;
    
    // state register
    always@(posedge clk, posedge reset)begin
        if(reset) state <= S_inicial;
        else      state <= nextstate;
    end
    
    // nextstate logic 
    always@* begin
        case(state)
            S_inicial: 
                nextstate = S_asignacion;
                
            S_asignacion:
                nextstate = S_cero;
                
            S_cero: 
                if( (man_a == 32'h00800000 && exp_a == 32'hFFFFFF6A) || (man_b == 32'h00800000 && exp_b == 32'hFFFFFF6A) ) nextstate = S_fin;
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
    always@(posedge clk) begin
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
            exp_a <= a[30:23] - 23 - 127;
            exp_b <= b[30:23] - 23 - 127;
            man_a[23] <= 1'b1;
            man_b[23] <= 1'b1;
            man_a[22:0] <= a[22:0];
            man_b[22:0] <= b[22:0];
        end
    
        else if(state == S_cero && ( (man_a == 32'h00800000 && exp_a == 32'hFFFFFF6A) || (man_b == 32'h00800000 && exp_b == 32'hFFFFFF6A) ) )begin
            sig_c <= 0;
            man_c <= 0;
            exp_c <= 32'hFFFFFF81; // = -127 es el menor exponente que se pueda tener segun IEEE 754
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
            exp_c <= exp_a + exp_b;

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
            c[30:23] <= exp_c[7:0] + 127;
            c[22:0] <=man_c[31:9];
        end
    end
endmodule



