@ Mateus Joaquim RA: 184083
@ Lab 1 Orientacoes:
@ Escreva um programa para calcular o valor da expressão
@ 4*(0x5000 + 0x200)
@ usando apenas os registradores r0 e r1, e deixando o resultado no registrador r0. O seu programa deve ser montado a partir do endereço 0x200.

.org 0x200

start:               @ um rótulo padrão, vamos usar no Susy
  set r0,0x7000 @ carrega primeiro termo da soma
  set r1,0x0400 @ carrega segundo termo
  add r0,r1 @ e soma os dois termos
  hlt                @ esta instrução faz com que o montador interrompa
                     @ a execução
