@ Mateus Joaquim RA: 184083
@ Teste 1_AB

.org 0x100
cadeia:      .skip     31                      @ Rotulo p/ o susy submeter a sequencia

.org 0x200
@ Reserva memoria para variaveis.
carac:         .skip     1                    @ Caractere procurado
index:         .word     0                    @ elemento mais a esquerda, ja seta como se não houvesse achado
rindex:        .word     0                    @ elemento mais a direita
contador:      .word     0                    @ contador de posicao
flag:          .word     0                    @ flag para verificacao se achou o caractere em todo o vetor ou não

.org 0x500

inicio:
      set r1, 0x100	                          @Colocando o endereço apontado do primeiro registrador no r1
      set r2, 0x100                         	@Colocando o endereço apontado do segundo registrador no r2, para ir incrementando
      ld  r4, contador                        @ seta cada variavel em cada registrador
      ld  r5, index
      ld  r6, rindex
      ld  r7, carac
      ld  r8, flag

prox_dig:
      ldb r3, [r2]	                         @Coloca valor do ultimo termo em r3 para verificar se é 0
      cmp r3, 0	                             @Compara com 0 para verificar se é o último termo
      jz  final_correcao                     @ Precisamos fazer uma correcao de contagem a mais, estamos contando a partir do 1, e não da posicao zero de vetor
      add r4,1                               @incrementa contador
      cmp r3, r7                             @Verifica se o r3 é igual ao Caractere
      jz  incrementa                         @Se for igual vai pro rotulo
      add r2, 1	                             @Adiz'ciona um no segundo apontador, para ele apontar para o próximo termo
      jmp prox_dig                           @ volta o loop

incrementa:
      add r8,1                              @Adiciona 1 a flag de achou, para que no final, se não achou, seta index e rindex -1
      cmp r5,0                              @ ve se é a primeira vez que achou
      jz primeira_vez
      cmp r6,0
      jz primeira_vez
      set r6,0
      add r6,r4                             @ se não for adiciona 1 ao rindex, pq index ja foi achado, então não deve ser incrementando
      add r2,1                              @ avanca ponteiro
      jmp prox_dig                          @ volta loop

primeira_vez:
      add r5,r4                             @soma os auxiliarias com o contador
      add r6,r4
      add r2, 1                             @incrementa o vetor
      jmp prox_dig                          @ volta o loop

final_correcao:
      sub r5,1                             @faz a correcao de contagem a mais e vai para o final
      sub r6,1
      jmp final_for

nao_achou:
      set r5,-1                            @ se nao achou seta tudo -1
      set r6,-1
      add r8,1                             @ adiciona a flag para nao entrar em loop infinito


final_for:
        cmp r8,0                          @ verifica a flag
        jz  nao_achou
        st index,r5
        st rindex, r6

        hlt                                 @ termina a execução
