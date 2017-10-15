S segment stack
  db 128 dup(?)
S ends
Dat segment
  a1 dw 1525,2731,1300,2500,3542,3342
  a2 db 5 dup(?)
Dat ends
C segment
  ASSUME CS:C,SS:S,DS:Dat
  start:
  MOV AX,Dat
  MOV DS,AX

  mov cx,5
  mov si,0
  mov di,0

  mover:
    mov ax,a1[SI]
    mov a2[DI],al
    inc si
    inc si
    inc di
  loop mover

  MOV AX,4C00H
  INT 21H
C ends
end start
