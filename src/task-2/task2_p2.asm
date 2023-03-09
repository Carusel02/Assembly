section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression

par:
	push ebp    					;; push old ebp

	add esp, 8  					;; sarim de ret adrs si old ebp

	pop eax     					;; scoatem primul parametru
	pop ebx     					;; scoatem al doilea parametru
    sub esp, 16 					;; ne intoarcem in zona functiei

    xor ecx, ecx
	xor edx, edx

;; NUMARAM PARANTEZELE SA VEDEM DACA NR DESCHIDE = NR INCHISE
;;***************************************************************
while_loop:

    cmp eax, 0
    je finish
 
	cmp byte [ebx + eax], 40 		;; ascii code for '('
	je soulmate_1

	cmp byte [ebx + eax], 41 		;; ascii code for ')'
	je soulmate_2
    
soulmate_1:
    add ecx, 1
	sub eax, 1
    jmp while_loop

soulmate_2:
    add edx, 1
	sub eax, 1
	jmp while_loop


finish:

    cmp ecx, edx
	je case_true
	jne case_false

;;***************************************************************


case_true:							;; CASE TRUE
    xor eax, eax
	add eax, 1
    jmp return_function



case_false:							;; CASE FALSE
    xor eax, eax
	jmp return_function

return_function:

    pop ebp     					;; scoatem old ebp
	ret
