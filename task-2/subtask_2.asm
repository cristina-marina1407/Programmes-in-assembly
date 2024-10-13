; subtask 2 - bsearch

section .text
    global binary_search
    ;; no extern functions allowed

binary_search:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers
    push esi
    push edi
    push ebx

    ; punem argumentul start in esi
    mov esi, dword [ebp + 8]
    ; punem argumentul end in edi
    mov edi, dword [ebp + 12]

    ;; recursive bsearch implementation goes here

    ; verific daca exista intervalul
    cmp edi, esi
    jge subarray_exists
    jl not_found

subarray_exists:
    ; calculam mid in ebx
    mov ebx, edi
    sub ebx, esi
    ; impartim rezultatul la 2
    shr ebx, 1
    add ebx, esi

    ; comparam buff[mid] cu needle
    cmp dword [ecx + 4 * ebx], edx
    je equal
    jg function_call1
    jl function_call2

; daca gasim needle, returnam pozitia sa in eax
equal:
    mov eax, ebx
    jmp end

; cautam in prima jumatate
function_call1:
    dec ebx
    push ebx
    push esi
    call binary_search
    ; restauram stiva
    add esp, 8
    jmp end

; cautam in a doua jumatate
function_call2:
    push edi
    inc ebx
    push ebx
    call binary_search
    ; restauram stiva
    add esp, 8
    jmp end

; elementul nu a fost gasit
not_found:
    ; returnam -1 daca elementul nu exista in vextor
    mov eax, -1
    jmp end

end:
    ;; restore the preserved registers
    pop ebx
    pop edi
    pop esi
    leave
    ret
