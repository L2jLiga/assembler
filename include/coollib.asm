; This is cool working library for Output and Input w/o Far
; If u want to output AnyThing move at in AX

getch
return

;
; Output functions:
;

; Go to newline
NewLine  macro  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  push dx       ; Store registers..
  push ax       ;
  mov ah,2      ; Function "console output"
  mov dl,13     ; To line-start
  int 21h       ; do it!
  mov dl,10     ; One step down
  int 21h       ; do it!
  pop ax        ; Restore registers..
  pop dx        ;
prochl	endm    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Output string
; In DX - offset of MSG, Message end - 24h
OutStr macro       ;;;;;;;;;;;;;;;;;;;;;;
  push ax          ; Store registers..
  mov     ah, 09h  ; print function is 9.
  int     21h      ; do it!
  pop ax           ; Restore registers..
OutStr endm        ;;;;;;;;;;;;;;;;;;;;;;

; Output: int
; Input:  Int in AX (00-99)
OutInt proc        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  push ax          ; Store registers..
  push dx          ;
  cmp AH,0FFh      ;
  jNE OutInt_cont  ;
  ;
  OutInt_cont:     ; TO DO:
  aam              ; If ZF inst - print "-"
  add ax,3030h     ;
  mov dl,ah        ;
  mov dh,al        ;
  mov ah,02        ;
  int 21h          ;
  mov dl,dh        ;
  int 21h          ;
  pop dx           ;
  pop ax           ;
  ret              ;
OutInt endp        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OutInt3 proc
  push ax
  push bx
  push dx
  mov bl,100
  div bl     ; AL - 100, AH 0,xx
  pop bx
  mov dh,ah  ; DH 0,xx
  mov dl,al  ; DL 1xx
  add dl,30h
  mov ah,02
  int 21h

  mov ah,0
  mov al,dh
  pop dx
  call outint    ; Out 0,xx part of int

  pop ax
  ret
OutInt3 endp

;
; Cursor left
;
CurLeft macro    ;;;;;;;;;;;;;;;;;;;
  push dx        ; Store registers
  push ax        ;
  mov ah,2       ; backspace
  mov dl,08h     ;
  int 21h        ;
  mov ax,0e00h   ; draw empty symbol
  int 10h        ;
  mov ah,2       ; backspace again
  mov dl,08h     ;
  int 21h        ;
  pop ax         ; Restore registers
  pop dx         ;;;;;;;;;;;;;;;;;;;
CurLeft endm

;
; Input functions
;
InIntkb_getInput macro        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  jmp InIntkb_InpStart        ; Start input
                              ;
  InIntkb_InpBackspace:       ; If backspace pressed
  cmp FirstFlag,0             ;
                              ;
  jE  InIntkb_InpStart        ;
                              ;
  CurLeft                     ;
  cmp CL,cnt                  ;
                              ;
  jE InIntkb_InpStart_again   ;
                              ;
  INC CX                      ;
  DEC SI                      ;
  cmp CL,cnt                  ;
                              ;
  jE check_SignFlag           ;
  jmp InIntkb_InpStart        ;
                              ;
  check_SignFlag:             ; Check for sign flag
  cmp SignFlag,1              ;
                              ;
  jE InIntkb_InpStart         ;
                              ;
  InIntkb_InpStart_again:     ; If we have sign
  mov SignFlag,0              ;
  mov FirstFlag,0             ;
                              ;
  jmp InIntkb_InpStart        ;
                              ;
  InIntkb_InpEnter:           ; if Enter pressed
  mov AL,0FFh                 ;
                              ;
  jmp InIntkb_finish          ;
                              ;
  InIntkb_InpStart:           ; Input start,
  mov ax,0                    ; Reset AX
  int 16h                     ; An read symbol from KB
  mov ah,"-"                  ; If "-" pressed, code: 2Dh
  cmp al,ah                   ;
                              ;
  jNE InIntkb_cont            ;
                              ;
  cmp FirstFlag,1             ; If not 1st symbol - not read
                              ;
  jE  InIntkb_InpStart        ;
                              ;
  mov SignFlag,1              ;
  inc CL                      ;
                              ;
  jmp InIntkb_out             ;
                              ;
  InIntkb_cont:               ;
  cmp AL,0Dh                  ; If Enter pressed, code: 0Dh
                              ;
  jE InIntkb_InpEnter         ; 
                              ;
  cmp AL,08h                  ; If Backspace pressed, code: 08h
                              ;
  jE InIntkb_InpBackspace     ;
                              ;
  cmp AL,39h                  ; Check If no int pressed, code: 30-39h
                              ;
  jA InIntkb_InpStart         ;
                              ;
  cmp AL,30h                  ;
                              ;
  jB InIntkb_InpStart         ;  
                              ;
  InIntkb_out:                ;
  mov FirstFlag,1             ; Setup flag "One Key Already pressed"
  mov ah,0eh                  ; Output enterred number
  int 10h                     ;
  sub al,30h                  ; Convert Number from ASCII code to INT
                              ;
  InIntkb_finish:             ; Finish HIM!
