@Quest˜ao 2. Defina, usando diretivas do montador LEG, um vetor de nome vet com 8 elementos inteiros
@(32 bits) quaisquer e uma vari´avel inteira de 32 bits de nome size, com valor inicial 8 (comprimento do
@vetor). Mostre um exemplo de chamada da fun¸c˜ao Impares do exerc´ıcio anterior para determinar o n´umero
@de elementos do vetor vet.


init:
set sp,0x80000 @ pilha inicia no final da mem´oria
set r0,vetor @ endere¸co do vetor
ld r1,num_elem @ n´umero de elementos
call inicio
hlt
num_elem:
.word 4
vet:
.word 1,7,2,5
