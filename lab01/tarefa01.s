@ Mateus Joaquim RA: 184083
@ Lab 01


.org 0x50
limite          .equ      100               @ Constante com o limite
limiteinferior  .equ     -100               @ limite inferior para comparacao

.org 0x64
sequencia:      .skip     400               @ Rotulo p/ o susy submeter a sequencia

.org 0x290
@ Reserva memoria para variaveis.
compr:        .skip     4                   @ Numero de elementos da sequencia
resultado:    .skip     4                   @ Salvar o resultado


.org 0x298
inicio:
        set r0,0                            @ Resultado = 0
        ld r1, compr                        @ R1 = COMPRIMENTO
        set r2, 0x64                        @ Registrador que vai apontar
        ld r3, sequencia                    @ Pega primeiro valor da sequencia


corpo_for:
        cmp r3,limite                       @ Compara
        jg pula                             @ Maior que 100, pula
        cmp r3,limiteinferior               @ Compara
        jl pula                             @ Menor que -100, pula
        add r0,1                            @ Esta no intervalo, então adiciona 1 no resultado

pula:
        add r2,4                            @ Incrementa o valor do endereco
        ld r3,[r2]                          @ Ponteiro
        sub r1,1                            @ Diminui o tamanho da lista
        jz final_for                        @ Se for igual a 0 acaba o laco
        jmp corpo_for                       @ Reinicia o laco

final_for:
        st resultado, r0                    @ Seta para conferir com o susy
        hlt                                 @ termina a execução
