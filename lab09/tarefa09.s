@mateus Joaquim ra:184083

.global _start         @ ligador precisa do símbolo _start

@ flag para habilitar interrupções externas no registrador de status
  .set IRQ, 0x6
  .set FIQ, 0x7

@ endereços das pilhar
  .set STACK,     0x80000
  .set STACK_FIQ, 0x72000
  .set STACK_IRQ, 0x70000

@ modos de inr1terrupção no registrador de status
  .set IRQ_MODE,0x12
  .set FIQ_MODE,0x11
  .set USER_MODE,0x10

@ endereços dos dispositivos
	.set PARADA,0xd0000
	.set btn_centro_chegada,0xa0000
  .set btn_centro_partida,0xa0001
  .set btn_barao_chegada,0xa0002
  .set btn_barao_partida,0xa0003
  .set btn_unicamp_chegada,0xa0004
  .set btn_unicamp_partida,0xa0005

@constantes
  .set BIT_READY,1

@ vetor de interrupções
.org  IRQ*4               @ preenche apenas duas posição do vetor, 6 e 7
	b      tratador_fiq

.align 4
tratador_fiq:
    mov     r0, #1      @ fd -> stdout
    ldr     r1, =msg_parada_solicitada    @ buf -> msg
    ldr     r2, =msg_parada_solicitada_len    @ count -> len(msg)
    mov     r7, #4      @ write é syscall #4
    svc     0x055       @ executa syscall
    movs	pc,lr		@ e retorna


@ le botao
c_chegada:
  ldr	r3,=btn_centro_chegada
  ldr	r4,[r3]               @ verifica botao start
  cmp	r4,#BIT_READY         @ foi pressionado?
  bne	c_chegada             @ se nao foi, continua
  bx lr

c_partida:
  ldr	r3,=btn_centro_partida
  ldr	r4,[r3]               @ verifica botao start
  cmp	r4,#BIT_READY         @ foi pressionado?
  bne	c_partida             @ se nao foi, continua
  bx lr

b_chegada:
  ldr	r3,=btn_barao_chegada
  ldr	r4,[r3]               @ verifica botao start
  cmp	r4,#BIT_READY         @ foi pressionado?
  bne	b_chegada             @ se nao foi, continua
  bx lr

b_partida:
  ldr	r3,=btn_barao_partida
  ldr	r4,[r3]               @ verifica botao start
  cmp	r4,#BIT_READY         @ foi pressionado?
  bne	b_partida             @ se nao foi, continua
  bx lr

u_chegada:
  ldr	r3,=btn_unicamp_chegada
  ldr	r4,[r3]               @ verifica botao start
  cmp	r4,#BIT_READY         @ foi pressionado?
  bne	u_chegada             @ se nao foi, continua
  bx lr

u_partida:
  ldr	r3,=btn_unicamp_partida
  ldr	r4,[r3]               @ verifica botao start
  cmp	r4,#BIT_READY         @ foi pressionado?
  bne	u_partida             @ se nao foi, continua
  bx lr

proxima:
  mov     r0, #1      @ fd -> stdout
  ldr     r1, =msg_proxima    @ buf -> msg
  ldr     r2, =msg_proxima_len    @ count -> len(msg)
  mov     r7, #4      @ write é syscall #4
  svc     0x055       @ executa syscall
  bx lr

parada:
  mov     r0, #1      @ fd -> stdout
  ldr     r1, =msg_parada    @ buf -> msg
  ldr     r2, =msg_parada_len    @ count -> len(msg)
  mov     r7, #4      @ write é syscall #4
  svc     0x055       @ executa syscall
  bx lr

centro:
  mov     r0, #1      @ fd -> stdout
  ldr     r1, =name_centro    @ buf -> msg
  ldr     r2, =name_centro_len    @ count -> len(msg)
  mov     r7, #4      @ write é syscall #4
  svc     0x055       @ executa syscall
  bx lr

barao:
  mov     r0, #1      @ fd -> stdout
  ldr     r1, =name_barao    @ buf -> msg
  ldr     r2, =name_barao_len    @ count -> len(msg)
  mov     r7, #4      @ write é syscall #4
  svc     0x055       @ executa syscall
  bx lr

unicamp:
  mov     r0, #1      @ fd -> stdout
  ldr     r1, =name_unicamp    @ buf -> msg
  ldr     r2, =name_unicamp_len    @ count -> len(msg)
  mov     r7, #4      @ write é syscall #4
  svc     0x055       @ executa syscall
  bx lr

.org 0x200
_start:
mov	sp,#0x500	                    @ seta pilha do modo supervisor
mov	r0,#IRQ_MODE	                @ coloca processador no modo IRQ (interrupção externa)
msr	cpsr,r0		                    @ processador agora no modo IRQ
mov	sp,#STACK_IRQ	                @ seta pilha de interrupção IRQ
mov	r0,#FIQ_MODE	                @ coloca processador no modo IRQ (interrupção externa)
msr	cpsr,r0		                    @ processador agora no modo FIQ
mov	sp,#STACK_FIQ	                @ seta pilha de interrupção FIQ
mov	r0,#USER_MODE	                @ coloca processador no modo usuário
bic  r0,r0,#(IRQ+FIQ)             @ interrupções FIQ e IRQ habilitadas
msr	cpsr,r0		                    @ processador agora no modo usuário
mov	sp,#STACK	                    @ pilha do usuário no final da memória
bic  r0,r0,#(IRQ+FIQ)             @ interrupções FIQ e IRQ habilitadas
mov r5,#0

lab:
bl c_chegada
bl parada
bl centro
bl c_partida
bl proxima
bl barao
bl b_chegada
bl parada
bl barao
bl b_partida
bl proxima
bl unicamp
bl u_chegada
bl parada
bl unicamp
bl u_partida
bl proxima
bl centro
b lab





  @fim
  mov     r0, #0      @ status -> 0
  mov     r7, #1      @ exit é syscall #1
  svc     #0x55       @ executa syscall


msg_proxima:
	.ascii   "Proxima parada: "
msg_proxima_len = . - msg_proxima

msg_parada:
	.ascii   "Esta eh a parada: "
msg_parada_len = . - msg_parada

msg_parada_solicitada:
	.ascii   "Parada solicitada\n"
msg_parada_solicitada_len = . - msg_parada_solicitada

name_barao:
	.ascii   "Barao Geraldo\n"
name_barao_len = . - name_barao

name_centro:
	.ascii   "Centro\n"
name_centro_len = . - name_centro

name_unicamp:
	.ascii   "Unicamp\n"
name_unicamp_len = . - name_unicamp


@buffer onde serao armazenados os caracteres lidos
buffer:
	.skip	256
