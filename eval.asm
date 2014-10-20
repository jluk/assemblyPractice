; Name: Justin Luk


; Main
; Do not edit this function!

.orig x3000

	LD R6, STACK	; Initialize the stack

	LEA R0, STRING	; R0 = &str[0]
	ADD R1, R0, 0

SL_LOOP	LDR R2, R1, 0	; \ R1 = strlen(str)
	BRz SL_END	; |
	ADD R1, R1, 1	; |
	BR SL_LOOP	; |
SL_END	NOT R2, R0	; |
	ADD R2, R2, 1	; |
	ADD R1, R1, R2	; /

	ADD R6, R6, -2	; \ R0 = eval(str, len)
	STR R0, R6, 0	; |
	STR R1, R6, 1	; |
	LD R2, EVALPTR	; |
	JSRR R2		; |
	LDR R0, R6, 0	; |
	ADD R6, R6, 3	; /



	ST R0, ANS
	HALT

ASCIIADD .fill -43
STACK	.fill xf000
ANS	.fill -1
EVALPTR	.fill EVAL
STRING	.stringz "1+2*3+4*5"
	.blkw 200

EVAL

	; Write your function here

	ADD R6, R6, -3	;allocate 3 more slots
	STR R7, R6, 1		;store curr R7 address in stack as RA
	STR R5, R6, 0		;store OFP in stack
	ADD R5, R6, -1	;move FP to one above OFP
	ADD R6, R6, -3	;allocate space for local vars

	AND R2, R2, 0		;i = 0

WHILEPLUS
	LDR R1, R5, 5		;load len from stack into R1
	NOT R3, R1			;bitwise complement
	ADD R3, R3, 1		;negate len store in R3
	ADD R3, R2, R3	;check i < len
	BRzp EXIT1			;R2 - R3 = neg proves i < len
	LDR R3, R5, 4		;load address of char in R3
	ADD R3, R3, R2	;str + i in R3
	LDR R3, R3, 0		;load char into R3
	LD R4, ASCIIADD	;put -43 in R4
	ADD R3, R3, R4	;check if "+" based on ASCII code
	BRnp NOTADD			;if R3 != 0 break out of loop

	ADD R6, R6, -2	;increment SP 2 places
	STR R2, R6, 1		;store i into bottom of new stack
	LDR R0, R5, 4		;load old char in R0
	STR R0, R6, 0		;store char on stack
	STR R2, R5, 0		;update i at FP

	JSR EVAL				;rebuild stack for left, storing RA in R7

	LDR R3, R6, 0		;store return value in R3
	STR R3, R5, -1	;store left in stack

	ADD R6, R6, 1		;move SP back to convention location

	;Calculate R0 = str+i+1
	LDR R0, R5, 4		;load R0 with char
	LDR R1, R5, 0		;load i into R1
	ADD R0, R0, R1	;str + i
	ADD R0, R0, 1		;str + 1

	;Calculate R2 = len-i-1
	LDR R2, R5, 5		;load len into R2
	NOT R1, R1			;bitwise complement
	ADD R1, R1, 1		;negate i
	ADD R2, R2, R1	;len - i
	ADD R2, R2, -1	;len - 1

	STR R0, R6, 0		;place str+i+1 in new stack
	STR R2, R6, 1		;place len-i-1 at bottom of new stack

	JSR EVAL				;rebuild stack for right

	LDR R3, R6, 0		;store ret value in R3
	STR R3, R5, -2	;store right in stack


	LDR R3, R5, -1	;store left in R3
	LDR R4, R5, -2	;store right in R4
	ADD R3, R3, R4	;R3 = left + right
	BR DONE

NOTADD						;CASE: Not "+"
	ADD R2, R2, 1		;i++
	BR WHILEPLUS		;unconditional branch back to while loop

EXIT1
	AND R2, R2, 0		;i = 0

WHILEMULT
	LDR R1, R5, 5		;load len from stack into R1
	NOT R3, R1			;bitwise complement
	ADD R3, R3, 1		;negate len store in R3
	ADD R3, R2, R3	;check i < len
	BRzp DONE2			;if R3 is neg don't branch off
	LDR R3, R5, 4		;load address of char in R3
	ADD R3, R3, R2	;str + i in R3
	LDR R3, R3, 0		;load char into R3
	LD R4, ASCIIMULT;put -43 in R4
	ADD R3, R3, R4	;check if "*"
	BRnp NOTMULT		;if R3 == 0 don't branch off

	ADD R6, R6, -2	;increment SP 2 places
	STR R2, R6, 1		;store i into bottom of new stack
	LDR R0, R5, 4		;load old char in R0
	STR R0, R6, 0		;store char on stack
	STR R2, R5, 0		;update i at FP

	JSR EVAL				;rebuild stack for left, storing RA in R7

	LDR R3, R6, 0		;store return value in R3
	STR R3, R5, -1	;store left in stack

	ADD R6, R6, 1		;move SP down one back to convention

	;R0 = str+i+1
	LDR R0, R5, 4		;load R0 with char
	LDR R1, R5, 0		;load i into R1
	ADD R0, R0, R1	; str + i
	ADD R0, R0, 1		;str + 1

	;R2 = len-i-1
	LDR R2, R5, 5		;load len into R2
	NOT R1, R1			;bitwise complement
	ADD R1, R1, 1		;negate i
	ADD R2, R2, R1	;len - i
	ADD R2, R2, -1	;len - 1

	STR R0, R6, 0		;place str+i+1 in new stack
	STR R2, R6, 1		;place len-i-1 at bottom of new stack

	JSR EVAL				;rebuild stack for right

	LDR R3, R6, 0		;store ret value in R3
	STR R3, R5, -2	;store right in stack

	LDR R3, R5, -1	;store left in R3
	LDR R4, R5, -2	;store right in R4

	AND R2, R2, 0		;clear R2 for multiplication
MULTIPLY
	ADD R2, R2, R3	;increment R2 by R3
	ADD R4, R4, -1	;decrement R4
	BRp MULTIPLY
	ADD R3, R2, 0		;set R2 as R3
	BR DONE

NOTMULT						;CASE: not "*"
	ADD R2, R2, 1		;i++
	BR WHILEMULT		;unconditional branch back to while loop


DONE2
	LDR R3, R5, 4		;load memory address of char into R3
	LDR R3, R3, 0		;load actual char into R3
	LD R1, ASCII		;store -48 in R1
	ADD R3, R3, R1	;convert char to int


DONE
	STR R3, R5, 3		;store return value in stack
	ADD R6, R5, 3		;move SP to ret value
	LDR R7, R5, 2		;load return address into R7
	LDR R5, R5, 1		;load OFP into R5
	RET

ASCII .fill -48
ASCIIMULT .fill -42

.end
