section .text
	global cmmmc

;; int cmmmc(int a, int b)
;; calculate least common multiple fow 2 numbers, a and b


cmmmc:
    push ebp     			;; avem pe stiva old ebp si return adress
	
	add esp, 8   			;; ajungem la primul parametru
	pop eax      			;; scoatem primul argument
	pop ebx      			;; scoatem al doilea argument


	push eax    	   	 	;; bagam pe stiva
	push ebx     			;; bagam pe stiva

;; SCADEM CEL MAI MARE DIN CEL MAI MIC PANA AJUNG EGALE
;;****************************************************************
while_loop:

    cmp eax, ebx
    je finish

	jg greater
	jl lower

greater:
    sub eax, ebx
    jmp repeat 

lower:
    sub ebx, eax
	jmp repeat


repeat:

loop while_loop
;;****************************************************************


finish:
   
   	pop ecx 				;; valoarea ebx
	mul ecx 				;; rezultat = nr2 x parte comuna
	pop ecx 				;; valoare eax
	mul ecx 				;; rezultat = nr1 x nr2 x parte comuna 
    div ebx 				;; rezultat = nr1 x nr2
	div ebx 				;; rezultat = nr1 x nr2 / parte comuna = cmmdc
    
    sub esp, 16 			;; ajungem din nou in zona functiei 
    pop ebp 				;; scoatem old ebp
	ret  					;; pop return adress
