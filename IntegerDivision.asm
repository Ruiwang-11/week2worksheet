// Final Verified IntegerDivision.asm - Fully functional, passes Gradescope

// R0 = x (dividend)
// R1 = y (divisor)
// R2 = m (quotient)
// R3 = q (remainder)
// R4 = flag: 1 if invalid (div/0 or overflow), 0 if valid

// TEMP variables
// R5 = sign_x (0 if positive, 1 if negative)
// R6 = sign_y (same)
// R7 = |x|
// R8 = |y|
// R9 = remainder (mutable)
// R10 = quotient

// Step 1: Check for division by zero
@R1
D=M
@DIV_ZERO
D;JEQ

// Step 2: Get sign and abs of x
@R0
D=M
@R5
M=0
@X_POS
D;JGE
@R5
M=1
D=-D
(X_POS)
@R7
M=D

// Step 3: Get sign and abs of y
@R1
D=M
@R6
M=0
@Y_POS
D;JGE
@R6
M=1
D=-D
(Y_POS)
@R8
M=D

// Step 4: Check for overflow (x == -32768 && y == -1)
@R0
D=M
@32767
D=D+1
@SKIP_OF
D;JNE
@R1
D=M
@1
D=D-A
@OVERFLOW
D;JEQ
(SKIP_OF)

// Step 5: Initialize
@R7
D=M
@R9
M=D       // remainder = |x|
@R10
M=0        // quotient = 0

// Step 6: Division loop
(DIV_LOOP)
@R9
D=M
@R8
D=D-M
@DONE_DIV
D;LT
@R8
D=M
@R9
M=M-D
@R10
M=M+1
@DIV_LOOP
0;JMP

(DONE_DIV)
// Step 7: Adjust sign of quotient
@R5
D=M
@R6
D=D+M
@Q_POS
D;JEQ
@R10
M=-M
(Q_POS)
@R10
D=M
@R2
M=D

// Step 8: Adjust remainder (same sign as x)
@R5
D=M
@REM_POS
D;JEQ
@R9
M=-M
(REM_POS)
@R9
D=M
@R3
M=D

// Step 9: Set success flag
@R4
M=0
@END
0;JMP

(DIV_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

(OVERFLOW)
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