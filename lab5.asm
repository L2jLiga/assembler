Dseg segment                             
  outmas db "Input element $"
  outmas2 db ": $"
  mas db 20 dup(?)
  mas1 db 20 dup(?)
  mas2 db 20 dup(?)
  outs db "Orig mas: $"
  out1 db "Mas 1: $"
  out2 db "Mas 2: $"
  symb db " $"
Dseg ends

include coollibheader.inc

; Input initial array:
mov CX,20
mov SI,0

input:
  mov DX,offset outmas
  outstr    
  mov AX,SI
  INC AX
  call outint
  mov DX,offset outMas2
  outstr
  mov al,2
  call InInt
  mov mas[SI],al
  inc SI
loop input

newline
newline

; Output original array
mov dx,offset out1
outstr
mov cx,19
mov SI,0
lea dx,symb
mov al,mas[SI]
call outint
inc SI

outp:
  outstr
  mov al,mas[SI]
  call outint
  inc SI
loop outp

newline

; Sort to first array
mov dx,offset out1
outstr 
mov dx,offset symb
mov CX,20
MOV SI,0
mov DI,0

sort:
  mov ah,0
  mov AL,mas[SI]
  mov bl,2
  div bl
  cmp ah,1
  jNE sort_cont
  inc SI
loop sort

jmp sort_finish

sort_cont:
  mov AL,mas[SI]
  inc SI
  mov mas1[DI],AL
  call outint
  outstr
  INC DI
loop sort

sort_finish:
newline

; Output second array
mov dx,offset out2
outstr
mov dx,offset symb
mov CX,20
MOV SI,0
mov DI,0

sort2:
  mov ah,0
  mov AL,mas[SI]
  mov bl,2
  div bl
  cmp ah,0
  jNE sort2_cont
  inc SI
loop sort2

jmp sort2_finish

sort2_cont:
  mov AL,mas[SI]
  inc SI
  mov mas2[DI],AL
  call outint
  outstr
  INC DI
loop sort2

sort2_finish:
include coollib.asm