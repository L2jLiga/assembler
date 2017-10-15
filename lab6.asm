Dseg segment                             
  mas db 16 dup(?)
  i db 0
  j db 0
  temporary db 0
  rez dw 0
  Input_ARRAY db 'Input your array: $'
  Input_STR   db 'Input line $'
  Input_STL   db 'Input element $'
  Input_Addit db ': $'
  Output_arr  db 'Your array is:$'
  Output_tab  db  9h,24h             
  Output_MUL  db  'Result of MUL : $'
  Output_ADD  db  'Result of ADD : $'
  Output_DIV  db  'Result of DIV : $'
Dseg ends
include coollibheader.inc

; Input array
lea DX,Input_ARRAY
outstr            
newline
retry:
  ; Output message
  MOV AL,i
  ADD AL,1
  lea DX,Input_STR
  outstr
  call outint
  lea DX,Input_Addit
  outstr
  newline

  input:
    ; Output message [2]
    MOV AL,j
    ADD AL,1
    lea DX,Input_STL
    outstr
    call outint
    lea DX,Input_Addit
    outstr

    ; Get INT
    mov AL,1
    call InInt

    ; Get str
    push AX
    MOV AL,i
    MOV BX,4
    MUL BL
    MOV SI,AX
    pop AX

    ; Get stl
    MOV BL,j

    ; Mov INT to Array
    mov mas[SI][BX],AL

    ; Inc stl
    inc j
    mov CX,5
    sub CL,j    
  loop input

  ; Inc str
  MOV j,0
  INC i
  mov CX,5
  sub CL,i
loop retry

newline
newline

; Output original array
mov i,0
lea DX,Output_arr
outstr

out_retry:
  newline

  output:
    ; Get str
    MOV AL,i
    MOV BX,4
    MUL BL
    MOV SI,AX

    ; Get stl
    MOV BL,j

    ; Output element
    mov AL,mas[SI][BX]
    call OutInt

    ; Tabulation
    MOV DX,offset Output_tab
    outstr

    ; Inc stl
    inc j
    mov CX,5
    sub CL,j    
  loop output

  ; Inc str
  MOV j,0
  INC i
  mov CX,5
  sub CL,i
loop out_retry

; Get MUL
newline
MOV i,0
MOV AX,1

get_mul:
  push AX
  ; Get str
  MOV AL,i
  MOV BX,4
  MUL BL
  MOV SI,AX

  ; Get stl
  MOV BL,j
  pop AX

  mov CL,mas[SI][BX]
  MUL CX

  INC i
  mov CX,5
  sub CL,i
loop get_mul

MOV rez,AX
; In AX - result of MUL
MOV DX,offset Output_MUL
outstr
mov BL,100
DIV BL
mov temporary,AH
call outint
mov AL,temporary
call outint


; Get ADD
newline
MOV i,0
MOV AX,0

get_add:
  push AX
  ; Get str
  MOV AL,i
  MOV BX,4
  MUL BL
  MOV SI,AX

  ; Get stl
  MOV BL,j
  pop AX

  ADD AL,mas[SI][BX]

  INC i
  mov CX,5
  sub CL,i
loop get_add

; In AX - result of MUL
MOV DX,offset Output_ADD
outstr
call outint

; Get DIV
newline
mov BL,AL
mov AX,rez
DIV BL
MOV DX,offset Output_DIV
outstr
mov AH,0
call outint3

include coollib.asm