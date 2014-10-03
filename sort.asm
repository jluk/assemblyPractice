; Do not add any comments beginning with @plugin

; Author: Justin Luk
; GtId: 902554744

.orig x3000
			LD 	R0, ARRAY_SIZE		; R0 is array_size
			LEA R1, ARRAY			; R1 is array address
							; Start your code here

;R0 = n-1
;R1 = array address
;R2 = Temp for math
;R3 = I
;R4 = Temp for math
;R5 = J
;R6 = N
;R7 = N-1
		
		;Initialize all registers
		AND R2, R2, 0
		AND R3, R3, 0
		AND R4, R4, 0
		AND R5, R5, 0
		AND R6, R6, 0
		
	OUTERLOOP
		ADD R7, R0, -1
		NOT R7, R7
		ADD R7, R7, 1
		ADD R4, R3, R7		;check i - (ARRAY_SIZE - 1)
		BRzp FIRSTEND		;if fail to meet first for loop condition
		ADD R5, R3, 1		;Set R5 as j = i+1

		INNERLOOP

			LD R6, ARRAY_SIZE
			NOT R6, R6
			ADD R6, R6, 1
			ADD R4, R5, R6		;Check j - n
			BRzp SECONDEND
			
			ADD R2, R1, R3		;Find i in array
			ADD R4, R1, R5		;Find j in array
			LDR R2, R2, 0		;Place a[i]
			LDR R6, R4, 0		;Place a[j]
			NOT R6, R6		;Bitwise Complement a[j]
			ADD R6, R6, 1		;Negate a[j]
			ADD R7, R2, R6		;Check a[i] - a[j]
			BRzp THIRDEND
				
				ADD R2, R1, R3	;Find i in array since we overwrote
				LDR R4, R2, 0	;temp = a[i]
				ADD R6, R1, R5	;Place address of j
				LDR R7, R6, 0	;Place a[j]
				STR R7, R2, 0 	;Store R7 in mem[R2]
				ADD R2, R1, R3	;Find i in array memory
				STR R4, R6, 0	;Store temp in mem[a[j]]
				
			THIRDEND
			ADD R5, R5, 1		;Increment j for return loop
			BR INNERLOOP
		
		SECONDEND
		ADD R3, R3, 1		;Increment i		
		BR OUTERLOOP

		
	FIRSTEND

STOP		HALT					; Stop program


ARRAY_SIZE 	.fill 	5

ARRAY		.fill 	1
		.fill 	0
		.fill	4
		.fill 	2
		.fill	-1
.end
