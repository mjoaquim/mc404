@ Mateus Joaquim RA: 184083
@ Lab 01


.org 0x50


@ Reserva memoria para variaveis.
i:            .skip     4                   @ Contador
compr:        .skip     4                   @  Numero de elementos da sequencia
resultado:    .skip     4                   @ Armazena o numero
a:            .word     0                   @ A =1
b:            .word     1                   @ b = 0

.org 0x100



.org 0x200
inicio_for:
              set r0,0 @ r0 vai conter i
              ld r1,a @ prepara para os registradores
              ld r2,b @ para o corpo do comando for
teste_for:
              cmp r0,compr @ verifica se executa bloco de comandos do for
              jge final_for @ i>=100? caso verdadeiro, finaliza
corpo_for:
              add r1,r2
              add r0,1 @ i++
              jmp teste_for @ terminou o bloco, executa o teste
final_for:
              st i,r0 @ atualiza valor de i
              st a,r1 @ atualiza valor de a

          hlt                               @ termina a execução
