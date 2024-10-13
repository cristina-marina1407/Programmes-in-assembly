%include "../include/io.mac"

; The `expand` function returns an address to the following type of data
; structure.
struc neighbours_t
    .num_neighs resd 1  ; The number of neighbours returned.
    .neighs resd 1      ; Address of the vector containing the `num_neighs` neighbours.
                        ; A neighbour is represented by an unsigned int (dword).
endstruc

section .bss
; Vector for keeping track of visited nodes.
visited resd 10000
global visited

section .data
; Format string for printf.
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
; 
; note: uint32_t is an unsigned int, stored on 4 bytes (dword).

dfs:
    push ebp
    mov ebp, esp

    ; pastram registrii
    push esi
    push edi
    push eax
    push ebx
    push ecx
    push edx

    ; punem nodul in esi
    mov esi, dword [ebp + 8]
    ; punem ponterul la functia expand in edi
    mov edi, dword [ebp + 12]

    ; extragem valoarea din vectorul visited
    mov ebx, dword [visited + 4 * esi]
    ; verificam daca nodul este vizitat
    cmp ebx, 1
    je end

    ; marcam nodul ca fiind vizitat
    mov dword [visited + esi * 4], 1

    ; printam nodul
    push esi
    push fmt_str
    call printf
    ; restauram stiva
    add esp, 8

    ; apelam functia expand asupra nodului
    push esi
    call edi
    ; restauram stiva
    add esp, 4

    ; functia returneaza structura neighbours_t
    ; in ecx se afla numarul de vecini
    mov ecx, dword [eax]
    ; in edx se afla vectorul de vecini
    mov edx, dword [eax + 4]

    ; initializam pozitia cu 0
    mov ebx, 0
loop:
    dec ecx
    ; verificam daca am epuizat numarul de vecini
    cmp ecx, 0
    jl end

    ; extragem vecinii nodului
    mov esi, dword [edx + ebx * 4]

    ; verific daca vecinul nodului este vizitat
    mov eax, dword [visited + esi * 4]
    ; daca vecinul este vizitat se continua parcurgerea
    cmp eax, 1
    je continue
    ; daca vecinul nu este vizitat se apeleaza dfs
    jne function_call

; apelul recursiv al functiei asupra vecinilor
function_call:
    push edi
    push esi
    call dfs
    ; restauram stiva
    add esp, 8

continue:
    inc ebx
    jmp loop

end:
    ; restauram registrii
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop edi
    pop esi
    leave
    ret
