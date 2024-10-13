%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:
	;; DO NOT MODIFY
	push    ebp
	mov     ebp, esp
	pusha

	mov     eax, [ebp + 8]  ; id and permission
	mov     ebx, [ebp + 12] ; address to return the result
	;; DO NOT MODIFY
   
	;; Your code starts here
	mov edi, eax
	shr edi, 24
	; obtinem in edi id-ul, primii 8 biti
	mov edx, edi

	; obtinem in eax salile pe care le doreste furnica, restul de 24 de biti
	shl eax, 8
	shr eax, 8
	
	; lista de sali pe care furnica cu id ul stocat in edx le poate accesa
	mov esi, dword [ant_permissions + edx * 4] 
	
	; comparam salile pe care furnica le doreste cu cele pe care le poate accesa
	and esi, eax
	cmp esi, eax
	; daca sunt egale, punem 1 in ebx, altfel 0
	jz equal
	mov byte [ebx], 0
	jmp end
equal:
	mov byte [ebx], 1
end:
	;; Your code ends here	
	;; DO NOT MODIFY

	popa
	leave
	ret
	
	;; DO NOT MODIFY