InIntkb_getInput endm         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InIntkb_enter_getInput macro
  ; Start input
  jmp InIntkb_enter_InpStart

  ; If backspace pressed
  InIntkb_enter_InpBackspace:
  CurLeft
  INC CL
  DEC SI

  jmp InInt_input

  ;if Enter pressed
  InIntkb_enter_InpEnter:
  mov AL,0FFh
  ;DEC SI
  jmp InIntkb_enter_finish

  InIntkb_enter_InpStart:
  mov ax,0
  int 16h

  InIntkb_enter_cont:
  cmp AL,0Dh ; If Enter pressed

  jE InIntkb_enter_InpEnter

  cmp AL,08h ; If Backspace pressed

  jE InIntkb_enter_InpBackspace
  jmp InIntkb_enter_InpStart

  InIntkb_enter_finish:
InIntkb_enter_getInput endm

InIntkb_getStep proc
  cmp CL,5
  
  jNE less4
  
  mov bx,10000
  
  jmp getStep_cont

  less4:
  cmp CL,4
  
  jNE less3
  
  mov bx,1000 
  
  jmp getStep_cont

  less3:
  cmp CL,3
  
  jNE less2
  
  mov bx,100 
  
  jmp getStep_cont

  less2:
  cmp CL,2
  
  jNE less1
  
  mov bx,10 
  
  jmp getStep_cont

  less1:
  mov bx,1

  getStep_cont:
  mov ah,0
  mul bx

  add stepper,ax
  ret
InIntkb_getStep endp

InIntkb_convert proc         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  mov CX,SI                  ; Copy length of number to CX
  mov SI,0                   ; Reset counter
                             ;
  InIntkb_convert_cycle:     ; Cycle
  mov AL,integer[SI]         ; Copy to AL part of number
  call InIntkb_getStep       ; Convert part of BCD-number to Normal and store it..
  inc SI                     ; Counter++
  loop InIntkb_convert_cycle ; Next..:) 
                             ;
  mov ax,stepper             ; Copy our normal number to AX
                             ;
  cmp SignFlag,1             ; Checking for "-"
  jNE InIntkb_convert_ret    ; If haven't - return int
  neg AX                     ; Else negative number
  mov stepper,AX             ;
                             ;
  InIntkb_convert_ret:       ; If allfine..
  ret                        ; And return...
InIntkb_convert endp         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; Input integer
; USE: input - AL=SignFlag: 1 - Signed INT, 0 - UnSigned INT
; Output - number in AX (range -32768 - 32767)
InInt proc                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  cmp AL,5                   ; Check input parametr
                             ;
  jB InInt_Check_no2         ;                    
                             ;
  mov AX,5                   ;
  InInt_Check_no2:           ;
  cmp AL,1                   ;
                             ;
  jA InInt_pusher            ;
                             ;
  mov AL,2                   ;
                             ;
  InInt_pusher:              ;
  push SI                    ; store registers...
  push CX                    ;
  push BX                    ;
  push DI                    ;
  mov DI,DS                  ;
  mov BL,AL                  ; Copy CNT to BL (temporary)
                             ;
  mov AX,TempData            ; Initializate Temporary Data Segment
  mov DS,AX                  ;
  mov FirstFlag,0            ;
                             ;
  mov cnt,BL                 ;
  mov stepper,0              ; Clear last number
  mov SI,0                   ; Clear Counter
  mov CH,0                   ;
  mov CL,cnt                 ; Max length of number
                             ;
  InInt_input:               ;
    InIntkb_getInput         ; Read int from KB 
    cmp AL,0FFh              ; If enter pressed
    jE InInt_finisher        ; Then ending input        
    cmp AL,0FDh              ; If enter "-"
    jE input_sign            ; Skip counter++
    mov integer[SI],AL       ; Move our int to VAR
    inc SI                   ; Increment Counter
                             ;
    input_sign:              ;
                             ;
  loop InInt_input           ; Go to Input
                             ;
  InIntkb_enter_getInput     ; Check for Input ending (allow to use Backspace or Enter)
                             ;
  InInt_finisher:            ; Marker for input ending 
  call InIntkb_convert;      ; Convert our number from BCD to normal
                             ;
  InInt_return:              ; Function endings...
  mov DS,DI                  ; Restore Data Segment
  pop DI                     ; Return registers values from store... 
  pop BX                     ;
  pop CX                     ;
  pop SI                     ;
                             ;
  newline                    ; Print newline
  ret                        ; And return to caller
InInt endp                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;
; System functions
;



; Wait for Input       
getch macro ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  push ax   ; AX to store..
  mov ah,0  ; Call Interrupt with AH=0
  int 16h   ; "Waiting for input..."
  pop ax    ; restore AX from store..
endm        ;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Exit
return macro
  mov ax,4Ch
  int 21h
return endm 

Cseg ends
end start