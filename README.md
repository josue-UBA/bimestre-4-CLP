# bimestre-4-CLP
proyectos
- ejercicio 1
- ejercicio 2
- ejercicio 3
- final
## complemento 
- a uno [link](https://es.wikipedia.org/wiki/Complemento_a_uno)
- a dos [link](https://es.wikipedia.org/wiki/Complemento_a_dos)
## IEEE 754
- explicacion del protocolo en wikipedia [link](https://en.wikipedia.org/wiki/IEEE_754)
- sesgo de exponente [link](https://hmong.es/wiki/Exponent_bias)
## ejemplo
### teorico numero
- ejemplo 1 [link](https://www.youtube.com/watch?v=27JjUa-eu_E)
- convertir numero (como 1.75) a binario [link](https://www.youtube.com/watch?v=HcjXH9WGmAU)
### teorico multiplicacion
- ejemplo 1 [link](https://www.youtube.com/watch?v=RuKkePyo9zk)
### electronico multiplicacion
- en unos de los comentarios hay un ejemplo de un multiplicador flotante de doble presicion (64 bits) [link](https://www.quora.com/What-is-the-verilog-code-for-floating-point-multiplier)
## calculadora
- de numero centesimal a binario [link](https://www.rapidtables.org/convert/number/decimal-to-binary.html)


# analisis
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


```
10x
10


1000000
```
