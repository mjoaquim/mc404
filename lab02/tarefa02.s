@ Mateus Joaquim RA: 184083
@ Lab 2


.org 0x100
@ Reserva memoria para variaveis.
divisor:          .skip     4                    @ Caractere procurado
num_elementos:    .word      0                   @ contador de posicao
soma:             .word      0
.org 0x200
vetor:            .skip     400                      @ Rotulo p/ o susy submeter a sequencia

.org 0x700

inicio:
      set r1, 0x200	                          @Colocando o endereço apontado do primeiro registrador no r1
      ld  r2, vetor                         	@Colocando o endereço apontado do segundo registrador no r2, para ir incrementando
      ld  r3,vetor
      ld  r4, divisor                         @ seta cada variavel em cada registrador
      ld  r5, num_elementos
      ld  r0, soma

prox_dig:
      cmp r5, 0	                             @Compara com 0 para verificar se é o último termo
      jz  final_for                     @ Precisamos fazer uma correcao de contagem a mais, estamos contando a partir do 1, e não da posicao zero de vetor
      shr r2,4*4
      shl r3,4*4
      shr r3,4*4
      sub r5,1                               @incrementa contador
      jmp prox_dig


final_for:


        hlt                                 @ termina a execução
