global get_words
global compare_func
global sort

section .text
extern strlen
extern strcmp
extern qsort

;; compare(void *pointer1, void *pointer2)
compare_func:
    enter 0, 0
    push ebx                         ;; salvare registre
    push esi
    push edi

    mov eax, [ebp + 8]               ;; pointer string1
    mov ebx, [ebp + 12]              ;; pointer string2

;; AFLARE LUNGIMI
;;**************************************************************
string1:
    mov ecx, [eax]                   ;; string1              
    push ecx
    call strlen
    add esp, 4
    mov esi, eax                     ;; lungime string1

string2:
    mov edx, [ebx]                   ;; string2
    push edx
    call strlen
    add esp, 4
    mov edi, eax                     ;; lungime string2
;;**************************************************************

;; IMPARTIRE PE CAZURI
;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
result:

    cmp esi, edi
    jl lower

    cmp esi, edi
    jg greater

    cmp esi, edi
    je equal


equal:

    mov eax, [ebp + 8]                   ;; pointer string1
    mov ebx, [ebp + 12]                  ;; pointer string2
    mov ecx, [eax]                       ;; string1  
    mov edx, [ebx]                       ;; string2

    push edx
    push ecx
    call strcmp
    add esp, 8

    cmp eax, 0
    jl lower

    cmp eax, 0
    jg greater

lower:
    mov eax, -1
    jmp final_section

greater:
    mov eax, 1
    jmp final_section

;;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

final_section:

    pop edi
    pop esi
    pop ebx                           ;; salvare registre
    leave
    ret 

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru sortarea cuvintelor 
;  dupa lungime si apoi lexicografix

sort:
    enter 0, 0
    
    mov eax, [ebp + 8]                ;; matrice pointeri 
    mov ebx, [ebp + 12]               ;; nr cuvinte
    mov ecx, [ebp + 16]               ;; size


    push compare_func
    push ecx
    push ebx
    push eax

    call qsort

    add esp, 16

    
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte


get_words:
    enter 0, 0

    mov eax, [ebp + 8]                 ;; vector string
    mov ebx, [ebp + 12]                ;; matrice de string uri 
    mov ecx, [ebp + 16]                ;; nr cuvinte
    
;;*******************************************************************
    
    xor edx, edx                       ;; 0
    xor esi, esi                       ;; 0
    xor edi, edi                       ;; 0
    mov edx, [ebx]                     ;; pointer nr1

    

move_to_matrix:

    cmp ecx, 0                         ;; final 
    je  final
    
    cmp byte [eax], 32                 ;; SPACE (   )
    je next

    cmp byte [eax], 44                 ;; COMMA ( , )
    je next

    cmp byte [eax], 46                 ;; DOT   ( . )
    je next
   
    cmp byte [eax], 10                 ;; NEWLINE ( \n )
    je next

    cmp byte [eax], 0                  ;;  NULL ( , )
    je next

add_word:
    
    mov esi, [eax]                     ;; valoarea eax            
    mov [edx], esi                     ;; muta valoarea eax in pointer
    add edx, 1                         ;; creste edi
    add eax, 1                         ;; creste eax
    jmp move_to_matrix                 ;; repeat

next:
    
    add eax, 1
    
    cmp byte [eax], 32                 ;; SPACE (   )
    je next

    cmp byte [eax], 44                 ;; COMMA ( , )
    je next

    cmp byte [eax], 46                 ;; DOT   ( . )
    je next
   
    cmp byte [eax], 10                 ;; NEWLINE ( \n )
    je next

    cmp byte [eax], 0                  ;;  NULL ( , )
    je next

    mov byte [edx], 0
    add ebx, 4                         ;; noua pozitie
    sub ecx, 1                         ;; pasi--;
    xor esi, esi                       ;; clean esi
    xor edx, edx                       ;; clean edx
    mov edx, [ebx]                     ;; noul pointer  

    jmp move_to_matrix

;;*******************************************************************
   
final:

    leave
    ret
