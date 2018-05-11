@ Mateus Joaquim RA184083
@ Lab #teste2

strncpy:
  cmp r2,#0
  beq termina
  sub r2,#1
  ldrb r3,[r0]
  strb r3,[r1]
  add r0,#1
  add r1,#1
  add r4,#1
  b strncpy

  .global _start
  .org 0x1000
_start:
  b strncpy


termina:
  mov r5,#0
  strb r5,[r1]
  mov r0,r4
  mov r7,#1
  swi #0x55      @ invoke syscall
