// IntegerDivision.asm

// Check if divisor (R1) is zero
@R1
D=M
@INVALID
D;JEQ

// Valid division, proceed
@VALID
0;JMP

(INVALID)
@R4
M=1         // Set invalid flag
@END
0;JMP

(VALID)
@R4
M=0         // Clear invalid flag

// Save R0 and R1 to temporary registers R5 and R6
@R0
D=M
@R5
M=D
@R1
D=M
@R6
M=D

// Compute x_sign (sign of R0)
@R5
D=M
@X_NEG
D;JLT       // Jump if R5 (x) is negative
@x_sign
M=0         // x is positive
@X_SIGN_DONE
0;JMP
(X_NEG)
@x_sign
M=1         // x is negative
(X_SIGN_DONE)

// Compute y_sign (sign of R1)
@R6
D=M
@Y_NEG
D;JLT       // Jump if R6 (y) is negative
@y_sign
M=0         // y is positive
@Y_SIGN_DONE
0;JMP
(Y_NEG)
@y_sign
M=1         // y is negative
(Y_SIGN_DONE)

// Compute absolute value of x (R5)
@R5
D=M
@x_abs
M=D         // Assume positive
@x_sign
D=M
@X_ABS_DONE
D;JEQ       // If x is positive, done
@R5
D=M
@x_abs
M=-D        // Negate if x was negative
(X_ABS_DONE)

// Compute absolute value of y (R6)
@R6
D=M
@y_abs
M=D         // Assume positive
@y_sign
D=M
@Y_ABS_DONE
D;JEQ       // If y is positive, done
@R6
D=M
@y_abs
M=-D        // Negate if y was negative
(Y_ABS_DONE)

// Perform unsigned division (x_abs / y_abs)
@x_abs
D=M
@remainder
M=D         // Initialize remainder to x_abs
@quotient
M=0         // Initialize quotient to 0

(DIV_LOOP)
@y_abs
D=M
@remainder
D=M-D       // D = remainder - y_abs
@END_DIV_LOOP
D;JLT       // Exit loop if remainder < y_abs

// Subtract y_abs from remainder and increment quotient
@y_abs
D=M
@remainder
M=M-D
@quotient
M=M+1
@DIV_LOOP
0;JMP

(END_DIV_LOOP)

// Determine quotient's sign
@x_sign
D=M
@y_sign
D=D-M
@SAME_SIGN
D;JEQ       // If signs are the same, quotient is positive

// Signs differ, quotient is negative
@quotient
D=M
@R2
M=-D
@SIGN_DONE
0;JMP

(SAME_SIGN)
@quotient
D=M
@R2
M=D         // Quotient is positive
(SIGN_DONE)

// Determine remainder's sign based on x's sign
@x_sign
D=M
@MAKE_NEG
D;JNE       // If x was negative, negate remainder

// Remainder is positive
@remainder
D=M
@R3
M=D
@REMAINDER_DONE
0;JMP

(MAKE_NEG)
@remainder
D=M
@R3
M=-D        // Remainder is negative
(REMAINDER_DONE)

(END)
@END
0;JMP