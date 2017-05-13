TITLE Composite Numbers     (Project04.asm)

; Author: Xilun Guo
; Onid email: guox@oregonstate.edu
; Class: CS271-400
; Course / Project ID : Project 4              Due Date: 7/27/2015
; Description:

INCLUDE Irvine32.inc

LOWER_LIMIT = 1
UPPER_LIMIT = 400
LINE_DISPLAY = 10
COLS_DISPLAY = 5

.data
intro_1         BYTE	"Composite Numbers     Programmed by Xilun Guo", 10, 13, 0
extra_1         BYTE	"EC1: Align the output columns.", 10, 13, 0
extra_2         BYTE    "Display more composites, but show them one page at a time.  The user can “Press any key to continue …” to view the next page.  Since length of the numbers will increase, it’s OK todisplay fewer numbers per line."
intro_2         BYTE    "Enter the number of composite numbers you would like to see. ", 10, 13, 0
intro_3         BYTE	"I'll accept orders for up to 400 composites.", 10, 13, 0
prompt_1        BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
prompt_invalid	BYTE	"Out of range.  Try again. ", 10, 13, 0

good_bye1		BYTE	"Results certified by Xilun Guo. ", 0
good_bye2		BYTE 	"Goodbye.", 10, 13, 0

spaces1			BYTE	" ", 0
spaces2			BYTE	"  ", 0
spaces3			BYTE	"   ", 0

user_num		DWORD	?
numCount		DWORD	0
tempNumCount	DWORD	0
checkNum		DWORD	2
numToTest		DWORD	4

.code
main PROC
    call	intro
    call	get_num
    mov     eax, user_num
    cmp     eax, 1
    je      input_one
displayLoop:
    call	calculate
    call	display
    mov		eax, user_num
    cmp		eax, numCount
    .if		eax == numCount
        call	good_bye
        jmp    DONE_function
    .else
        jmp     displayLoop
        .ENDIF
input_one:
    mov     eax, 4
    call    WriteDec
    call    CrLf
    jmp     DONE_function

DONE_function:
    exit
main ENDP


;Introduce programmer
intro   PROC
mov		edx, OFFSET intro_1
call	WriteString
mov		edx, OFFSET extra_1
call	WriteString
mov     edx, OFFSET extra_2
call    WriteString
mov		edx, OFFSET intro_2
call	WriteString
mov		edx, OFFSET intro_3
call	WriteString
ret
intro ENDP

;get user input
get_num PROC
mov		edx, OFFSET prompt_1
call	WriteString
call	ReadInt
mov		user_num, eax
call	CrLf
jmp		check_input
get_num ENDP

;check if number is within limit
check_input PROC
cmp		eax, LOWER_LIMIT
jl		outOfRange
cmp		eax, UPPER_LIMIT
jg		outOfRange
ret

outOfRange:
mov		edx, OFFSET prompt_invalid
call	WriteString
jmp		get_num
check_input ENDP

calculate PROC
match:
    mov		ecx, numToTest
    xor     edx, edx
    mov     eax, numToTest
    mov     ebx, checkNum
    div     ebx

.if		edx == 0
    jmp		isComposite
.else
    inc		checkNum
    mov		eax, numToTest
    cmp		checkNum, eax
    jge		isNotComposite
    jmp		match
    .ENDIF

isComposite:
    ret
isNotComposite:
    inc		numToTest
    mov		checkNum, 2
    jmp		match

calculate ENDP

display	PROC
.if		tempNumCount >= LINE_DISPLAY
    call	CrLf
    mov		eax, numToTest
    call	WriteDec
    mov		edx, OFFSET spaces3
    call	WriteString
    .if		numToTest < 10			;aligns columns
        mov		edx, OFFSET spaces2
        call	WriteString
    .elseif	numToTest < 100
        mov		edx, OFFSET spaces1
        call	WriteString
    .else
        .ENDIF
    inc		numToTest
    mov		checkNum, 2
    mov		tempNumCount, 0
    inc		tempNumCount
    inc		numCount
    ret
.else		;stays in the same line
    mov		eax, numToTest
    call	WriteDec
    mov		edx, OFFSET spaces3
    call	WriteString
    .if		numToTest < 10			;aligns columns
        mov		edx, OFFSET spaces2
        call	WriteString
    .elseif	numToTest < 100
        mov		edx, OFFSET spaces1
        call	WriteString
    .else
        .ENDIF
    inc		numToTest
    mov		checkNum, 2
    inc		tempNumCount
    inc		numCount				
    ret
    .ENDIF

display	ENDP

good_bye	PROC
call	CrLf
mov		edx, OFFSET good_bye1
call	WriteString
mov		edx, OFFSET good_bye2
call	WriteString

good_bye	ENDP

END main