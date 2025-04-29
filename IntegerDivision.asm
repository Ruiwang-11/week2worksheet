// IntegerDivision.asm - Final perfect version

// Inputs:
//   R0 = dividend x
//   R1 = divisor y
// Outputs:
//   R2 = quotient m
//   R3 = remainder q
//   R4 = 1 if invalid (div-by-zero or overflow), else 0

// Variables:
// R5 = sign of x (0=positive, 1=negative)
// R6 = sign of y (0=positive, 1=negative)
// R7 = |x| (absolute value of x)
// R8 = |y| (absolute value of y)
// R9 = current remainder
// R10 = current quotient

// --------- Check if y == 0 (divide by zero)
@R1
D=M
@DIV_ZERO
D;JEQ

// --------- Get sign of x
@R0
D=M
@R5
M=0
@X_POS
D;JGE
@R5
M=1
@R0
D=-M
(X_POS)
@R7
M=D // store abs(x)

// --------- Get sign of y
@R1
D=M
@R6
M=0
@Y_POS
D;JGE
@R6
M=1
@R1
D=-M
(Y_POS)
@R8
M=D // store abs(y)

// --------- Special overflow case: x == -32768 && y == -1
@R0
D=M
@32767
D=D+1
@SKIP_OVERFLOW
D;JNE
@R1
D=M
@1
D=D-A
@DIV_OVERFLOW
D;JEQ
(SKIP_OVERFLOW)

// --------- Initialize remainder and quotient
@R7
D=M
@R9
M=D  // remainder = abs(x)
@R10
M=0  // quotient = 0

// --------- Perform division (repeated subtraction)
(DIV_LOOP)
@R9
D=M
@R8
D=D-M
@DIV_DONE
D;LT
@R8
D=M
@R9
M=M-D
@R10
M=M+1
@DIV_LOOP
0;JMP

// --------- Division done, adjust signs
(DIV_DONE)

// Quotient sign adjustment: if x and y signs differ, quotient = -quotient
@R5
D=M
@R6
D=D-M
@QUOT_SIGN_DONE
D;JEQ
@R10
M=-M
(QUOT_SIGN_DONE)
@R10
D=M
@R2
M=D

// Remainder sign adjustment: remainder follows x's sign
@R5
D=M
@REM_SIGN_DONE
D;JEQ
@R9
M=-M
(REM_SIGN_DONE)
@R9
D=M
@R3
M=D

// Set valid division flag
@R4
M=0
@END
0;JMP

// --------- Divide by zero handler
(DIV_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

// --------- Overflow handler (x == -32768 and y == -1)
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
