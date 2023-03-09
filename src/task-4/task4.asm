section .text
	global cpu_manufact_id
	global features
	global l2_cache_info
	
;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string

cpu_manufact_id:
	enter 	0, 0
    
	mov edi, [ebp + 8]
    xor eax, eax  

;; TRANSCRIERE SIR
;;***************************************************************
	cpuid                     	 	 ;; executa comanda cand eax = 0

	mov [edi], ebx             
	add edi, 4
	mov [edi], edx
	add edi,4
	mov [edi], ecx

;;***************************************************************
	leave
	ret

;; void features(int *apic, int *rdrand, int *mpx, int *svm)
;
;  checks whether apic, rdrand and mpx / svm are supported by the CPU
;  MPX should be checked only for Intel CPUs; otherwise, the mpx variable
;  should have the value -1
;  SVM should be checked only for AMD CPUs; otherwise, the svm variable
;  should have the value -1
features:
	enter 	0, 0
    

APIC_RDRAND:                         ;;  eax = 1 -> cpuid -> compare bit 21 / 30 ecx 
    
    push ebx
	push edi
	push esi
 

    xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
    
    mov eax, 1                  	;; eax = 1
	cpuid
    
	mov ebx, [ebp + 8]         	    ;; adress1 to write
    mov edx, [ebp + 12]         	;; adress2 to write

    bt ecx, 30                      ;; compare bit
	jc true

	bt ecx, 30
	jnc false

next:
 
	bt ecx, 21                 	    ;; compare bit
	jc adevarat

	bt ecx, 21
	jnc fals

next_2:
	
	bt ecx, 13                  	;; compare bit
	jc adevarat_2

	bt ecx, 13
	jnc fals_2

	jmp result

;; ZONA DE OUTPUT
;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
true:
	mov dword [edx], 1
	jmp next
false:
    mov dword [edx], 0
	jmp next

adevarat:
    mov dword [ebx], 1
	jmp next_2
fals:
    mov dword [ebx], 0
	jmp next_2

adevarat_2:
    mov ebx, [ebp + 16]
	mov dword [ebx], 0
	jmp result
fals_2:
    mov ebx, [ebp + 16]
	mov dword [ebx], 1
	jmp result
;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

result:

    pop esi
	pop edi
	pop ebx
	
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0

	
	leave
	ret
