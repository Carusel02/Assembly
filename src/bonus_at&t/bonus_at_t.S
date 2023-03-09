/*
 * Include "positions.h"
 */

#include "positions.h"
/*
 * Don't forget to include "positions.h"
 */

.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl 	%ebp
	movl	%esp, %ebp


    # salt in zona parametrilor
	addl    $8, %esp
	popl    %eax       # adresa v1
    popl    %ebx       # adresa v2
    popl    %ecx       # lungime n
	popl    %edx       # adresa v
    
	# push lungime si adresa v2
	pushl   %ecx
	pushl   %ebx

# *********************************************************

while_loop:
	# adaugare suma in vectorul ebx
    movl    (%eax), %esi
	addl    %esi, (%ebx)

	addl    $4, %eax
	addl    $4, %ebx  
    
    loop while_loop
    
	# refresh valori
	popl    %ebx
    popl    %ecx
    
	# push la lungime si la adresa unde scriem
	pushl   %ecx
	pushl   %edx
    
while_loop_add:
    # adaugare la adresa v
    movl    (%ebx), %esi
	addl    %esi, (%edx)

	addl    $4, %ebx
	addl    $4, %edx  
 
    loop while_loop_add

# ********************************************************
    
	# refresh la valori
	popl    %edx
    popl    %ecx
    # bagam pe stiva
	pushl   %edx
	pushl   %ecx

    # 3 cazuri

	# nu avem nevoie de scalare
	cmpl    $10, %ecx
	je      first_case
    
	# scalare mai mica
	cmpl    $10, %ecx
	jl      second_case
    
	# scalare mai mare
	cmpl    $10, %ecx
	jg      third_case

	jmp final

first_case:
    # substragem fiecare valoare din fiecare pozitie
	subl   $FIRST_VALUE, 4*FIRST_POSITION(%edx)
	subl   $SECOND_VALUE, 4*SECOND_POSITION(%edx)
	subl   $THIRD_VALUE, 4*THIRD_POSITION(%edx)
    jmp final
 
second_case:
    # facem clean la eax si edx (pereche stocare mull si div)
	xor    %eax, %eax
	xor    %edx, %edx
    
	popl   %ecx
	movl   $10 ,  %eax
	divl   %ecx                       # avem in eax scalarea
    
    pushl  %eax                       # push eax

	movl   %eax, %ecx
	movl   $FIRST_POSITION, %eax      
	divl   %ecx
	movl   %eax, %esi                 # prima pozitie in esi

	popl   %eax                       # refresh scala
	pushl  %eax

	movl   %eax, %ecx
	movl   $SECOND_POSITION, %eax  
	divl   %ecx
    
	movl   %eax, %edi                 # a 2 a pozitie in edi

    popl   %eax                       # refresh scala

	movl   %eax, %ecx
	movl   $THIRD_POSITION, %eax      # a 3 a pozitie in eax
	divl   %ecx
    
	# modificare finala
	popl   %edx                            
    subl   $FIRST_VALUE , (%edx,%esi,4)
	subl   $SECOND_VALUE , (%edx,%edi,4)
	subl   $THIRD_VALUE , (%edx,%eax,4)
    
    jmp final

third_case:
    
	xor    %eax, %eax
	xor    %edx, %edx
    
	popl   %eax
	movl   $10 ,  %ecx
	divl   %ecx                       # avem in eax scalarea
    
    pushl  %eax                       # push eax

	movl   %eax, %ecx
	movl   $FIRST_POSITION, %eax    
	mull   %ecx
	movl   %eax, %esi                 # prima pozitie in esi

	popl   %eax                       # refresh scala
	pushl  %eax

	movl   %eax, %ecx
	movl   $SECOND_POSITION, %eax  
	mull   %ecx
	movl   %eax, %edi                 # a 2 a pozitie in edi

    popl   %eax                       # refresh scala

	movl   %eax, %ecx
	movl   $THIRD_POSITION, %eax      # a 3 a pozitie in eax
	mull   %ecx
    
	# modificare finala
	popl   %edx          
    subl   $FIRST_VALUE , (%edx,%esi,4)
	subl   $SECOND_VALUE , (%edx,%edi,4)
	subl   $THIRD_VALUE , (%edx,%eax,4)
    
    jmp final

final:
    # restaurare stiva
	subl   $24, %esp

	leave
	ret
