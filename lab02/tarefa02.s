@ Mateus Joaquim RA: 184083
@ Lab 2


.org 0x50
@ Reserva memoria para variaveis.
divisor:          .skip      4                   @ Divisor, 2,4,8
num_elem:         .word      0                   @ contador de posicao
vetor:            .skip     128                  @ Espaco p/ o susy submeter a sequencia
.org 0x200

inicio:
      set r1, vetor	                             @ Seta o endereco
      ld  r5, num_elem                           @ Carrega o tamanho do vetor
      set r0, 0                                  @ Soma
      set r3, 0
      set r2, 0
      set r10,0
      set r11, 0xffff0000                        @ Mascara para negativos

prox_dig:
      ld  r4, divisor                            @ Reinicia ou inicia o divisor
      ld  r2,[r1]                                @ Usa os dois registradores para dar os shifts
      ld  r3,[r1]
      shl r3,16                                  @ Mais significativo
      shr r3,16
      sub r5,1                                   @ Contou 16bits, subtrai
      shr r2,16                                  @ Menos significativo
      sub r5,1                                   @ Contou mais 16bits, subtrai

verificacao1:
     set r7, 0x00008000	                        @ Inicializa uma máscara 00008000 em r7 para verificar se eh negativo
     and r7,r3
     cmp r7,0                                   @ Se for diferente de zero, eh negativo (8000)
     jz verificacao2
     or r3,r11                                  @ Aplica a mascara
verificacao2:
     set r7, 0x00008000	                        @ Faz a mesma coisa que o bloco acima, porem com o registrador 2, que eh o outro 16bit. se for zero nao acontece nada.
     and r7,r2
     cmp r7,0
     jz divisao
     or r2,r11

 divisao:
     sar r2,1                                   @ Divide por dois os registradores que contem os 16bits e o divisor
     sar r3,1
     sar r4,1
     cmp r4,1                                   @ So sai do laco quando o divisor for 1
     jle soma_total                             @ Vai para a soma, quando acabar o laco
     jmp divisao

soma_total:
    add r0,r2                                  @ Soma a divisao ao r0
    add r0,r3
    set r2,0                                   @ Seta zero pra nao somar lixo, na proxima possivel soma
    set r3,0
    add r1,4                                   @ Avanca apontador
    cmp r5,0                                   @ Ve se acabou a lista
    jle final_for
    jmp prox_dig


final_for:
        hlt                                 @ termina a execução
