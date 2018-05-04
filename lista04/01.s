fatorial:

ld r0, [sp+4]
cmp r0,1
ja fat2
set r0,1
ret

fat2:
sub r0,1
push r0
call fatorial
add sp,4
ld r1,[sp+4]
mov r2,r0
call multiplica @ multiplicar r0 = r1*r2
