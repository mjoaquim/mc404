@ Mateus Joaquim RA: 184083
@ Lab 0 Orientacoes:
@ Reserve espaço para três variáveis inteiras na memória, presentes respectivamente nos endereços de rótulo varA, varB e varC. Os endereços de varA, varB e varC devem ser respectivamente 0x100, 0x104 e 0x108. (Utilize a diretivas .skip ou .word para reservar espaço para as variáveis)
@ Coloque no registrador r0 o valor da soma das três variáveis MAIS o valor constante 0x1000.
@ Para testar, você pode inicializar as variáveis com valores conhecidos. Note no entanto que no Susy os valores das variáveis serão diferentes a cada teste (o sistema vai alterar o valor das variáveis antes da execução de sua solução).


.org 0x100


@ Reserva memoria para variaveis.
varA:   .word   0x10                    @  Reserva memoria e inicializa cada uma
varB:   .word   0x20
varC:   .word   0x30

@ Definir constantes
constante .equ 0x1000                   @salva valor da constante


.org 0x200                              @muda para na posicao 200

start:
      set r3,constante                  @ seta r3 ao valor da constante
      ld r2,varC                        @ LOAD (LD) endereco de memoria r2 -> varc
      add r2,r3                         @ soma r2 e r3 e salva em r2
      ld r1,varB                        @ LOAD (LD) endereco de memoria r1 -> varB
      add r1,r2                         @ soma r1 e r2 e salva em r2
      ld r0,varA                        @  LOAD (LD) endereco de memoria r0 -> varA
      add r0,r1                         @ soma r0 e r1
      hlt                               @ termina a execuçãota
