TITLE Fibonacci number (Project2.asm)

;Author: Xilun Guo
; Onid email: guox@oregonstate.edu
; Class: CS271-400
; Course / Project ID : Project 2                Due Date: 07/26/2015
;Description: This program will prompt the user to input the number of fibonacci number, and then it will calculate the string of the Fibonacci, and display them for the user.

INCLUDE Irvine32.inc

MAX = 46
DISPLAY_NUM = 5

.data

user_name	BYTE	33 DUP(0)	;string to be entered by user
intro_1     BYTE    "Fibonacci Numbers", 0
intro_2     BYTE    "Programmed by Xilun Guo", 0
intro_3     BYTE    "Enter the number of Fibonacci terms to be displayed Give the number as an integer in the range [1 .. 46].", 0
EC2         BYTE    "EC2: Do something incredible.", 0
prompt_name BYTE    "What is your name? ", 0
say_hi      BYTE    "Hello, ",0
prompt_num  BYTE    "How many Fibonacci terms do you want? ", 0
num_fib     DWORD   ?           ;the num of fibonacci user input
over_46     BYTE    "Out of range.  Enter a number in [1 .. 46]", 0
space		BYTE	"     ", 0
ecxSave_1	DWORD	?
temp		DWORD	1
temp1       DWORD	?
temp2       DWORD	1
play_again  BYTE    "Do you want to play again (1 - Yes, 0 - No)", 0
play        DWORD   ?           ;1-continue, 0-exit
RC          BYTE    "Results certified by Xilun Guo.", 0
goodBye     BYTE    "Goodbye, ",0

.code
main PROC

;Introduce programmer
    mov     edx, OFFSET intro_1
    call    WriteString
    mov     edx, OFFSET intro_2
    call    WriteString
    mov     edx, OFFSET EC2
    call    WriteString
    call    Crlf

;Get the name from user
    mov     edx, OFFSET prompt_name
    call    WriteString
    mov		edx, OFFSET user_name
    mov		ecx, 32
    call	ReadString
    mov     edx, OFFSET say_hi
    call    WriteString
    mov		edx, OFFSET user_name
    call 	WriteString
    call    Crlf


;Get the num of Fibonacci terms
Program_start:
get_num:
    mov     edx, OFFSET intro_3
    call    WriteString
    call    ReadInt
    mov     num_fib, eax

;Verify the num of Fibonacci terms is less than or equal to 46 in loop
    mov		eax, num_fib
    cmp		eax, MAX
    jg		Error
    jle		GoodInput
Error:
    mov		edx, OFFSET over_46
    call	WriteString
    call	CrLf
    call	get_num
GoodInput:

;Create the Fibonacci
    mov		ecx, num_fib
    mov		eax, 0
    mov		ebx, 1
    mov		temp1, eax
    mov		temp2, ebx
fibonacci:                                  ;outer loop
    cmp		ecx, 0
    je		fibDone                         ;check if done
    mov		eax, temp1
    mov		ebx, temp2
    mov		edx, eax
    add		edx, temp2                      ;get sum
    mov		eax, ebx
    mov		ebx, edx
    mov		temp1, eax
    mov		temp2, ebx
.if		ecx > 0
    jmp		fibDisplay
.else
    jmp		fibDone
.ENDIF

fibDisplay:                                 ;inner loop
    mov		edx, OFFSET	temp2
    call	WriteDec
    mov		edx, OFFSET space
    call	WriteString
    mov		ebx, temp
    cmp		ebx, DISPLAY_NUM
    je		fibDisplayDone					;jump if equals
    inc		ebx
    mov		temp, ebx
    loop	fibonacci
    jmp		fibonacci

fibDisplayDone:
    call	CrLf
    mov 	temp, 1
loop	fibonacci

fibDone:

;Play again or not
mov     edx, OFFSET play_again
call    WriteString
call    ReadInt
mov     eax, play
jnz     Program_start

;Say "Good-bye"
    mov		edx, OFFSET RC
    call	WriteString
    call 	CrLf
    mov		edx, OFFSET goodBye
    call	WriteString
    mov		edx, OFFSET user_name
    call 	WriteString
    call	CrLf
    exit

main ENDP
END main






