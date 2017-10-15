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

; Compare strings
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