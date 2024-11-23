LDI R20, 0 ; Input, Number to be evaluated
LDI R22, 0 ; Result, Number of 0s in R20
LDI R21, 8 ; Counter
_loop:
LSL R20 ; << 1
BRCS _noCarry ; if carry, jump, skip the increment
INC R22 ; if no carry, increment the result
_noCarry:
dec R21   ; decrement the counter
jnz _loop ; loop until 8 bits are evaluated
;R22 will have the number of 0s in the 8 bits of R20