@ Mateus Joaquim RA:184083
@ Lab06


	@ Info
	GREEN 	     .equ 0x01
	YELLOW	     .equ 0x02
	RED		       .equ 0x04
	@ Dados Sinais
	SINAL1 	     .equ 0x90
	SINAL2 			 .equ 0x91
	@ Dados interrupcao
	TIMER_DATA 	 .equ 0x50               @ Porta do temporizador
	INT_TIMER    .equ 0x10               @ Interrupcaoo do temporizador
	@ Dados display
	DISPLAY_D    .equ 0x41               @ Display de Dezena
	DISPLAY_U    .equ 0x40               @ uNIDADE

.org INT_TIMER*4                       @ Reserva a memoria
.word int_tempo                        @ Reserva a interrupcao

.org 0x1000                            @ Pula memoria para nao dar pau
intervalo: .word 1000                  @ Rotulo para edicao

@ funcao display
display:
	 set   r13,tab_digitos              @ indexa valor do d�gito corrente no vetor
	 add   r13,r11                      @ de d�gitos para determinar a configura��o
	 ldb   r13,[r13]                    @ de bits a ser escrita no mostrador
	 outb  DISPLAY_D,r13                @ envia para o mostrador
	 set   r13,tab_digitos              @ indexa valor do d�gito corrente no vetor
	 add   r13,r12                      @ de d�gitos para determinar a configura��o
	 ldb   r13,[r13]                    @ de bits a ser escrita no mostrador
	 outb  DISPLAY_U,r13                @ envia para o mostrador
	 ret


inicio:
	set sp,0x10000                       @ prepara pilha
	sti                                  @ inicia
	ld r9, intervalo                     @ carrega no registrador e no interruptor
	out TIMER_DATA, r9
	set r0, YELLOW		                   @ Setando o estado anterior para o Sinal 1
	set r1, GREEN 		                   @ Setando o estado atual para o Sinal 1
	set r2, YELLOW		                   @ Setando o estado atual para o Sinal 2

	set r5, GREEN		                     @ Setando reegistradores com valores predefinidos, para dar out
	set r6, YELLOW
	set r7, RED

	outb SINAL1, r5		                   @ Setando na porta, o sinal atual do sinal 1
	outb SINAL2, r7		                   @ Setando na porta, o sinal atual do sinal 2

	set r11,3														 @ exemplo em py, i=3
	set r12,0														 @ j = 0
loop:
	call espera                          @ loop para interrupcao
	call display                         @ Mostra no display
  set r10,0                            @ flag para tratar interrupcao
	set r8,0                             @ registrador aux para fazer a logica do display
	cmp r8,r11
	jz izero                             @ i = 0
	set r8,0
	cmp r8,r12
	jz jzero                             @ j = 0
  cmp r8,r12
  jnz subtrai                          @ j--
  jmp loop

izero:
  mov r8,r12
  cmp r8,1
  jz ijzero                           @i e j = 0
  cmp r8,6                            @ pela logica do programa preciso comparar com 6, 1 segundo antes, do 5
  jz jcinco                           @ j = 6
  jmp subtrai

ijzero:
  set r11,3                          @ 30
  set r12,0
  jmp semaforo                       @ atualzia semaforo

jcinco:
  outb SINAL1, r6		                  @Setando na porta, o sinal atual do sinal 1
  outb SINAL2, r6		                  @Setando na porta, o sinal atual do sinal 2
  mov r0, r1 			                    @Estado atual do sinal 1, recebe estado anterior
  set r1, YELLOW		                  @Estado atual do sinal 1, � 2
  set r2, YELLOW		                  @Estado atual do sinal 2, � 2
  set r4, 0
  jmp subtrai

jzero:
  set r12,9
  sub r11,1
  jmp loop

subtrai:
  sub r12,1
  jmp loop


semaforo:
	cmp r0, GREEN 		                   @ Verifica se o estado anterior de r0 � 1 (sinal 1 verde, sinal 2 vermelho)
	jz Anterior_era_1
						                           @ Estado 2, indo pra 1, anterior era 3
	mov r0, r1			                     @ Estado atual do sinal 1, recebe estado anterior
	set r1, GREEN
	set r2, RED

	outb SINAL1, r5
	outb SINAL2, r7
	set r4, 0
  set r9,1
	jmp loop


Anterior_era_1:			                  @ Estado 2, indo pra 3, e o anterior era 1
	mov r0, r1			                    @ Estado atual do sinal 1, recebe estado anterior
	set r1, RED
	set r2, GREEN

	outb SINAL1, r7
	outb SINAL2, r5
	set r4, 0
	jmp loop


@funcao wait
espera:
  cmp r10,0                          @ loop infinito ate alterar a flag r10
  jz espera
  ret


@ funcao interrupcao
int_tempo:                           @ quando houver a interrupcao, altera a flag e continua
  set r10,1
	iret                               @ apenas retorna


tab_digitos:                         @ 0 a 9
	.byte    0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x77,0x1F,0x4E,0x3D,0x4F,0x47

	hlt
