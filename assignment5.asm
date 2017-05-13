TITLE Sorting Random Integers    (Project05.asm)

; Author: Xilun Guo
; Onid email: guox@oregonstate.edu
; Class: CS271-400
; Course / Project ID : Project 5              Due Date: 08/03/2015
; Description: User input the number of random numbers, which will be displayed. After that, sorting those random numbers by decreasing order and display them.

INCLUDE Irvine32.inc

LOWER_LIMITED = 10
HIGHER_LIMITED = 200
LO = 100
HI = 999

.data
intro_1     BYTE	"Sorting Random Integers                  Programmed by Xilun Guo", 10, 13, 0
intro_2     BYTE    "This program generates random numbers in the range [100 .. 999], displays the original list, sorts the list, and calculates the median value.  Finally, it displays the list sorted in descending order. ", 10, 13, 0
EC2         BYTE    "Use a recursive sorting algorithm (Bubble sort). ", 10, 13, 0
prompt_1    BYTE    "How many numbers should be generated? [10 .. 200]: ", 0
Invalid     BYTE    "Invalid input", 10, 13, 0

display_unsorted	BYTE	"The unsorted random numbers: ", 10, 13, 0
display_median      BYTE	"The median is: ", 0
display_sorted      BYTE	"The sorted list: ", 10, 13, 0

good_bye    BYTE 	"Goodbye.", 10, 13, 0

user_num    DWORD   ?
nArray		DWORD	200 DUP(?)
spaces		DWORD	"  ", 0
temp        DWORD   ?

.code
main PROC
    call    intro
    call    get_user_num
    call    CrLf

    push	OFFSET nArray
    push	user_num
    call    fillArray

    mov     edx, OFFSET display_unsorted
    call    WriteString
    push	OFFSET nArray
    push	user_num
    call    displayArray
    call    CrLf

    push    OFFSET nArray
    push    user_num
    call    bubble_sort

    push	OFFSET nArray
    push	user_num
    call    displayMedian
    call    CrLf

    mov     edx, OFFSET display_sorted
    call    WriteString
    push	OFFSET nArray
    push	user_num
    call    displayArray
    call    CrLf

    mov     edx, OFFSET good_bye
    call    WriteString
    call    CrLf
    exit
main ENDP



;introduces the program
intro PROC
    mov     edx, OFFSET intro_1
    call    WriteString
    mov     edx, OFFSET intro_2
    call    WriteString
    call    CrLf
    mov     edx, OFFSET EC2
    call    WriteString
    call    CrLf
    ret
intro ENDP

;get the user input and validate the num if is between the range
get_user_num PROC
    mov     edx, OFFSET prompt_1
    call    WriteString
    call    ReadInt
    cmp     eax, LOWER_LIMITED
    jl      Invalid_input
    cmp     eax, HIGHER_LIMITED
    jg      Invalid_input
	jmp		Good_input
Invalid_input:
    mov     edx, OFFSET Invalid
    call    WriteString
    call    get_user_num
Good_input:
    mov     user_num, eax
    ret
get_user_num ENDP

;fill in the nArray by random numbers
fillArray PROC
    push	ebp
    mov		ebp, esp
    mov		ecx, [ebp+8]
    mov		edi, [ebp+12]
get_Rand_Num:
    mov		eax, HI
    sub		eax, LO
    inc		eax
    call	RandomRange
    add		eax, LO
    mov		[edi], eax
    add		edi, 4
    loop	get_Rand_Num
    pop		ebp
    ret		8
fillArray ENDP

;display the current nArray
displayArray PROC
    pushad
    mov		eax, 0
    mov		ecx, user_num
    mov		esi, 0
    mov		temp, 0
display:
    .if		temp == 10
        mov		temp, 0
        call	CrLf
    .else
        .ENDIF
    mov		eax, nArray[esi*sizeof DWORD]
    call	WriteDec
    mov		edx, OFFSET spaces
    call	WriteString
    inc		esi
    inc		temp
    loop 	display
    popad
    call	CrLf
    ret		12
displayArray ENDP

;calculate the median number, if it's odd user_num then just output the number, otherwise output the average of two numbers.'
displayMedian PROC
	call	CrLf
	push	ebp
	mov		ebp, esp
	mov		edx, OFFSET display_median
	call	WriteString
    xor     edx, edx
    mov     eax, user_num
    mov     ebx, 2
    cdq
    div     ebx
    cmp     edx, 0
    je      enen_num
    jne     odd_num
enen_num:
    mov		esi, eax
    mov		eax, nArray[esi*sizeof DWORD]
    dec		esi
    add		eax, nArray[esi*sizeof DWORD]
    cdq
    div		ebx
    call	WriteDec
    ret     4
odd_num:
    mov		esi, eax
    mov		eax, nArray[esi*sizeof DWORD]
    call	WriteDec
    ret     4
displayMedian ENDP

;Sorting the nArray numbers by bubble_sort from biggest to smallest
bubble_sort PROC
    mov 	ecx, user_num
    dec 	ecx
Loop1:
    push 	ecx
    mov 	esi, OFFSET nArray
Loop2:
    mov 	eax, [esi]
    cmp 	[esi+4], eax
    jl 		Loop3 			;if [ESI] <= [ESI+4], no exchange
    xchg 	eax, [esi+4] 	;exchange the pair
    mov 	[esi], eax
Loop3:
    add 	esi, 4
    loop 	Loop2
    pop 	ecx
    loop 	Loop1
Loop4:
    ret		8
bubble_sort ENDP

END main

