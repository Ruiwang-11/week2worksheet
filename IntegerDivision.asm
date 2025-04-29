// ---------------------------
// Check if y == 0
@R1
D=M
@DIV_BY_ZERO
D;JEQ          // If y == 0, jump to error

// ---------------------------
// Store signs of x and y
@R0
D=M
@X_NEG
D;JLT          // if x < 0, jump

@R5
M=0            // R5 = x_sign = 0 (non-negative)
@X_DONE
0;JMP
(X_NEG)
@R5
M=1            // R5 = x_sign = 1 (negative)
(X_DONE)

@R1
D=M
@Y_NEG
D;JLT          // if y < 0, jump

@R6
M=0            // R6 = y_sign = 0
@Y_DONE
0;JMP
(Y_NEG)
@R6
M=1            // R6 = y_sign = 1
(Y_DONE)

// ---------------------------
// Take absolute values of x and y, store in R7 (abs_x), R8 (abs_y)
@R0
D=M
@R5
D=D
@ABS_X
0;JMP
(ABS_X)
@R5
D=M
@R0
A=M
D=M
@ABSX_POS
D;JGE
@R0
D=M
D=-D
(ABSX_POS)
@R7
M=D         // R7 = |x|

@R1
D=M
@R6
D=D
@ABSY
0;JMP
(ABSY)
@R6
D=M
@R1
A=M
D=M
@ABSY_POS
D;JGE
@R1
D=M
D=-D
(ABSY_POS)
@R8
M=D         // R8 = |y|

// ---------------------------
// Now divide abs_x by abs_y
@R7
D=M
@R9
M=D         // R9 = current remainder

@R10
M=0         // R10 = quotient = 0

(DIV_LOOP)
@R9
D=M
@R8
D=D-M
@AFTER_DIV
D;LT        // while remainder >= divisor

// R9 = R9 - R8
@R8
D=M
@R9
M=M-D

// R10++
@R10
M=M+1
@DIV_LOOP
0;JMP

(AFTER_DIV)
// ---------------------------
// Restore quotient and remainder signs
// m = R10, q = R9

// If x_sign == 1, negate quotient and remainder
@R5
D=M
@SKIP_NEG_MQ
D;JEQ        // If x >= 0, skip

@R10
D=M
D=-D
@R2
M=D         // R2 = -quotient

@R9
D=M
D=-D
@R3
M=D         // R3 = -remainder
@FLAG
0;JMP

(SKIP_NEG_MQ)
@R10
D=M
@R2
M=D         // R2 = quotient

@R9
D=M
@R3
M=D         // R3 = remainder

(FLAG)
// ---------------------------
// Valid division
@R4
M=0
@END
0;JMP

(DIV_BY_ZERO)
// Set error flag and zero outputs
@R2
M=0
@R3
M=0
@R4
M=1

(END)
// End infinite loop
@END
0;JMP
