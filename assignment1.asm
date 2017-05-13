TITLE calcultor     (Project1.asm)

; Author: Xilun Guo
; Onid email: guox@oregonstate.edu
; Class: CS271-400
; Course / Project ID : Project1                Due Date: 06/29/2015
; Description: This program will prompt the user to input two numbers, then it will calculate the sum, difference, product, qotient and remainder for the user.

INCLUDE Irvine32.inc
.data

intro_1		BYTE	"Hi, my name is Xilun, Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
ex credit   BYTE    "Extra Credit1: Repeat until the user chooses to quit.", 0
ex credit   BYTE    "Extra Credit2: Program verifies second number is less than first.", 0
prompt_1	BYTE	"First number: ", 0
prompt_2    BYTE    "Second number:  ", 0
num_check   BYTE    "The second number must be less than the first one! ", 0
first_num   DWORD	?			;first integer to be entered by user
second_num  DWORD	?			;second integer to be entered by user
sample_1    BYTE    " + ", 0
sample_2    BYTE    " - ", 0
sample_3    BYTE    " x ", 0
sample_4    BYTE    " ÷ ", 0
sample_0    BYTE    " = ", 0
remain      BYTE    " remainder ", 0
result_sum  DWORD   ?           ;sum of two integers
result_sub  DWORD   ?           ;sub of two integers
result_pro  DWORD   ?           ;pro of two integers
result_div  DWORD   ?           ;div of two integers
rem_temp    DWORD   ?           ;to calculate the remainder
result_rem  DWORD   ?           ;remainder of quotient
play_again  BYTE    "Do you want to play again (1 - Yes, 0 - No)", 0
play        DWORD   ?           ;1-continue, 0-exit
goodBye		BYTE	"Impressed?  Good bye! ", 0


.code
main PROC

;Introduce programmer
mov		edx, OFFSET intro_1
call	WriteString
call	CrLf


;Get first number
Program_start:
mov		edx, OFFSET prompt_1
call	WriteString
call	ReadInt
mov		first_num, eax
call    CrLf

;Get second number
mov		edx, OFFSET prompt_2
call	WriteString
call	ReadInt
mov		second_num, eax
call    CrLf

;Check num1 bigger than num2
mov     eax, first_num
mov     ebx, second_num
Check:
    .if         eax < ebx
        mov     edx, OFFSET num_check
        call    WriteString
        call    CrLf
        exit
    .else
        .ENDIF

;Calculate sum
mov     eax, first_num
add     eax, second_num
mov     result_sum, eax

;Calculate subtraction
mov     eax, first_num
sub     eax, second_num
mov     restult_sub, eax

;Calculate production
mov    eax, first_num
mov    ebx, second_num
mul    ebx
mov    result_pro, eax

;Calculate divison
mov     eax, first_num
cdq
mov     ebx, second_num
div     ebx
mov     result_div, eax

;Calculate remainder
mov     eax, second_num
mov     ebx, result_div
mul     ebx
mov     rem_temp, eax
mov     eax, first_num
sub     eax, rem_temp
mov     result_rem, eax

;Report result of sum
mov		eax, first_num
call	WriteDec
mov		edx, OFFSET sample_1
call	WriteString
mov		eax, second_num
call	WriteDec
mov     edx, OFFSET sample_0
call    WriteString
mov     eax, result_sum
call    WriteDec
call	CrLf

;Report result of subtraction
mov		eax, first_num
call	WriteDec
mov		edx, OFFSET sample_2
call	WriteString
mov		eax, second_num
call	WriteDec
mov     edx, OFFSET sample_0
call    WriteString
mov     eax, result_sub
call    WriteDec
call	CrLf

;Report result of product
mov		eax, first_num
call	WriteDec
mov		edx, OFFSET sample_3
call	WriteString
mov		eax, second_num
call	WriteDec
mov     edx, OFFSET sample_0
call    WriteString
mov     eax, result_pro
call    WriteDec
call	CrLf

;Report result of division and remainder
mov		eax, first_num
call	WriteDec
mov		edx, OFFSET sample_4
call	WriteString
mov		eax, second_num
call	WriteDec
mov     edx, OFFSET sample_0
call    WriteString
mov     eax, result_div
call    WriteDec
mov     edx, OFFSET remain
call    WriteString
mov     eax, result_rem
call    WriteDec
call    CrLf

;Play again or not
mov     edx, OFFSET play_again
call    WriteString
call    ReadInt
mov     eax, play
jnz     Program_start

;Say "Good-bye"
mov		edx, OFFSET goodBye
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf

exit	; exit to operating system
main ENDP

END main