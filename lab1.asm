; Varian 2
Dseg segment 
  outA   db "Vvedite A: $"
  outD   db "Vvedite D: $"
  outC   db "Vvedite C: $"
  outREZ db "Rezult of function: $"
  ; Max in dword - 8000h (if jA - neg)
  varA dw 0
  varD dw 0   
  varC dw 0
  varY dw 0
Dseg ends

include coollibheader.inc

mov AL,2  
lea dx,outA  ; Input varA (argument A)
outstr
call InInt
mov varA,AX

mov AL,2
lea dx,outC  ; Input varC (argument C)
outstr
call InInt
mov varC,AX

mov AL,2
lea dx,outD  ; Input varD (argument D)
outstr
call InInt
mov varD,AX

mov AX,4      ; AX = 4
IMUL varD     ; AX = 4*D
ADD AX,varC   ; AX = C+4*D

SUB AX,123    ; AX = C+4*D-123

mov varY,AX   ; AX = 4*(C+4*D-123)
mov AX,4
IMUL varY

mov varY,AX   ; Copy AX to varY

mov AX,4      ; AX = 4-A
sub AX,varA   

mov BX,AX     ; BX - divider
mov AX,varY   ; AX - rez

IDIV BX       ; AX = 4*(C+4*D-123) / (4-A)
mov varY,AX   ; Move celoe to varY
mov DX,offset outREZ
outstr
cmp AX,8000h  ; Compare, if AX is negative

jB outinteger

mov AH,0Eh          ; Output '-'
mov AL,"-"
INT 10h
mov AX,varY
neg AX

outinteger:
call outint3

include coollib.asm