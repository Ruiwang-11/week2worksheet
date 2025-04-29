// Step 1: Check for divide by zero
@R1
D=M
@DIV_ZERO
D;JEQ

// Step 2: Load x and y into working registers
@R0
D=M
@X
M=D
@R1
D=M
@Y
M=D

// Step 3: Compute abs(x) and store sign of x in R5
@X
D=M
@R5
M=0        // R5 = 0 if x >= 0
@X_POS
D;JGE
@R5
M=1        // R5 = 1 if x < 0
@X
D=M
D=-D
(X_POS)
@ABS_X
M=D

// Step 4: Compute abs(y) and store sign of y in R6
@Y
D=M
@R6
M=0        // R6 = 0 if y >= 0
@Y_POS
D;JGE
@R6
M=1        // R6 = 1 if y < 0
@Y
D=M
D=-D
(Y_POS)
@ABS_Y
M=D

// Step 5: Check for overflow: x == -32768 and y == -1
@X
D=M
@NEG32768
D=D+A
@SKIP_OVERFLOW_CHECK
D;JNE
@Y
D=M
@MINUS_ONE
D=D+1
@DIV_OVERFLOW
D;JEQ
(SKIP_OVERFLOW_CHECK)

// Step 6: Initialize remainder and quotient
@ABS_X
D=M
@REM
M=D
@QUOT
M=0

// Step 7: Division loop: while REM >= ABS_Y
(DIV_LOOP)
@REM
D=M
@ABS_Y
D=D-M
@DONE_DIV
D;LT
@ABS_Y
D=M
@REM
M=M-D
@QUOT
M=M+1
@DIV_LOOP
0;JMP

(DONE_DIV)
// Step 8: Adjust quotient sign: if x and y signs differ, negate quotient
@R5
D=M
@R6
D=D+M
@Q_POS
D;JEQ
@QUOT
M=-M
(Q_POS)

// Step 9: Adjust remainder sign: same sign as x
@R5
D=M
@REM_POS
D;JEQ
@REM
M=-M
(REM_POS)

// Step 10: Write results
@QUOT
D=M
@R2
M=D
@REM
D=M
@R3
M=D
@R4
M=0     // R4 = 0 => valid
@END
0;JMP

// Divide by zero case
(DIV_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

// Overflow case: -32768 / -1
(DIV_OVERFLOW)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

(END)
@END
0;JMP

// Constants
(NEG32768)
@32768
D=A
D=-D
@X
D=D+M

(MINUS_ONE)
@1
D=-A

// Working variables (RAM labels)
(X)       // R0 copy
(Y)       // R1 copy
(ABS_X)   // abs(x)
(ABS_Y)   // abs(y)
(REM)     // remainder
(QUOT)    // quotient
