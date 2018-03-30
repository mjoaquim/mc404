@ Mateus Joaquim RA: 184083
@ Lab 2

.org 0x50
@ Reserva memoria para variaveis.
divisor:          .skip      4                    @ Divisor, 2,4,8
num_elem:         .word      0                    @ contador de posicao
vetor:            .skip     128                   @ Espaco p/ o susy submeter a sequencia

inicio:
      set r9, 0xffff0000                          @ Mascara para segundo 16bits
      set r10,0x0000ffff                          @ Mascara para primeiro 16 bits
      set r6, 0xffffffff	                        @ Mascara para xor e transfomar en negativo ou positivo
      set r1, vetor                               @ Seta vetor
      set r0, 0                                   @ Somador
      set r10,0
      ld  r5, num_elem                            @ Numero de elementos


prox_dig:
      set r4,-2


verifica_1:
      set r7, 0x8000	@Inicializa uma máscara 80000000 em r7 para verificar negatividade
      and r7, r4
      jz final_for
      set r10, 1
      xor r4,r6
      add r4, 1





final_for:
      hlt
