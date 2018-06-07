@Mateus Joaquim RA184083

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
	.set BOTAO,0xd0000
	.set TIMER,0xc0000
  .set LEDS, 0x90000
  .set TECLADO_STATUS, 0xb0000
  .set TECLADO_DATA, 0xb0001
	.set DISPLAY1, 0xa0000
  .set DISPLAY2, 0xa0001
  .set DISPLAY3, 0xa0002
  .set DISPLAY4, 0xa0003

@ constantes
  .set INTERVAL,0x500
  .set BIT_READY,1


@ vetor de interrupções
  .org  IRQ*4               @ preenche apenas duas posição do vetor, 6 e 7
  	b      tratador_irq
  	b      tratador_fiq

@ tratadoresxt instruction:

.align 4
tratador_fiq:
    cmp r12,#10
    moveq r12,#0
    beq reseta
    add r12,#1
    movs	pc,lr		@ e retorna

tratador_irq:

    movs	pc,lr		@ e retorna

@ salva os digitos da senha
  d1: .byte 0
  d2: .byte 0
  d3: .byte 0
  d4: .byte 0

@ le botao
le_botao:
  ldr	r2,=BOTAO       @ r1 tem endereço botao start
  ldr	r3,[r2]         @ verifica botao start
  cmp	r3,#BIT_READY   @ foi pressionado?
  bne	le_botao           @ se nao foi, continua
  bx lr

espera:
  mov r4,#2            @ flag utilizada em reseta
  cmp r12,#5           @ conta 5 segundos
  bne espera
  beq reseta           @ reseta visor



reseta:
  mov r12,#0           @ zera flag
  ldr r2,=DISPLAY1     @ apaga todos os leds
  mov r3,#0x0
  strb r3 ,[r2]
  add r2,#1
  strb r3 ,[r2]
  add r2,#1
  strb r3 ,[r2]
  add r2,#1
  strb r3 ,[r2]
  mov r6,#0           @contador dos display
  cmp r4,#2           @ se a flag tiver ativa vai para seta_teclado
  beq seta_teclado
  b teclado


@ a "funcao" le teclado apenas eh executado na hora de colocar a senha
le_teclado:
  ldr	r8,=TECLADO_STATUS              @ verifica o status
  ldr	r9,[r8]
  cmp	r9,#BIT_READY
  bne	le_teclado                      @ fica em loop
  ldr r4,=digitos                     @ carrega tabela para imprimir no visor
  ldr r9,=TECLADO_DATA
  ldr r8,[r9]
  ldrb r3, [r4,r8]
  strb r3 ,[r2]                       @ carrega no visor
  bl salva                            @ entra na funcao para salvar o que esta sendo inserido
  mov r12,#0                          @ zera o contador da interrupcao FIQ
  add r2,#1                           @ ir para direita no visor
  add r6,#1                           @ soma contador, (sao 4 digitos)
  cmp r6,#4                           @ quando estiver no 4 para
  bne le_teclado                      @ se nao, le mais um digito
  bl acende_led_vermelho              @ acabou a leitura, acende led vermelho
  bl espera                           @ vai para espera, (visor fica com a senha durante 5 segundos para usuario memorizar)
  bx lr

salva:
  strb r3,[r10]
  add r10,#1
  bx lr

compara:
  ldrb r4,[r10]
  cmp r4,r3
  addeq r5,#1
  add r10,#1
  bx lr

acende_led_vermelho:
  ldr r3, =LEDS
  ldr r2, =cores
  ldrb r2,[r2, #2]
  str r2,[r3]
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
  @botao
  bl le_botao                       @espera botao
  @ acende led verde
  ldr r3, =LEDS
  ldr r2, =cores
  ldrb r2,[r2, #1]
  str r2,[r3]
  ldr r1,=TIMER                     @ r3 tem endereço timer
  ldr	r0,=INTERVAL
  str r0,[r1]		                    @ seta timer
  ldr r10, =d1                      @ seta r10, ele que vai armanezar a senha
teclado:
  ldr r2,=DISPLAY1                  @ seta inicio do display, na funcao abaixo, o loop vai incrementando r2 para os digitos irem da esquerda para direita no display
  bl le_teclado                     @ le teclado

seta_teclado:                       @ seta os registradores para o inicio, para que possa ler o teclado
  ldr r10, =d1
  ldr r2,=DISPLAY1
  mov r6,#0
  mov r5,#0
  mov r12,#0
teclado_tentando:
  ldr	r8,=TECLADO_STATUS              @ verifica o status
  ldr	r9,[r8]
  cmp	r9,#BIT_READY
  bne	teclado_tentando                @ fica em loop
  ldr r4,=digitos                     @ carrega tabela para imprimir no visor
  ldr r9,=TECLADO_DATA
  ldr r8,[r9]
  ldrb r3, [r4,r8]
  strb r3 ,[r2]                       @ carrega no visor
  bl compara                            @ entra na funcao para salvar o que esta sendo inserido
  mov r12,#0                          @ zera o contador da interrupcao FIQ
  add r2,#1                           @ ir para direita no visor
  add r6,#1                           @ soma contador, (sao 4 digitos)
  cmp r6,#4                           @ quando estiver no 4 para
  bne teclado_tentando
  cmp r5,#4
  bne errou_funcao
  bleq acende_led_verde
  beq espera_botao

errou_funcao:                         @ atribui contador pra se preciso, travar o cofre
  add r7,#1
  cmp r7,#3
  beq travou
  mov r4,#2
  b reseta

espera_botao:                         @ quando acertou  apaga os leds e trava
  mov r2,#0
  mov r3,#0
  ldr r2,=DISPLAY1     @ apaga todos os leds
  mov r3,#0x0
  strb r3 ,[r2]
  add r2,#1
  strb r3 ,[r2]
  add r2,#1
  strb r3 ,[r2]
  add r2,#1
  strb r3 ,[r2]
  bl le_botao
  b travou
  @bl le_botao
  @bl acende_led_vermelho
  @b seta_teclado


travou:
b travou

acende_led_verde:
  ldr r3, =LEDS
  ldr r2, =cores
  ldrb r2,[r2, #1]
  str r2,[r3]
  bx lr

digitos:

  .byte 0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b
cores:
  .byte 0x00,0x01,0x02
