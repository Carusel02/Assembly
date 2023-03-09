;; declarare vector masca
section .data
    myVect:    times 1005    dw 0

section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list

sort:
	
	enter 0, 0
	mov ecx, [ebp + 8]                     ;; len 
	mov eax, [ebp + 12]                    ;; adresa 
    
;; CAUTARE PRIMUL MINIM
;;*******************************************************************

   mov ecx, [ebp + 8]                     ;; restaurare len vector
   mov eax, [ebp + 12]                    ;; restaurare adresa vector

   xor ebx, ebx                           ;; clean ebx
   mov ebx, 9999                          ;; valoare maxima (valoare min)
   xor edx, edx                           ;; clean edx (adresa min)

min_first:
   cmp ebx, [eax]
   jl  go_first
   
   cmp [myVect + 4 * ecx], dword 0
   jne go_first

   mov ebx, [eax]                         ;; valoare
   mov edx, eax                           ;; adresa
   mov esi, ecx                           ;; masca

go_first:

   add eax, 8                             ;; urmatoarea iteratie

loop min_first

   
   mov [myVect + 4 * esi], dword 1        ;; schimbare masca
   push edx                               ;; valoare initiala
   mov  edi, edx

;;******************************************************************
   
   mov ecx, [ebp + 8]                     ;; restaurare len vector
   mov eax, [ebp + 12]                    ;; restaurare adresa vector


   xor esi,esi
   push ecx                               ;; bagam pe stiva

;; CAUTARE FIECARE MINIM SI IL LEGAM CU CEL PRECEDENT
;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
while_loop:
   
   mov ecx, [ebp + 8]                     ;; restaurare len vector
   mov eax, [ebp + 12]                    ;; restaurare adresa vector
   mov ebx, 9999                          ;; valoare maxima (valoare min)

min_loop:
   cmp ebx, [eax]
   jl  go
   
   cmp [myVect + 4 * ecx], dword 0
   jne go

   mov ebx, [eax]                         ;; valoare
   mov edx, eax                           ;; adresa
   mov esi, ecx                           ;; masca
   
go:

   add eax, 8                             ;; urmatoarea iteratie

loop min_loop

   mov [myVect + 4 * esi], dword 1        ;; schimbare masca

   add edi,4
   mov [edi], edx
   mov edi, edx

   pop ecx                                ;; scoatem din stiva
   sub ecx, 1                             ;; modificam
   push ecx                               ;; bagam la loc
   
loop while_loop
;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    pop ecx                               ;; scoatem din stiva
    pop eax                               ;; adresa return
	 
	 leave
	 ret
