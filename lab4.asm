Dseg segment                             
  outStr1 db "Input first string: $"
  outStr2 db "Input second string: $"
  outRez  db "Result string: $"  
  str1    db 30,?,30 dup(?)
  str2    db 30,?,30 dup(?)
  strREZ  db 30 dup(?)
Dseg ends
include coollibheader.inc

; Input first string
mov DX,offset outStr1
outstr
newline    
mov DX,offset str1
mov AX,0A00h
INT 21h
newline

; Input second string
mov DX,offset outStr2
outstr 
newline    
mov DX,offset str2
mov AX,0A00h
INT 21h
newline   
jmp cont2
; Compare strings

; First - getlength
MOV CX,30
MOV SI,2
mov DI,0

getlegth: 
  ; Check for string end
  cmp str2[SI],0Dh

  jNE trimer

  mov str2[DI],24h
  mov str1[DI],24h

  jmp cont

  trimer:
    mov AL,str1[SI]
    mov str1[DI],AL
    mov AL,str2[SI]
    mov str2[DI],AL
    inc SI
    INC DI
loop getlegth

; Second - compare    
cont:

mov CX,DI 
mov DX,CX
cld
mov SI, offset str1
mov DI, offset str2
repe_comp:
repe cmpsb
jE finisher
push DI
push BX
mov DI,DX
sub DX,CX
mov str1[DI],"5"
pop DI
pop BX

jmp repe_comp:


; Third
cont2:

MOV CX,30
MOV SI,2
mov DI,0

compare:
  MOV AL,str1[SI]

  ; Check for string end
  cmp str2[SI],0Dh

  jNE checker

  mov strREZ[DI],24h

  jmp finisher

  ; If not end compare elements
  checker:
  cmp AL,str2[SI]

  jE match

  mov strREZ[DI],35h  ; If not match, replace symbol in str2 -> 35h (5)
  INC SI
  INC DI

  loop compare

  match:
    mov strREZ[DI],AL   ; If match, don't replace anything
    INC SI
    INC DI
loop compare

finisher:
newline
newline

; Output rezult-string
lea DX,outRez
outstr
newline
mov DX,offset strREZ
MOV AX,0900h
INT 21h

include coollib.asm