section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_crypt

	; initializam ecx cu numarul de runde
	mov ecx, [num_rounds]
rounds_loop_enc:
	; initializam ebx cu numarul de bytes
	mov ebx, 8
	; folosim edx pentru a stoca pozitia
	mov edx, 0
	bytes_loop_enc:
		; obtinem litera curenta din plaintext incepand de la prima pozitie
		mov al, byte [esi + edx]

		; punem continutul lui ebx pe stiva, pentru a uitiliza registrul
		; in interiorul buclei
		push ebx

		; obtinem litera curenta din key
		mov bl, byte [edi + edx]
		add al, bl

		; schimbam valoarea lui t care este stocat in al cu sbox[t]
		movzx eax, al
		mov al, byte [sbox + eax]

		; obtinem urmatoarea pozitie
		add edx, 1
		and edx, 7

		; punem continutul lui ecx pe stiva, pentru a uitiliza registrul
		; in interiorul buclei
		push ecx
		mov ecx, edx
		; obtinem uramatoarea litera 
		mov bl, byte [esi + ecx]
		pop ecx

		add al, bl
		; rotim cu un bit la stanga
		rol al, 1

		push ecx
		mov ecx, edx
		and ecx, 7
		; actualizăm byte-ul de pe poziția (i + 1) % block_size
		; cu valoarea lui t
		; i + 1 se afla in edx
		mov byte [esi + ecx], al

		; scoatem din stiva valorile necesare pentru bucle
		pop ecx
		pop ebx
		dec ebx
		cmp ebx, 0
		; daca este mai mare decat 0, continuam,
		; in caz contarar se opreste bucla pentru bytes
		jg bytes_loop_enc
	dec ecx
	cmp ecx, 0
	; daca este mai mare decat 0, continuam,
	; in caz contarar se opreste bucla pentru runde
	jg rounds_loop_enc
    	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_dcrypt

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key

	; initializam ecx cu numarul de runde
	mov ecx, [num_rounds]
rounds_loop_dec:
	; initializam ebx cu numarul de iteratii pentru bytes,
	; de la pozitia 7 pana la pozitia 0
	mov ebx, 7
	bytes_loop_dec:
		; obtinem litera curenta din plaintext si din key
		; incepand de la ultima pozitie
		mov al, byte [esi + ebx]
		mov dl, byte [edi + ebx]
		add al, dl

		; schimbam valoarea lui t care este stocat in al cu sbox[t]
		movzx eax, al
		mov  al, byte [sbox + eax] ; top

		; punem continutul lui ecx pe stiva, pentru a uitiliza registrul
		; in interiorul buclei
		push ecx
		mov ecx, ebx
		; obtinem in ecx urmatoarea pozitie
		add ecx, 1
		and ecx, 7

		; obtinem litera de pe urmatoarea pozitie
		mov dl, byte [esi + ecx]
		; rotim cu un bit la dreapta
		ror dl, 1 ; bottom
		; calculam rezultatul bottom - top
		sub dl, al
		; actualizăm byte-ul de pe poziția (i + 1) % block_size
		; cu valoarea lui t
		; i + 1 se afla in ecx
		mov byte [esi + ecx], dl

		; scoatem din stiva valoarea necesara pentru bucla
		pop ecx
		dec ebx
		cmp ebx, 0
		; daca este mai mare sau egal cu 0, continuam,
		; in caz contarar se opreste bucla pentru bytes
		jge bytes_loop_dec
	dec ecx
	cmp ecx, 0
	; daca este mai mare decat 0, continuam,
	; in caz contarar se opreste bucla pentru runde
	jg rounds_loop_dec
	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

