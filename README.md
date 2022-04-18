# Proyecto
Diseño de multiplicador de coma flotante de 32 bits. Se solicita hacer el testeo con workbench y VIO (virtual input/output de Xilinx).

![](fotos/captura.png)
# Entregable
- __multi_flotante.v__: Hardware en verilog. 
- __multi_flotante_tb.v__: codigo verilog para testear el hardware _multi_flotante.v_.
- testeo en workbench y VIO.

# Protocolo IEEE 754
aqui se encontrara refencia del protocolo:
- explicacion del protocolo en wikipedia [link](https://en.wikipedia.org/wiki/IEEE_754)
- sesgo de exponente [link](https://hmong.es/wiki/Exponent_bias)
## flotante decimal a binario
ejemplo de como se transforman numeros flotantes en decimal a binario:
- ejemplo 1 [link](https://www.youtube.com/watch?v=27JjUa-eu_E)
- convertir numero (como 1.75) a binario [link](https://www.youtube.com/watch?v=HcjXH9WGmAU)
## multiplicacion
paso a paso de como multiplicar dos numeros binarios en formato flotante haciendo uso del protoolo IEEE 754 
- ejemplo 1 [link](https://www.youtube.com/watch?v=RuKkePyo9zk)

implentacion de la multiplicacion binaria de dos numetos flotantes en verilog (hardware)
- en unos de los comentarios hay un ejemplo de un multiplicador flotante de doble presicion (64 bits) [link](https://www.quora.com/What-is-the-verilog-code-for-floating-point-multiplier)


# Diseño
Para este desarrollo se uso una maquina de estados Mealy. Me guie de la maquina de estados del libro __ISBN: 978-0-12-800056-4__, capitulo 4.6.

![](fotos/libro.png)

![](fotos/state_machine.png)

Para poder agregar el hardware al bloque de diseño, el HDL a utilizar debe ser verilog y no system verilog, que es el HDL que el libro usa.

![](fotos/hdl.png)

Se consideraron las siguientes equivalencias entre system verilog y verilog para hacer funcionar el hardware:

 de (system verilog)... | a (verilog)... 
| - | -
input logic | input
output logic | output
typedef enum logic [1:0] {<br/>S0,<br/> S1,<br/> S2} statetype; | parameter S0 = 2'b00;<br/>parameter S1 = 2'b01;<br/>parameter S2 = 2'b10;<br/>
statetype state, nextstate; | reg [1:0] state, nextstate;
always_ff@ | always@ 
always_comb | always@*

Se diseño el conjunto de pasos de la maquina de estados: 

![](fotos/maquina_de_estados.png)

```
 3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
|-|- - - - - - - -|- - - - - - - - - - - - - - - - - - - - - - -|
```
## ejemplo 1
convertir 17.5 a binario
- primero convertir 17.5 a binario
```
dos a la | 7 6 5 4 3 2 1 0|-1-2-3-4-5
---------+----------------+----------
         | 1              |0 0 0
         | 2 6 3 1        |. . .
         | 8 4 2 6 8 4 2 1|5 2 1
         |                |  5 2
         |                |    5
---------+----------------+----------         
                 1 0 0 0 1.1   = 17.5
```
- luego se tiene que normalizar el 10001.1 de la siguiente manera

```
10001.1(binario) = 1.00011 x 2^4(binario)
```
- luego se tiene que sumar 127 al exponente y el resultado convertirlo a binario
```
4 + 127 = 131(decimal)

dos a la | 7 6 5 4 3 2 1 0|-1-2-3-4-5
---------+----------------+----------
         | 1              |0 0 0
         | 2 6 3 1        |. . .
         | 8 4 2 6 8 4 2 1|5 2 1
         |                |  5 2
         |                |    5
---------+----------------+----------         
           1 0 0 0 0 0 1 1     = 131
```
- luego se tiene que convertir el numero 
  - signo (0): por ser positivo
  - exponente (10000011): que es 131 convertido a binario
  - numero (00011000000000000000000): porque se le tiene que quitar el primer 1 y luego se completa con 0s a la derecha
  
- resultado:
```
signo  exponente                   numero
|-|- - - - - - - -|- - - - - - - - - - - - - - - - - - - - - - -|
 0 1 0 0 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
```

# Despliegue

## PROJECT MANAGER

- abrir __Vivado__, seleccionar la tarjeta __arty z7 10__ y crear un proyecto.
- copiar y pegar los archivos __multi_flotante.v__ y __multi_flotante_tb.v__. Ponerlos en las carpetas de hardware y testbench respectivamente.

## IP INTEGRATOR

- crear diseño
- mandar el hardware al diseño

![](fotos/paso_1.png)

- diseñar el siguiente esquema en el diseño creado

![](fotos/paso_2.png)

- crear wrapper

## SIMULATION
- dar click en __Run Simulation__ para iniciar el testeo del archivo __multi_flotante_tb.v__. Asegurarse que este se encuentra como top en la carpeta de test. Dar click en __Tcl Console__ para ver si el testbench funciono correctamente.

![](fotos/paso_8.png)

## RTL ANALYSIS
Dar click en __Schematic__ para tener un detalle del hardware completo.
![](fotos/paso_9.png)

## SYNTHESIS

- ejecutar __Run Synthesis__ dandole click. Luego dar click en __SYNTHESIS__. Dar click a __I/O Ports__.

![](fotos/paso_3.png)

- editar para que quede asi (nos guiamos de las siguientes fuentes oficiales [manual de refencia de la placa](https://digilent.com/reference/programmable-logic/arty-z7/reference-manual) y [constraints](https://github.com/Digilent/digilent-xdc/blob/master/Arty-Z7-10-Master.xdc)):

![](fotos/paso_4.png)

## IMPLEMENTATION

- dar click a __Run Implementation__.

## PROGRAM AND DEBUG

- dar click en __Generate Bitstream__, luego __Open Target__ y luego __Program Device__.
- abrir VIO

![](fotos/paso_5.png)

- agregar todas las entradas del VIO y testear ([documentacion oficial](https://www.xilinx.com/products/intellectual-property/vio.html#Documentation))

![](fotos/paso_6.png)

- ver test

![](fotos/paso_7.png)

# Entorno
- __sistema operativo__: windows 10
- __tarjeta de desarrollo__: arty z7 10
- __IDE__: Vivado 2020.2
- __hardware description language__: verilog

# estructura del proyecto 
```
|-- hola (repositorio)
    |-- fotos (imagenes)
    |-- Untitled.mdj (diagrama de maquina de estados)
    |-- README.md (documentacion)
    |-- ultimo
        |-- ultimo.srcs
            |-- sim_1
                |-- new
                    |-- multi_flotante_tb.v (testeo)
            |-- sources_1
                |-- new
                    |-- multi_flotante.v (hardware)
```

# Links
## complemento 
- a uno [link](https://es.wikipedia.org/wiki/Complemento_a_uno)
- a dos [link](https://es.wikipedia.org/wiki/Complemento_a_dos)
## calculadora
- de numero centesimal a binario [link](https://www.rapidtables.org/convert/number/decimal-to-binary.html)
- binario a hexadecimal [link](https://cual-es-mi-ip.online/herramientas/conversores-numericos/conversor-binario-a-hexadecimal/)
- hexadecimal a binario [link](https://cual-es-mi-ip.online/herramientas/conversores-numericos/conversor-hexadecimal-a-binario/)
- hexadecimal a decimal [link](https://cual-es-mi-ip.online/herramientas/conversores-numericos/conversor-hexadecimal-a-decimal/)
