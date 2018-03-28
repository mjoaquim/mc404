@ Mateus Joaquim RA: 184083
@ Lab 2


.org 0x100
@ Reserva memoria para variaveis.
divisor:          .skip     4                    @ Caractere procurado
num_elem:    .word      0                   @ contador de posicao
soma:             .word      0
.org 0x200
vetor:            .skip     100                      @ Rotulo p/ o susy submeter a sequencia

.org 0x400

inicio:
      set r1, vetor	                          @seta o endereco
      ld  r4, divisor                         @seta os registradores a cada end
      ld  r5, num_elem
      ld  r0, soma

prox_dig:
      cmp r5, 0	                              @Compara com 0 para verificar se é o último termo
      jle  final_for                          @Se for zero acaba
      ld  r2,[r1]                             @usa os dois registradores para dar os shifts
      ld  r3,[r1]
      shl r3,4*4                              @mais significativo
      shr r3,4*4
      sub r5,1                                @contou 16bits, subtrai
      cmp r5,0
      jle  salva                            @se for zero (ou menor) vai para a divisao
      shr r2,4*4                              @menos significativo
      sub r5,1                                @contou mais 16bits, subtrai
divisao:
      sar r2,1                                @divide por dois os registradores que contem os 16bits e o divisor
      sar r3,1
      sar r4,1
      cmp r4,1                                @so para quando o divisor for 1
      jle soma_total
      jmp divisao

salva:
      set r2,0
      jmp divisao

soma_total:
      add r0,r2                              @soma a divisao ao r0
      add r0,r3
      set r2,0
      set r3,0
      add r1,4
      cmp r5,0
      jle final_for
      jmp prox_dig

subtrai:
      jmp divisao

final_for:


        hlt                                 @ termina a execução
