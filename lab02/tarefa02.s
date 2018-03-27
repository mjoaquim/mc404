@ Mateus Joaquim RA: 184083
@ Lab 2


.org 0x100
@ Reserva memoria para variaveis.
divisor:          .skip     4                    @ Caractere procurado
num_elementos:    .word      0                    @ contador de posicao
flag:             .word      0                    @ flag para verificacao se achou o caractere em todo o vetor ou não

.org 0x200
vetor:            .skip     400                      @ Rotulo p/ o susy submeter a sequencia

.org 0x700

inicio:
      set r1, 0x200	                          @Colocando o endereço apontado do primeiro registrador no r1
      ld r2, vetor                         	@Colocando o endereço apontado do segundo registrador no r2, para ir incrementando
      ld  r4, divisor                         @ seta cada variavel em cada registrador
      ld  r5, num_elementos

prox_dig:
      cmp r5, 0	                             @Compara com 0 para verificar se é o último termo
      jz  final_for                     @ Precisamos fazer uma correcao de contagem a mais, estamos contando a partir do 1, e não da posicao zero de vetor
      set r0, 0x0f
      and r2,r0
      sub r5,1                               @incrementa contador
      jmp prox_dig                           @ volta o loop




final_for:


        hlt                                 @ termina a execução
