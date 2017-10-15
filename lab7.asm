Dseg segment
  InputText db 'Input your number (HEX): $'
  OutputText db 'Convert result (DEC): $'
  InputError db 'Error! Max symbols - 3! Try again.. $'
  number dw ?
  temper db ?
Dseg ends
include coollibheader.inc

; Input
Inputer_hex:
  LEA DX,InputText
  outstr
  mov AL,4           ; Setup legth of integer
  call InIntHEX      ; Input HEX integer
  cmp AX,1000h
  jB Input_cont
  LEA DX,InputError  ; Error
  outstr
  newline
  jmp Inputer_hex

Input_cont:
  mov number,AX      ; Copy number to var

  ; Output + Convert
  LEA DX,OutputText
  outstr
  mov AX,number
  mov BL,100
  DIV BL
  mov temper,AH
  call outint
  mov AL,temper
  call outint

include coollib.asm