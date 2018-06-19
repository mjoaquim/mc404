@mateus Joaquim ra:184083

.global _start         @ ligador precisa do símbolo _start

@ constantes para "commands"
  .set LCD_CLEARDISPLAY,0x01
  .set LCD_RETURNHOME,0x02
  .set LCD_ENTRYMODESET,0x04
  .set LCD_DISPLAYCONTROL,0x08
  .set LCD_CURSORSHIFT,0x10
  .set LCD_FUNCTIONSET,0x20
  .set LCD_SETCGRAMADDR,0x40
  .set LCD_SETDDRAMADDR,0x80
  .set LCD_BUSYFLAG,0x80

@ constantes para "display entry mode"
  .set LCD_ENTRYRIGHT,0x00
  .set LCD_ENTRYLEFT,0x02
  .set LCD_ENTRYSHIFTINCREMENT,0x01
  .set LCD_ENTRYSHIFTDECREMENT,0x00

@ constantes para "display on/off control"
  .set LCD_DISPLAYON,0x04
  .set LCD_DISPLAYOFF,0x00
  .set LCD_CURSORON,0x02
  .set LCD_CURSOROFF,0x00
  .set LCD_BLINKON,0x01
  .set LCD_BLINKOFF,0x00

@ constantes para "display/cursor shift"
  .set LCD_DISPLAYMOVE,0x08
  .set LCD_CURSORMOVE,0x00
  .set LCD_MOVERIGHT,0x04
  .set LCD_MOVELEFT,0x00

@ constantes para "function set"
  .set LCD_8BITMODE,0x10
  .set LCD_4BITMODE,0x00
  .set LCD_2LINE,0x08
  .set LCD_1LINE,0x00
  .set LCD_5x10DOTS,0x04
  .set LCD_5x8DOTS,0x00


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

@ enderecos dispositivos
	.set ADISPLAY_DAT,0x90001
	.set ADISPLAY_CMD,0x90000

@constantes
  .set BIT_READY,1

@ vetor de interrupções
.org  IRQ*4               @ preenche apenas duas posição do vetor, 6 e 7
	b      tratador_fiq

.align 4
tratador_fiq:
    mov r12, lr
    push {r12}
    mov r0,#LCD_RETURNHOME
    bl wr_cmd
    mov	r0,#LCD_DISPLAYCONTROL+LCD_DISPLAYON+LCD_BLINKOFF
    bl wr_cmd
    ldr     r1, =msg_parada_solicitada       @ escreve mensagem no display, segunda linha
    bl write_msg
    pop {r12}
    mov lr, r12
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
  mov	r0,#LCD_DISPLAYCONTROL+LCD_DISPLAYON+LCD_BLINKOFF
  ldr     r1, =msg_proxima
  bx lr

parada:
  mov	r0,#LCD_DISPLAYCONTROL+LCD_DISPLAYON+LCD_BLINKOFF
  ldr     r1, =msg_parada
  bx lr

centro:
  mov	r0,#(LCD_SETDDRAMADDR+64)
  ldr     r1, =name_centro       @ escreve mensagem no display, segunda linha
  bx lr

barao:
  mov	r0,#(LCD_SETDDRAMADDR+64)
  ldr     r1, =name_barao       @ escreve mensagem no display, segunda linha
  bx lr

unicamp:
  mov	r0,#(LCD_SETDDRAMADDR+64)
  ldr     r1, =name_unicamp       @ escreve mensagem no display, segunda linha
  bx lr


  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @ wr_cmd
  @ escreve comando em r0 no display
wr_cmd:
	ldr	r6,=ADISPLAY_CMD @ r6 tem porta display
	ldrb	r5,[r6]
	tst     r5,#LCD_BUSYFLAG
	beq	wr_cmd           @ espera BF ser 1
	strb	r0,[r6]
	mov	pc,lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ wr_dat
@ escreve dado em r0 no display
wr_dat:
	ldr	r6,=ADISPLAY_CMD @ r6 tem porta display
	ldrb	r5,[r6]          @ lê flag BF
	tst     r5,#LCD_BUSYFLAG
	beq	wr_dat           @ espera BF ser 1
	ldr	r6,=ADISPLAY_DAT @ r6 tem porta display
	strb	r0,[r6]
	mov	pc,lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ write_msg
@ escreve cadeia de caracteres apontada por r1, terminada com caractere nulo
write_msg:
	push    {lr}
	mov	r4, #0     @ endereço inicial
write_msg1:
	ldrb    r0,[r1,r4] @ caractere a ser escrito
	teq	r0,#0
	popeq   {pc}       @ final da cadeia
	bl      wr_dat     @ escreve caractere
	add     r1,#1      @ avança contador
	b       write_msg1

flag:
     .word 0


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
mov	r0,#LCD_CLEARDISPLAY
bl      wr_cmd		@ escreve comando no display
bl parada
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl centro
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl c_partida
mov	r0,#LCD_CLEARDISPLAY
bl      wr_cmd		@ escreve comando no display
bl proxima
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl barao
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl b_chegada
mov	r0,#LCD_CLEARDISPLAY
bl      wr_cmd		@ escreve comando no display
bl parada
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl barao
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl b_partida
mov	r0,#LCD_CLEARDISPLAY
bl      wr_cmd		@ escreve comando no display
bl proxima
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl unicamp
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl u_chegada
mov	r0,#LCD_CLEARDISPLAY
bl      wr_cmd		@ escreve comando no display
bl parada
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl unicamp
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl u_partida
mov	r0,#LCD_CLEARDISPLAY
bl      wr_cmd		@ escreve comando no display
bl proxima
bl      wr_cmd		@ escreve comando no display
bl      write_msg
bl centro
bl      wr_cmd		@ escreve comando no display
bl      write_msg
b lab





  @fim
  mov     r0, #0      @ status -> 0
  mov     r7, #1      @ exit é syscall #1
  svc     #0x55       @ executa syscall


msg_proxima:
	.asciz   "Proxima parada: "


msg_parada:
	.asciz   "Esta eh a parada: "


msg_parada_solicitada:
	.asciz   "Parada solicitada"


name_barao:
	.asciz   "Barao Geraldo"


name_centro:
	.asciz   "Centro"


name_unicamp:
	.asciz   "Unicamp"



@buffer onde serao armazenados os caracteres lidos
buffer:
	.skip	256
