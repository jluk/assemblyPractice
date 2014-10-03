; Author: Justin Luk
; GtId: 902554744

.orig x3000
	LD		R0, K
	;R0 = k (incremented at each failed search for a prime)
	;R1 = found
	;R2 = i (the counter)
	;R3 = isPrime (boolean flag)

	;R4 = negated i OR the quotient of k / 2
	;R5 = decremented k
	;R6 = remainder of k / 2

	;Your code here

	AND R1, R1, 0  ;clear and set R1 (found) to 0

NOTFOUND
	ADD R0, R0, 1  ;Increment R0 (k)

	;SET isPrime as 1
	AND R3, R3, 0  ;clear R3
	ADD R3, R3, 1  ;Set R3 as 1

	;Clear quotient of k/2, and k/2
	AND R4, R4, 0  ;clear R4
	AND R6, R6, 0  ;clear R6

	;Reset the counter i back to 2
	AND R2, R2, 0  ;clear R2
	ADD R2, R2, 1  ;set R2 counter as 2
LABEL
	AND R4, R4, 0
	ADD R6, R0, 0  ;shove k into R6 (K-->R6)

FORLOOPDIV          ;Divide k/2 for conditional check
	ADD R6, R6, -2  ;decrement by 2 (K-2)
	BRn COMPAREDIV  ;break once we find the quotient
	ADD R4, R4, -1  ;increment the quotient (QUOTIENT--)
	BR FORLOOPDIV   ;loop until division is complete

COMPAREDIV

	;CHECK i < k/2
	ADD R2, R2, 1
	AND R6, R6, 0   ;Clear R6
	ADD R6, R2, R4  ;i - k/2 and store in R6
	BRp CONT
	
	ADD R3, R3, 0
	BRz CONT

	AND R4, R4, 0  ;clear R4 for modulo arithmatic
	AND R5, R5, 0
	ADD R5, R0, 0

MODULO
	NOT R4, R2	   ;Bitwise Complement of i storing it in R4
	ADD R4, R4, 1  ;Add 1 to finish negating i
	ADD R5, R5, R4 ;subtract (k-i)
	BRn DONE
	ADD R6, R5, 0  ;place new subtracted k value in R6
	BR MODULO      ;continue dividing until remainder is found

DONE
	ADD R3, R6, 0   ;isPrime = k%i
	BR LABEL

CONT
	ADD R1, R3, 0   ;found = isPrime
	BRz NOTFOUND   ;Branch back to while loop if found == 0

FOUND
	ST R0, NEXTPRIME ;Store the prime value in NEXTPRIME
	HALT

	K		.fill	5			; K
	NEXTPRIME	.blkw 	1			; store your answer here
.end
