@ Mateus Joaquim RA: 184083
@ Lab 01


.org 0x50
i:            .word     0                   @ Contador
limsuperior   .equ      0x64                @ Constante com os limites para poder comparar
liminferior   .equ      -0x64


.org 0x100
sequencia:                                  @ Rotulo p/ o susy submeter a sequencia


.org 0x10a0
@ Reserva memoria para variaveis.
compr:        .skip     4                   @ Numero de elementos da sequencia
resultado:    .skip     4                   @ Salvar o resultado



inicio:
        ld r0, compr
        @mov r1,r2 @ guarda apontador para in´ıcio do vetor
        @ld r0,[r1] @ e valor m´aximo corrente (o primeiro valor)
proximo:
        add r2,4 @ avan¸ca ponteiro para pr´oximo elemento
        sub r3,1 @ um elemento a mais verificado
        jz final @ terminou de verificar todo o vetor?
        ld r4,[r2] @ n~ao, ent~ao toma mais um valor
        cmp r0,r4 @ compara com m´aximo corrente
        jnc proximo @ desvia se menor ou igual
        mov r1,r2 @ achamos um maior, guarda novo apontador
        mov r0,r4 @ e novo m´aximo
        jmp proximo @ e continua a percorrer o vetor
final:
        sub compr, 1            @ final do trecho
        @jl desvia se menor (com sinal)
        @jg desvia se maior (com sinal)
        @jnz


          hlt                               @ termina a execução
