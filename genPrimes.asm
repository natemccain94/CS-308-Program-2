; Nate McCain
; genPrimes function file for extra credit.

.586
.MODEL FLAT		; Use a flat memory model.
.CODE

; void genPrimes(int sieve[], int primeList[], int count)
; count DWORD ? (Holds just one value)
; primeList DWORD 100 DUP(0)
; sieve BYTE 10001 DUP(1)

genPrimes PROC
		; Time to set up the function
		push ebp		; Save the base pointer.
		mov ebp, esp	; Establish stack frame.
		push eax		; Save register eax.
		push ebx		; Save register ebx.
		push ecx		; Save register ecx.
		push edx		; Save register edx.
		push esi		; Save register esi.

		; Now to generate the list of prime numbers between 2 and 10000.
		; The base address for sieve shall be stored in ebx.
		mov ebx, [ebp + 8]			; ebx now holds the address of the first element of sieve.
		mov ecx, 0					; ecx is the index array.
		mov BYTE PTR [ebx + ecx], 0	; Zero is not a prime number.
		inc ecx						; Increment ecx.
		mov BYTE PTR [ebx + ecx], 0	; One is not a prime number.
		mov ecx, 2					; Index is set to first prime number.
		jmp outerWhileLoop			; Branch to the outerWhileLoop to find all of the prime numbers.
;****************************************************************************************************
outerWhileLoop:
		cmp ecx, 101; if ecx >= 101, exit the outerWhileLoop function
		jae setUpPrimeListLoop		; Go to the function that prepares to populate primeList.

		; if ecx < 101, then do the following:
		mov edx, ecx				; edx will be used as the looping index.
		add edx, ecx				; edx is now the first multiple of the current index.
		cmp BYTE PTR [ebx + ecx], 1	; if sieve[ecx] == 1, branch to the innerWhileLoop function.
		je innerWhileLoop
		jmp outerWhileLoopHelper	; Otherwise, increment ecx and move our indices.
;****************************************************************************************************
innerWhileLoop:
		cmp edx, 10001				; if index is at the end, branch to outerWhileLoopHelper.
		jae outerWhileLoopHelper
		; Otherwise
		mov BYTE PTR [ebx + edx], 0	; set the current index of sieve to 0 because it is not a prime.
		add edx, ecx				; increment edx to the next multiple of ecx.
		jmp innerWhileLoop			; return to the beginning of this loop.
;****************************************************************************************************
outerWhileLoopHelper:
		inc ecx						; increment the counter for outerWhileLoop
		jmp outerWhileLoop			; Go to the beginning of the outerWhileLoop.
;****************************************************************************************************
setUpPrimeListLoop:
		mov ecx, [ebp + 16]			; ecx now holds the value of count.
		mov esi, [ebp + 12]			; Set esi to hold the starting address of primeList.
		mov eax, 2					; Set eax to hold the offset index for the sieve.
		jmp populatePrimeList		; Now to populate the list of prime numbers.
;****************************************************************************************************
populatePrimeList:
		cmp ecx, 0					; If we have populated the list, return to the calling function.
		je exitCode

		cmp BYTE PTR [ebx + eax], 1	; If the sieve points to prime number,
		je	isOnList				; branch to isOnList.
		inc eax						; Else increment the offset,
		jmp populatePrimeList		; and loop back to populatePrimeList.
;****************************************************************************************************
isOnList:
		mov WORD PTR [esi], ax		; Change the value in primeList.
		inc eax						; Increment the offset.
		dec ecx						; Decrement the counter.
		add esi, 2					; Move esi to point at the next element of primeList.
		jmp populatePrimeList
;****************************************************************************************************
exitCode:
		mov esi, [ebp + 12]			; Just a check.
		pop esi						; Restore register esi.
		pop edx						; Restore register edx.
		pop ecx						; Restore register ecx.
		pop ebx						; Restore register ebx.
		pop eax						; Restore register eax.
		pop ebp						; Restore register ebp.

		ret							; Return to the calling function.
genPrimes ENDP
END