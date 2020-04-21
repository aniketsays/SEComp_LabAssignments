section .data
	arr: dq 0x1ABCDEF123456789, 0x1ABCDEF123456789, 0xABCDEF1234567890, 0xABCDEF1234567890, 0xABCDEF1234567890, 0xABCDEF1234567890, 0xABCDEF1234567890, 0xABCDEF1234567890, 0xABCDEF1234567890, 0xABCDEF1234567890
	pos: db 0
	neg: db 0
	cnt: db 10
	nl: db "",0x0A
	len: equ $-nl

        posmsg: db "Positive numbers are :"
        lposmsg: equ $-posmsg
        negmsg: db "Negative numbers are :"
        lnegmsg: equ $-negmsg
        

section .text
global main
main:
	mov rsi, arr
	mov byte[cnt], 10
up:
	mov rax, qword[rsi]
	BT rax, 63
	JC next
	inc byte[pos]
	JMP next2
next:
	inc byte[neg]
next2:
	add rsi, 8
	dec byte[cnt]
	JNZ up
	
	cmp byte[pos], 0x09
	jbe less
	add byte[pos], 37H
	jmp next3
less:
	add byte[pos], 30H	

next3:	
	cmp byte[neg], 0x09
	jbe less1
	add byte[neg], 37H
	jmp print
less1:
	add byte[neg], 30H
	
print:  
         mov rax, 1
	mov rdi, 1
	mov rsi, posmsg
	mov rdx, lposmsg
	Syscall


	mov rax, 1
	mov rdi, 1
	mov rsi, pos
	mov rdx, 1
	Syscall
	
	mov rax, 1
	mov rdi, 1
	mov rsi, nl
	mov rdx, len
	Syscall

        mov rax, 1
	mov rdi, 1
	mov rsi, negmsg
	mov rdx, lnegmsg
	Syscall

	
	mov rax, 1
	mov rdi, 1
	mov rsi, neg
	mov rdx, 1
	Syscall
	
	mov rax, 1
	mov rdi, 1
	mov rsi, nl
	mov rdx, len
	Syscall
	
	
	mov rax, 60
	mov rdi, 0
	Syscall
