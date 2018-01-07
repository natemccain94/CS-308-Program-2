; Nate McCain
; Project 2, Assembly Language Programming.

.586
.MODEL FLAT
INCLUDE io.h
.STACK 1000000                 ; reserve 1MB stack
.DATA						   ; reserve storage for data

count    DWORD   ?; This holds the amount of prime numbers the user wishes to generate.
sieve    BYTE    10001 DUP(1); This holds the entire sieve that will be generated.
string   BYTE    40 DUP (?); This temporarily holds the user's input.

inputPrompt  BYTE    "Enter the number of primes you wish to generate.", 0
boundary BYTE	 "The number must be between 1 and 100:", 0
outPrompt  BYTE    "Prime number: ", 0
tooHigh  BYTE	 "Your input is too high.", 0
tooLow	 BYTE	 "Your input is too low.", 0
tryAgain BYTE	 "Please try again.", 0
goodByeOne BYTE  "Your list is complete.", 0
goodByeTwo BYTE  "Goodbye.", 0

primeList WORD    100 DUP (2); This is a list of the prime numbers generated.

EXTERN genPrimes:PROC; genPrimes(int sieve[10001], int primeList[100], int amountOfPrimesNeeded)

.CODE
_sieve  PROC									; start of sieve program code
;*****************************************************************************************************
; This is where we will start the loop to get the input.
getTheInput:
	input	inputPrompt, boundary, string, 40	; Get the user's input.
	atod	string								; Convert the user's input to a DWORD in eax.
	cmp		eax, 0								; Check to see if the user entered zero or below.
	jle		inputIsTooLow						; Try again if the input is to low.
	cmp		eax, 101							; Check to see if the user entered above 101.
	jge		inputIsTooHigh						; Try again if the input is to low.
	mov		count, eax							; Store the user's input in memory.
	jmp		inputIsOkay							; Move on to the next part if the input is okay.
;*****************************************************************************************************
; The input was too low.
inputIsTooLow:
	output	tooLow, tryAgain					; Output the error message for too low.
	jmp		getTheInput							; Try to get the input again.
;*****************************************************************************************************
; The input was too high.
inputIsTooHigh:
	output	tooHigh, tryAgain					; Output the error message for too high.
	jmp		getTheInput							; Try to get the input again.
;*****************************************************************************************************
;*****************************************************************************************************
inputIsOkay:
	;Begin storing parameters on the stack for genPrimes to use.
	mov		eax, count							; User's input address.
	push	eax									; User's input parameter is on the stack.
	lea		eax, primeList						; The list of prime numbers' address.
	push	eax									; The list of prime numbers is on the stack.
	lea		eax, sieve							; The sieve's address.
	push	eax									; The sieve is on the stack.

	; Now to call the genPrimes function.
	call	genPrimes							; genPrimes(sieve,primeList,count)
	add		esp, 12								; Remove the DWORD, WORD, and BYTE parameters off the stack.
	jmp lastPhaseSetup							; Now to print out the values we generated.
;*****************************************************************************************************
;*****************************************************************************************************
lastPhaseSetup:
	mov ecx, count								; Load the value of count into ecx.
	lea ebx, primeList							; Load the starting address of primeList into ebx.
	mov eax, 0									; Clear out register eax.
	jmp lastPhaseLoop							; Jump to the output loop.
;*****************************************************************************************************
lastPhaseLoop:
	cmp ecx, 0									; If the count is zero,
	je exitPhase								; terminate the program.
	; Else, do the following:
	mov eax, [ebx]								; Store the value of ebx in eax.
	add ebx, 2									; Increment to the next value in primeList.
	wtoa string, ax								; Convert to string.						;
	output outPrompt, string					; Output the value.
	dec ecx										; Decrement ecx.
	jmp lastPhaseLoop							; Return to the top of the loop.
;*****************************************************************************************************
;*****************************************************************************************************
exitPhase:
	output goodByeOne, goodByeTwo				; output the goodbye message.
	mov eax, 0									; exit with return code 0
	ret

_sieve ENDP

END
