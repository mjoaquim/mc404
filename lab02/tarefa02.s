@ Mateus Joaquim RA: 184083
@ Lab 2


.org 0x50
@ Reserva memoria para variaveis.
divisor:          .skip      4                    @ Divisor, 2,4,8
num_elem:         .word      0                    @ contador de posicao
vetor:            .skip     128                   @ Espaco p/ o susy submeter a sequencia
.org 0x200

inicio:
      set r1, vetor	                             @Seta o endereco
      ld  r5, num_elem
      set r0, 0
      set r3, 0
      set r2, 0
      set r10,0
      set r11,0

prox_dig:
      ld  r4, divisor                           @Reinicia ou inicia o divisor
      ld  r2,[r1]                               @usa os dois registradores para dar os shifts
      ld  r3,[r1]
      shl r3,16                                 @mais significativo
      shr r3,16
      sub r5,1                                  @contou 16bits, subtrai
      shr r2,16                                 @menos significativo
      sub r5,1                                  @contou mais 16bits, subtrai

verificacao1:
      set r7, 0x00008000	@Inicializa uma máscara 80000000 em r7 para verificar negatividade
      and r7,r3
      cmp r7,0
      jz verificacao2     @ Se for positivo, ja pula para a segunda verificacao, se nao trata e inverte para positivo
      set r10,1           @ seta a flag, para saber que eh negativo e inverter dps
      xor r3,r6
      add r3,1
      @trata o valor negativo

verificacao2:
      set r7, 0x00008000	@Inicializa uma máscara 80000000 em r7 para verificar negatividade
      and r7,r2
      cmp r7,0
      jz divisao          @ Se for positivo, pula para a divisao, se nao trata e inverte para positivo
      set r11,1           @ seta a flag, para saber que eh negativo e precisa inverter denovo depois
      xor r2,r6
      add r2,1
      jmp divisao

divisao:
      sar r2,1                                @divide por dois os registradores que contem os 16bits e o divisor
      sar r3,1
      sar r4,1
      cmp r4,1                                @so para quando o divisor for 1
      jle soma_total                          @vai para a soma, quando acabar o laco
      jmp divisao

inverte:
      set r10,0                               @seta 0 a flag
      set r6, 0xffffffff	                      @Inicializa uma máscara 80000000 em r6 para verificar negatividade
      sub r3,1
      xor r3,r6
      jmp soma_total

inverte2:
      set r11,0
      set r6, 0xfffffffff                    @Inicializa uma máscara 80000000 em r6 para verificar negatividade
      sub r2,1
      xor r2,r6
      jmp soma_total

soma_total:
      cmp r10,1                               @Verifica a flag, se for negativo inverte
      jz  inverte
      cmp r11,1                               @ se for negativo inverte
      jz  inverte2
      add r0,r2                              @soma a divisao ao r0
      add r0,r3
      set r2,0                               @seta zero pra nao somar lixo
      set r3,0
      add r1,4                               @avanca apontador
      cmp r5,0                               @ ve se acabou a lista
      jle final_for
      jmp prox_dig




final_for:
        hlt                                 @ termina a execução
