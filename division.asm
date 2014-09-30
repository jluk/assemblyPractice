; DO NOT ADD ANY LINES THAT BEGIN WITH @plugin OR YOU RISK GETTING A ZERO FOR THIS PART.

; Author: Justin Luk
; GtId: 902554744

.orig x3000
		LD R0, U				; U
		LD R1, V				; V
		
		; Your code here
		AND R2, R2, 0
		AND R3, R3, 0
		AND R1, R1, R1
		BRz BZERO
		BRp NOTZERO
NOTZERO
		NOT R4, R1
		ADD R4, R4, 1
		ADD R5, R0, R4
		BRn DONE
		ADD R2, R2, 1
		ADD R0, R5, 0
		BR NOTZERO

BZERO
		ADD R2, R2, -1

DONE
		ST R0, REMAINDER
		ST R2, QUOTIENT

		HALT					; Stop program x300F

		; Change U and V to suit your needs
		U .fill 16				; Initialize U x3012
		V .fill 12				; Initialize V x3013
		QUOTIENT .blkw 1			; Store your quotient here
		REMAINDER .blkw 1			; Store your remainder here
.end

