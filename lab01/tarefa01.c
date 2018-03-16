#include <stdio.h>

#define COMPR 8 /* apenas neste exemplo, sequência pode ter até 100 elementos */
#define MAXVAL 100
#define MINVAL -100

int main(void) {
  int sequencia[COMPR]={-100,-100,3,10,0,70,-10,-88}; // a sequência dada
  int i;          // variável auxiliar
  int compr;      // comprimento da sequência dada
  int resultado;  // onde o resultado vai ser armazenado
  int *p;         // apontador para inteiros, vai ser usado para percorrer a sequência

  resultado = 0;  // inicializa resultado
  compr = COMPR;  // inicializa comprimento da sequuência
  p = &sequencia[0];   // inicializa apontador para percorrer a sequência
  for (i=0; i < compr; i++) {
    if (*p >= -100 && *p  <= 100)
      resultado++; // se condições satisfeitas, adiciona um ao resultado
    p++;           // atenção: o ponteiro é incrementado de 1 em C,
                   // mas o compilador C sabe que *p é um inteiro, então
                   // a cada passo do comando for p avança de quatro em quatro bytes
                   // (um inteiro tem quatro bytes)
  }
  // em linguagem de montagem ainda não vimos como implementar E/S
  // apenas para visualizar a saída do programa C
  printf("resultado: %d\n",resultado);
}
