@ Mateus Joaquim RA: 184083
@ Lab 01


@ Definir constantes
constante .equ 0x1000

@ Reserva memoria.
varA:   .skip   0x100
varB:   .skip   0x104
varC:   .skip   0x108


.org 0x200

start:                     @ um rótulo padrão, vamos usar no Susy
      set r0, varA         @ Seta r0 com varA
      set r1, varB         @ Seta r1 com varB
      set r2, varC         @ Seta r2 com varC
      set r3, constante    @ seta r3 com a constante
      add r0,r1            @ adiciona r1 e r0 e armazena em r0
      add r0,r2            @ adiciona r0 e r2 e armazena em r0
      add r0,r3            @ adiciona r0 e r3 e armazena em r0
      hlt                  @ termina a execução
