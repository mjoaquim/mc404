@Questao 1. Escreva uma funcao Impares que receba como parametros
@• o endereco de um vetor de inteiros (32 bits) sem sinal, no registrador r0
@• o numero de elementos do vetor, no registrador r1.
@O procedimento deve retornar no registrador r0 o numero de elementos ımpares do vetor.


.org 0x200
vetor:        .skip        128
num_elem:     .word        0
impares:      .word        0
mascara       .equ         1

inicio:
    set r0,vetor
    mov r2,r0
    ld r3,mascara
    ld r1,num_elem

prox_inteiro:
    cmp r1,0
    jz final_for
    and r2,r3
    jz soma
    jmp avanca

soma:
    add r0,1
    jmp avanca

avanca:
    sub r1,1
    add r3,4
    ld r2,[r3]
    jmp prox_inteiro



final_for:
  hlt
