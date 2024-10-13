; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push ebp
    mov ebp, esp

    ; sa-nceapa concursul

    ; punem stringul in edx
    mov edx, [ebp + 8]
    ; intializam pozitia cu 0
    mov ecx, 0
    ; returnam 0 daca nu sunt probleme de parantezare
    mov eax, 0
loop:
    ; extrag fiecare caracter din string
    movzx edi, byte [edx + ecx]

    ; verificam daca caracterul este null
    cmp edi, 0
    je end

    ; verificam daca caracterul este "("
    cmp edi, 0x28
    je push_parantheses

    ; verificam daca caracterul este "("
    cmp edi, 0x5B
    je push_parantheses

    ; verificam daca caracterul este "["
    cmp edi, 0x7B
    je push_parantheses

    jmp closed_parantheses

; punem parantezele deschise pe stiva
push_parantheses:
    push edi
    jmp next

closed_parantheses:
    ; verificam daca caracterul este ")"
    cmp edi, 0x29
    je round

    ; verificam daca caracterul este "]"
    cmp edi, 0x5D
    je square

    ; verificam daca caracterul este "}"
    cmp edi, 0x7D
    je brace

; daca paranteza este ")", verificam daca pe stiva este 
; paranteza dechisa a acesteia
round:
    pop esi
    cmp esi, 0x28
    ; daca nu este inseamna ca parantezarea este gresita
    jnz wrong
    jmp next

; daca paranteza este "]", verificam daca pe stiva este 
; paranteza dechisa a acesteia
square:
    pop esi
    ; daca nu este inseamna ca parantezarea este gresita
    cmp esi, 0x5B
    jnz wrong
    jmp next

; daca paranteza este "}", verificam daca pe stiva este 
; paranteza dechisa a acesteia
brace:
    pop esi
    cmp esi, 0x7B
    ; daca nu este inseamna ca parantezarea este gresita
    jnz wrong
    jmp next

wrong:
    ; returnam 1 daca parantezarea este gresita
    mov eax, 1
    jmp end

next:
    inc ecx
    jmp loop

end:
    leave
    ret
