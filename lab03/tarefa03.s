@ Mateus Joaquim RA:184083
@ Lab03

.org 0x1000
@ Dados teclado
KEYBD_DATA .equ 0x80              @ porta de dados
KEYBD_STAT .equ 0x81              @ porta de estado
KEYBD_LAST .equ 0x82              @ ultimo dado
KEYBD_READY .equ 1                @ bit READY

@ Dados display
DISPLAY1 .equ 0x40


inicio:
      set r8,0                    @ para aparecer 0 quando inciiar o programa
      set r1,0x11                 @ mascara para operadores
      set r11,0x10

@ ********
@ mostra_display
@ ********
display:
      set   r5,tab_digitos         @ indexa valor do dígito corrente no vetor
      add   r5,r8                  @ de dígitos para determinar a configuração
      ldb   r5,[r5]                @ de bits a ser escrita no mostrador
      outb  DISPLAY1,r5            @ envia para o mostrador

retorno:
      cmp r1,r11                   @ se for (11) acaba o programa
      jz final
      jmp read                     @ se nao le

@ ********
@ le_tecla_e_operador
@ ********

read:
        set r2,KEYBD_READY

read1:
        inb r5,KEYBD_STAT          @ le porta de estado
        tst r5,r2                  @ dado pronto para ser lido?
        jz read1                   @ espera que dado esteja pronto
        inb r0,KEYBD_DATA          @ le porta de dados
read_operador:
        set r2,KEYBD_READY
read2:
        inb r5,KEYBD_STAT          @ le operador
        tst r5,r2                  @ dado pronto para ser lido?
        jz read2                   @ espera que dado esteja pronto
        inb r1,KEYBD_DATA          @ le operador
soma:
        add r8,r0                  @ realiza soma
        jmp display                @ mostra na tela




@ tabela de codificação de dígitos
tab_digitos:
        .byte    0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x77,0x1F,0x4E,0x3D,0x4F,0x47

final:
        hlt
