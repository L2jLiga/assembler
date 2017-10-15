; Header for Coollib
;
TempData segment
  SignFlag db 0           ;
  FirstFlag db 0          ;
  stepper dw 0            ;
  integer db 5 dup(?)     ;
  inputted db 0           ;
  InputWithSign db 0      ;
  cnt db 0                ;
TempData ends               
Sseg segment stack
  db 128 dup(?)
Sseg ends

Cseg segment
  ASSUME CS:Cseg,SS:Sseg,DS:Dseg
  start:
  mov AX,Dseg
  mov DS,AX