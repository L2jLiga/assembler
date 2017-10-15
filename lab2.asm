; Variant 2; laboratory 2
Dseg segment
  varA dw 0
  varB dw 0               
  outA db "Input arg A: $"
  outB db "Input arg B: $"
  rez db "Result: $"
  ost db " and ost: $"
  tempor dw 0    
Dseg ends

include 'coollibheader.inc'

lea dx,outA       ; Input A
outstr
mov AL,2
call inint
mov varA,AX

lea dx,outB       ; Input B
outstr
mov AL,2
call inint
mov varB,AX


mov AH,0           
cmp AX,varA        ; CMP varA and varB

jB fst             ;varA > varB
jE eqv             ;varA = varB

mov BX,varA        ; varA < varB
add BX,5
div BX
mov tempor,DX

jmp output         ; Jump to output

fst:               ;varA > varB
mov varB,AX
mov AX,varA
MUL varA
sub AX,varB
DIV varA
mov tempor,DX

jmp output          ; Jump to output

eqv:                ;varA = varB
lea dx,rez
outstr
mov AH,0Eh          ; Output -5
mov AL,"-"
INT 10h
MOV AL,"5"
INT 10h
getch               ; And exit
return

output:             ; Output rezult
newline
lea dx,rez
outstr
call outint3
lea DX,ost
outstr
mov AX,tempor
call outint

include 'coollib.asm'