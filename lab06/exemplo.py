i = 3  # variável que corresponde ao dígito mais significativo
j = 0  # variável que corresponde ao dígito menos significativo
for k in range(80): # no seu programa, repetir para sempre...
    if i==0:
        if j == 0:
            print('muda estado', end=' ')
            i = 3
        elif j == 5:
            print('muda estado, amarelo para as duas ruas', end=' ')
    print('display', i,j)
    if j == 0:
        j = 9
        i = i - 1
    else:
        j = j - 1
