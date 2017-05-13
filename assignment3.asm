TITLE Calculate the sum of and the aveage of negative number (Program2.asm)

;Author: Xilun Guo
; Onid email: guox@oregonstate.edu
; Class: CS271-400
; Course / Project ID : Project 2                Due Date: 07/26/2015
;Description: This program is going to let the user input numbers of negative numbers until input a non-negative then stop the input, and then it will calculate the sum of and the ave of the negative numbers the user input, and dispaly onth the screen.

INCLUDE Irvine32.inc

UP_LIMIT = -1
LOW_LIMIT = -100

.data

user_name	BYTE	33 DUP(0)	;string to be entered by user
intro_1     BYTE    "Welcome to the Integer Accumulator by Xilun Guo", 0
EC1         BYTE    "1. Number the lines during user input.", 0
EC2         BYTE    "2. Calculate and display the average as a floating-point number, rounded to the nearest .001.", 0
EC3         BYTE    "3. Do something astoundingly creative.", 0
prompt_name BYTE    "What is your name? ", 0
say_hi      BYTE    "Hello, ",0
intro_2     BYTE    "Please enter numbers in [-100, -1].", 0
intro_3     BYTE    "Enter a non-negative number when you are finished to see results.", 0
line_num    DWORD   1
prompt_num  BYTE    "Enter number: ", 0
error       BYTE    "Please enter numbers in [-100, -1].", 0
current_num DWORD   ?
num_count   DWORD   0
sum_count   DWORD   0
ave_count   DWORD   ?
num_dis1    BYTE    "You entered ", 0
num_dis2    BYTE    " valid numbers.", 0
sum_dis     BYTE    "The sum of your valid numbers is ", 0
ave_dis     BYTE    "The rounded average is ", 0
float_num_count	REAL8	?
float_sum_count	REAL8	?
float_average	REAL4	?
ave_dis2    BYTE    "The float average is ", 0
goodBye     BYTE    "Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0


.code
main PROC

;Introduce programmer
mov     edx, OFFSET intro_1
call    WriteString
call    Crlf
mov     edx, OFFSET EC1
call    WriteString
call    Crlf
mov     edx, OFFSET EC2
call    WriteString
call    Crlf
mov     edx, OFFSET EC3
call    WriteString
call    Crlf

;Get the name from user and say Hi
mov     edx, OFFSET prompt_name
call    WriteString
mov     edx, OFFSET user_name
mov     ecx, 32
call    ReadString
mov     edx, OFFSET say_hi
call    WriteString
mov     edx, OFFSET user_name
call    WriteString
call    Crlf

;Introduce the rules of input
mov     edx, OFFSET intro_2
call    WriteString
call    Crlf
mov     edx, OFFSET intro_3
call    WriteString
call    Crlf

;Get the number by user input
get_num:
mov     eax, line_num
call    WriteDec
mov     edx, OFFSET prompt_num
call    WriteString
call    ReadInt

cmp     eax, LOW_LIMIT
jl      Wrong

cmp     eax, UP_LIMIT
jg      inputdone

add     sum_count, eax
jmp     count_number

Wrong:
    mov     edx, OFFSET error
    call    WriteString
    call    Crlf
    call    get_num

;count the valid number
count_number:
mov     ebx, 1
add     line_num, 1
add     num_count, ebx
loop    get_num
jmp     get_num

inputdone:

;count the ave of input number
mov     eax, sum_count
cdq
mov     ebx, num_count
idiv     ebx
mov     ave_count, eax

fild	num_count			;num_count -> ST(0) ->ST(1)
fst		float_num_count
cdq
fild	sum_count			;sum_count -> ST(0)
fst		float_sum_count
fdiv	ST(0), ST(1)		;ST(0) = num_count / sum_count
fst		float_average		;ST(0) = float_average



;display all the data to the screen
mov     edx, OFFSET num_dis1
call    WriteString
mov     eax, num_count
call    WriteDec
mov     edx, OFFSET num_dis2
call    WriteString
call    Crlf
mov     edx, OFFSET sum_dis
call    WriteString
mov     eax, sum_count
call    WriteInt
call    Crlf
mov     edx, OFFSET ave_dis
call    WriteString
mov     eax, ave_count
call    WriteInt
mov     edx, OFFSET ave_dis2
call    WriteString
mov		eax, float_average
call	WriteFloat
call    Crlf

;Say "Good-bye"
mov     edx, OFFSET goodBye
call    WriteString
mov    edx, OFFSET user_name
call    WriteString
call    Crlf
exit

main ENDP
END main




















