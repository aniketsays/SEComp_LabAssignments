.MODEL TINY
.286
org 100H
CODE SEGMENT
ASSUME CS:CODE,DS:CODE,ES:CODE
OLD_IP DW 00
OLD_CS DW 00
jmp INIT
my_tsr:
push AX
push BX
push CX
push DX
push SI
push DI
push ES
mov AX,0B800H
mov ES,AX
mov DI,3650
mov AH,02H
int 1AH
mov BX,CX
;push contents of ax onto stack
;push contents of bx onto stack
;push contents of cx onto stack
;push contents of dx onto stack
;push contents of si onto stack
;push contents of di onto stack
;push contents of es onto stack
;Address of Video RAM
;move ax to es
;move 3650 to di
;To Get System Clock
;CH=Hrs, CL=Mins,DH=Sec
;move cx to bx
mov CL,2
repeat: rol BH,4
mov AL,BH
and AL,0FH
add AL,30H
mov AH,17H
mov ES:[DI],AX
inc DI
inc DI
dec CL
jnz repeat ;move 2 to cl
;rotate bh by 4 to left
;move bh to al
;and 0fH with al
;add 30H to al
;move 17H to ah
;move ax to address pointed by di
;increment di
;increment di
;decrement cl
;jump if not zero to repeat
mov AL,':'
mov AH,97H
mov ES:[DI],AX
inc DI
inc DI ;move ascii of : to al
;move 97H to ah
;move ax to address pointed by di
;increment di
;increment dimov CL,2
;move 2 to cl
loopp: rol BL,4
;rotate bh by 4 to left
mov AL,BH
;move bh to al
and AL,0FH
;and 0fH with al
add AL,30H
;add 30H to al
mov AH,17H
;move 17H to ah
mov ES:[DI],AX
;move ax to address pointed by di
inc DI
;increment di
inc DI
;increment di
dec CL
;decrement cl
jnz loopp
;jump if not zero to loop
mov AL,':'
mov AH,97H
mov ES:[DI],AX
inc DI
inc DI ;move ascii of : to al
;move 97H to ah
;move ax to address pointed by di
;increment di
mov CL,2
mov BL,DH ;move 2 to cl
;move dh to bl
again: rol BL,4
;rotate bh by 4 to left
mov AL,BH
;move bh to al
and AL,0FH
;and 0fH with al
add AL,30H
;add 30H to al
mov AH,17H
;move 17H to ah
mov ES:[DI],AX
;move ax to address pointed by di
inc DI
;increment di
inc DI
;increment di
dec CL
;decrement cl
jnz again
;jump if not zero to again
pop ES
pop DI
pop SI
pop DX
pop CX
pop BX
pop AX
INIT:
mov AX,CS
mov DS,AX
cli
mov AH,35H
mov AL,08H
int 21H
;pop contents of stack into es
;pop contents of stack into di
;pop contents of stack into si
;pop contents of stack into dx
;pop contents of stack into cx
;pop contents of stack into bx
;pop contents of stack into ax
;Initialize data
;move ax to ds
;Clear Interrupt Flag
;Get Interrupt vector Data and store it
;move 08H to al
;call kernelmov OLD_IP,BX
mov OLD_CS,ES
mov AH,25H
mov AL,08H
lea DX,my_tsr
int 21H
;move bx to old_ip
;move es to old_cs
;Set new Interrupt vector
;move 08H to al
;load effective address of my_tsr
;call kernel
mov AH,31H
;Make program Transient
mov DX,OFFSET INIT ;move offset to dx
sti
;set interrupt fla
int 21H
;call kernel
