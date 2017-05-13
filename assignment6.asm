TITLE Low Level I/O  (Project06.asm)

; Author: Xilun Guo
; Onid email: guox@oregonstate.edu
; Class: CS271-400
; Course / Project ID : Project 6              Due Date: 08/10/2015
; Description: Providing 10 unsigned decimal integers. Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.
;cited by google about the partial of writeVal and readVal function

INCLUDE Irvine32.inc


mWriteString MACRO buffer
    push edx                ;Save edx register
    mov edx, OFFSET buffer
    call WriteString
    pop edx                 ;Restore edx
ENDM

mGetString	 MACRO	a, x
    push	edx
    push	ecx
    mov  	edx, a
    mov  	ecx, x
    call 	ReadString
    pop		ecx
    pop		edx
ENDM

TOTAL_INPUT = 10
LIMMIT_BIT = 32

.data
intro_1     BYTE    "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 10, 13, 0
intro_2     BYTE    "Written by:  Xilun Guo", 10, 13, 0
intro_3     BYTE    "Please provide 10 unsigned decimal integers. Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 10, 13, 0
EC1         BYTE    "Numbers each line of user input / displays running subtotal of  user’s numbers", 10, 13, 0
prompt_1    BYTE    "Please enter an unsigned number: ", 0
Invalid     BYTE    "ERROR: You did not enter an unsigned number or your number was too big.", 10, 13, 0
prompt_again    BYTE   "Please try again: ", 0

display_input   BYTE    "You entered the following numbers: ", 10, 13, 0
comma           BYTE    ", ", 0
display_sum     BYTE    "The sum of these numbers is: ", 0
display_ave     BYTE    "The average is: ", 0

good_bye    BYTE    "Thanks for playing!", 10, 13, 0

all_input       DWORD   0
correct_input   DWORD   0
valArray        BYTE    200  DUP(?)
strArray		BYTE	LIMMIT_BIT	DUP(?)
intArray        DWORD   TOTAL_INPUT DUP(?)
sum             DWORD   ?
average         DWORD   ?

.code
main PROC
    call    intro
    call    get_user_input
    call    displayVal
    call    calculate
    call    displaySum
    call    displayAve
    call    goodBye
    exit
main ENDP

;introduces the program
intro PROC
    mWriteString    intro_1
    mWriteString    intro_2
    call    CrLf
    mWriteString    intro_3
    mWriteString    EC1
    call    CrLf
    ret
intro ENDP

;get the user input and validate the num if is 32 bit or only numbers
get_user_input PROC
	mov		edi, OFFSET intArray
    mov     ecx, TOTAL_INPUT

get_input:
    push    OFFSET  valArray
    push    SIZEOF  valArray
    inc     all_input
    mov     eax, all_input
    call    WriteDec
    mWriteString    prompt_1
    call    readVal

    mov		eax, DWORD PTR valArray
    mov		[edi], eax
    add		edi, SIZEOF DWORD
    loop    get_input

    ret
get_user_input ENDP

;display all the valid input from the user
displayVal PROC
    mov     ecx, TOTAL_INPUT
    mov		esi, OFFSET intArray
    mWriteString    display_input
display_loop:
    mov		eax, [esi]
    add		ebx, eax

    push	eax
    push	OFFSET strArray
    call	writeVal
    mWriteString    comma
    add		esi, SIZEOF DWORD
    loop	display_loop
	ret
displayVal ENDP

;display the sum of all the valid input
displaySum PROC
    mWriteString    display_sum
    mov     eax, sum
    call    WriteDec
    call    CrLf

	ret
displaySum  ENDP

;display the average of all the valid input
displayAve PROC
    mWriteString    display_ave
    mov     eax, average
    call    WriteDec
    call    CrLf
    ret
displayAve  ENDP

;calculate the sum and average
calculate PROC
    mov     eax, 0
    mov     esi, OFFSET intArray
    mov     ecx, TOTAL_INPUT
calculLoop:
    add     eax, [esi]
    add     esi, 4
    loop    calculLoop
    mov     sum, eax
    cdq
    mov     ebx, TOTAL_INPUT
    div     ebx
    mov     average, eax
    ret
calculate ENDP

readVal PROC
    push	ebp
    mov		ebp, esp
    pushad
getInput:
    mov		edx, [ebp+12]
    mov		ecx, [ebp+8]
    mGetString	edx, ecx

    mov		esi, edx
    mov		eax, 0
    mov		ebx, 10
    mov		ecx, 0
convert:
    lodsb					;load memory addressed by ESI into the accumulator
    cmp		ax, 0			;看是否到达string的最后
    je		DONE

    cmp		ax, 30h
    jl		invalid1
    cmp		ax, 39h
    jg		invalid1

    valid:
        sub		ax, 30h			;为了拿到int
        xchg	eax, ecx		;place character value in ecx
        mul		ebx				;multiply by 10 for correct digit place
        jc		invalid1        ;carry 的话就是大于32bit
        xchg    eax, ecx
        add     ecx, eax
        jmp     convert

    invalid1:
        mWriteString    Invalid
        inc     all_input
        mov     eax, all_input
        call    WriteDec
        mWriteString    prompt_again
        jmp     getInput
DONE:
    xchg	ecx, eax
    mov		DWORD PTR valArray, eax
    popad		;restore all the registers
    pop ebp
    ret 8

readVal ENDP

writeVal PROC
    push	ebp
    mov		ebp, esp
    pushad

    mov		eax, [ebp+12]	;move the integer to convert to a string to eax
    mov		edi, [ebp+8]	;move the adress to edi to store the string
    mov		ebx, 10
    push	0

convertToInt:
    cdq
    mov		edx, 0
    div		ebx
    add		edx, 48
    push	edx			;push 下一个digit到stack

    cmp		eax, 0		;check if reaches the end
    jne		convertToInt

displayLoop:
    pop		[edi]
    mov		eax, [edi]
    inc		edi
    cmp		eax, 0				;check if reaches the end
    jne		displayLoop

    mov		edx, [ebp+8]
    mWriteString	OFFSET strArray

    popad
    pop ebp
    ret 8


writeVal ENDP



goodBye PROC
    mWriteString    good_bye
    ret
goodBye ENDP

END main


