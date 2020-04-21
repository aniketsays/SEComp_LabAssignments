section .data
array: dd 201.2, 405.2, 100.3, 45.6, 20.3
meanmsg : db "The mean is ", 0x0A
lmeanmsg : equ $-meanmsg
variancemsg : db "The variance is", 0x0A
lvariancemsg : equ $-variancemsg
sdmsg : db "The standard deviation is", 0x0A
lsdmsg : equ $-sdmsg
point: db '.'
hundred : dq 100
arraycnt : dw 5

section .bss
%macro scall 4
mov rax, %1 
mov rdi, %2
mov rsi, %3
mov rdx, %4
syscall
%endmacro
 
cnt : resb 200
cnt1: resb 200
mean: resb 200
sd : resb 200
vari : resb 200
buffer: resb 200
ans : resb 200

section .text
global main
main:
;***************** Mean ****************
     finit
     fldz
     mov byte[cnt], 5
     mov rsi, array     
up:
     fadd dword[rsi]
     add rsi, 4
     dec byte[cnt]
     jnz up
      
     fidiv word[arraycnt]
     fst dword[mean]
     scall 1, 1, meanmsg, lmeanmsg

     call display

;******************** Variance ****************

      mov dword[vari], 00
      fldz
      mov rsi, array
      mov byte[cnt1], 5
 up2:
      fld dword[rsi]
      fsub dword[mean]
      fst st1
      fmul st0, st1
      fadd dword[vari]
      fst dword[vari]
      add rsi, 4
      dec byte[cnt1]
      jnz up2
      fld dword[vari]
      fidiv word[arraycnt]
      fst dword[vari]
      scall 1, 1, variancemsg, lvariancemsg
      
      call display

;********************** SD ************************

       mov dword[sd], 00
       fldz
       fld dword[vari]
       fsqrt
       fst dword[sd]
       scall 1, 1, sdmsg, lsdmsg
       call display
       jmp exit


;************************** display *******************

display: 
          fimul dword[hundred] 
	fbstp [buffer]
	mov rsi,buffer+9
	mov byte[cnt],9
up1:
	
	mov al,byte[rsi]
	push rsi
	call htoa
	;scall 1,1,meanmsg,lenm
	pop rsi
	dec rsi
	dec byte[cnt]
	jnz up1
	scall 1,1,point,1
	mov rsi,buffer
	mov al,byte[rsi]
	call htoa
	ret



;*********HEX TO ASCII *********************
htoa:
	mov rdi,ans
	mov byte[cnt1],2
up5:
	rol al,4
	mov bl,al
	and bl,0x0F
	cmp bl,9
	jbe down1
	add bl,7
down1:
	add bl,30h
	mov byte[rdi],bl
	inc rdi
	dec byte[cnt1]
	jnz up5
	scall 1,1,ans,2
	ret
;****************EXIT**********************
exit:
	scall 60,0,0,0
