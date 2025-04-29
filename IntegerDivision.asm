// Step 1: Check if divisor y == 0
@R1
D=M
@DIV_ZERO
D;JEQ

// Step 2: Store |x| in R5 and sign of x in R10
@R0
D=M
@X_NEG
D;JLT
@R5
M=D       // R5 = x (x is positive)
@R10
M=0       // R10 = 0 => x >= 0
@X_DONE
0;JMP
(X_NEG)
D=-D
@R5
M=D       // R5 = |x|
@R10
M=1       // R10 = 1 => x < 0
(X_DONE)

// Step 3: Store |y| in R6 and sign of y in R11
@R1
D=M
@Y_NEG
D;JLT
@R6
M=D       // R6 = y (y is positive)
@R11
M=0       // R11 = 0 => y >= 0
@Y_DONE
0;JMP
(Y_NEG)
D=-D
@R6
M=D       // R6 = |y|
@R11
M=1       // R11 = 1 => y < 0
(Y_DONE)

// Step 4: Division Loop: R5 = |x|, R6 = |y|
@R5
D=M
@R7
M=D       // R7 = remaining = |x|
@R8
M=0       // R8 = quotient = 0

(LOOP)
@R7
D=M
@R6
D=D-M
@AFTER_LOOP
D;LT

// R7 = R7 - R6
@R6
D=M
@R7
M=M-D

// R8++
@R8
M=M+1
@LOOP
0;JMP

(AFTER_LOOP)
// Step 5: Set quotient sign
@R10
D=M
@R11
D=D+M
@QUOT_POS
D;JEQ     // if x and y have same sign, quotient is positive

@R8
D=M
D=-D
@R2
M=D
@SET_REM
0;JMP

(QUOT_POS)
@R8
D=M
@R2
M=D

// Step 6: Set remainder sign (same as x)
(SET_REM)
@R10
D=M
@REM_POS
D;JEQ

@R7
D=M
D=-D
@R3
M=D
@DONE
0;JMP

(REM_POS)
@R7
D=M
@R3
M=D

(DONE)
@R4
M=0     // valid
@END
0;JMP

// Step 7: Division by zero
(DIV_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1

(END)
@END
0;JMP
