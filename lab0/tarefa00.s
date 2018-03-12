@ Mateus Joaquim RA: 184083
@ Lab 1 Orientacoes:
@ Escreva um programa para calcular o valor da expressão
@ 4*(0x5000 + 0x200)
@ usando apenas os registradores r0 e r1, e deixando o resultado no registrador r0. O seu programa deve ser montado a partir do endereço 0x200.

@ Definir constantes
constante .equ 0x1000

@ Reserva memoria para variaveis.
varA:   .skip   0x100
varB:   .skip   0x104
varC:   .skip   0x108


.org 0x200

start:               @ um rótulo padrão, vamos usar no Susy
      set r0, varA         @ Seta
      set r1, varB
      set r2, varC
      set r3, constante
      add r0,r1
      add r0,r2
      add r0,r3
      hlt                     @ a execução
