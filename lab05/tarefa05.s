@ Mateus Joaquim RA:184083
@ Lab05

.org 0x400
	@ Variavel inicializada com 1s
 temporizador: .word 1000
	@ Info
	GREEN 	     .equ 0x01
	YELLOW	     .equ 0x02
	RED		       .equ 0x04
	SINAL1 	     .equ 0x90
	SINAL2 			 .equ 0x91
	TIMER_DATA 	 .equ 0x50               @ Porta do temporizador
	INT_TIMER    .equ 0x10               @ Interrupção do temporizador

inicio:
		set r9,INT_TIMER*4                   @ posição no vetor de interrupções
		set r10,int_tempo                    @ endereço do tratador
		st [r9], r10
		set sp,0x10000                       @ prepara pilha
		set r0, YELLOW		                   @ Setando o estado anterior para o Sinal 1
		set r1, GREEN 		                   @ Setando o estado atual para o Sinal 1
		set r2, YELLOW		                   @ Setando o estado atual para o Sinal 2

		set r5, GREEN		                     @ Setando reegistradores com valores predefinidos, para dar out
		set r6, YELLOW
		set r7, RED

		outb SINAL1, r5		                   @ Setando na porta, o sinal atual do sinal 1
		outb SINAL2, r7		                   @ Setando na porta, o sinal atual do sinal 2

		sti                                  @ habilita interrupções
		set r9, 1000                         @ liga temporizador com valor
		out TIMER_DATA,r9                    @ para interromper a cada segundo

loop:
	wait
	cmp r0, YELLOW		                   @ Compara se o estado anterior era 2 (os dois amarelos)
	jz	Anterior_era_2
	cmp r0, GREEN 		                   @ Verifica se o estado anterior de r0 é 1 (sinal 1 verde, sinal 2 vermelho)
	jz Anterior_era_1
						                           @ Estado 2, indo pra 1, anterior era 3
	mov r0, r1			                     @ Estado atual do sinal 1, recebe estado anterior
	set r1, GREEN
	set r2, RED

	outb SINAL1, r5
	outb SINAL2, r7
	set r4, 0
	jmp loop

Anterior_era_1:			                 @ Estado 2, indo pra 3, e o anterior era 1

	mov r0, r1			                   @ Estado atual do sinal 1, recebe estado anterior
	set r1, RED
	set r2, GREEN

	outb SINAL1, r7
	outb SINAL2, r5
	set r4, 0
	jmp loop

Anterior_era_2:			                 @ Estado 1 ou 3, indo pra 3 ou 1, anterior era 2

	mov r0, r1 			                   @Estado atual do sinal 1, recebe estado anterior
	set r1, YELLOW		                 @Estado atual do sinal 1, é 2
	set r2, YELLOW		                 @Estado atual do sinal 2, é 2

	outb SINAL1, r6		                 @Setando na porta, o sinal atual do sinal 1
	outb SINAL2, r6		                 @Setando na porta, o sinal atual do sinal 2
	set r4, 0
	jmp loop

	int_tempo:
	  iret                  @ apenas retorna


	hlt
