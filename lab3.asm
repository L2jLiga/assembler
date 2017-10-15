Dseg segment                             
  outInteg db "Input first number: $"
  outDiv db "Input second number: $"
  outRez db "Result of divide as $"
  integ db 2 dup(?)
  divider db ?
  ost db ?
Dseg ends

include coollibheader.inc

mov DX,offset outInteg
outstr    
mov al,2
call InInt
aam
mov SI,0    
mov integ[SI],AL
inc SI
mov integ[SI],AH    

mov DX,offset outDiv
outstr    
mov ax,1
call InInt
mov divider,al

mov SI,0    
mov AL,integ[SI]
inc SI
mov AH,integ[SI] 
AAD
DIV divider

mov ost,AH
lea DX,outRez
outstr
call outint

include coollib.asm