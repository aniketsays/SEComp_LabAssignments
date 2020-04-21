section .data
success: db "File opened successfully", 0x0A
lsuccess: equ $-success
failure: db "File cannot be opened", 0x0A
lfailure: equ $-failure


section .bss
%macro mymacro 4
mov rax, %1 
mov rdi, %2
mov rsi, %3
mov rdx, %4
syscall
%endmacro

filename1: resb 200
filename2: resb 200
filename3: resb 200
filename4: resb 200

fd_1: resb 200
fd_2: resb 200
fd_4: resb 200

len1: resb 200
len2: resb 200

buffer: resb 200


section .text
global main
main:

pop rbx
pop rbx
pop rbx
cmp byte[rbx], 63h
je copy
cmp byte[rbx], 64h
je del
jmp type


copy:
pop rbx
mov rsi, filename1
up1:
mov al, byte[rbx]
mov byte[rsi], al
inc rsi
inc rbx
cmp byte[rbx], 0
jne up1


pop rbx
mov rsi, filename2
up2:
mov al, byte[rbx]
mov byte[rsi], al
inc rbx
inc rsi
cmp byte[rbx], 0
jne up2

mymacro 2, filename1, 2, 0777
mov qword[fd_1], rax
bt rax, 63
jnc down1
mymacro 1, 1, failure, lfailure
jmp exit
down1:
mymacro 1, 1, success, lsuccess

mymacro 0, [fd_1], buffer, 200
mov qword[len1], rax



mymacro 2, filename2, 2, 0777
mov qword[fd_2], rax
bt rax, 63
jnc down2
mymacro 1, 1, failure, lfailure
jmp exit
down2:
mymacro 1, 1, success, lsuccess

mymacro 1, [fd_2], buffer, qword[len1]


mov rax, 3
mov rdi, [fd_1]
syscall

mov rax, 3
mov rdi, [fd_2]
syscall
jmp exit


del:
pop rbx
mov rsi, filename3
up3:
mov al, byte[rbx]
mov byte[rsi], al
inc rsi
inc rbx
cmp byte[rbx], 0
jne up3

mov rax, 87
mov rdi, filename3
syscall
jmp exit


type:
pop rbx
mov rsi, filename4
up4:
mov al, byte[rbx]
mov byte[rsi], al
inc rsi
inc rbx
cmp byte[rbx], 0
jne up4

mymacro 2, filename4, 2, 0777
mov qword[fd_4], rax
bt rax, 63
jnc down6
mymacro 1, 1, failure, lfailure
jmp exit
down6:
mymacro 1, 1, success, lsuccess

mymacro 0, [fd_4], buffer, 200
mov qword[len2], rax

mymacro 1, 1, buffer, qword[len2]

mov rax, 3
mov rdi, [fd_4]
syscall
jmp exit


exit:
mov rax, 60
mov rdi, 0
mov rax, 60
mov rdi, 0
syscall

