// Check if divisor (R1) is zero (invalid division condition)
@R1
D=M
@INVALID
D;JEQ        // Jump to invalid handling if R1 is zero

// Proceed with valid division
@VALID
0;JMP

(INVALID)
@R4
M=1         // Set invalid flag R4=1
@END
0;JMP       // Terminate

(VALID)
@R4
M=0         // Clear invalid flag R4=0

// Backup original values to temporary registers (R5=R0, R6=R1)
@R0
D=M
@R5
M=D         // R5 stores original dividend x
@R1
D=M
@R6
M=D         // R6 stores original divisor y

// Determine sign of x (stored in x_sign: 0=positive, 1=negative)
@R5
D=M
@X_NEG
D;JLT       // Jump if x is negative
@x_sign
M=0         // x is positive
@X_SIGN_DONE
0;JMP
(X_NEG)
@x_sign
M=1         // x is negative
(X_SIGN_DONE)

// Determine sign of y (stored in y_sign: 0=positive, 1=negative)
@R6
D=M
@Y_NEG
D;JLT       // Jump if y is negative
@y_sign
M=0         // y is positive
@Y_SIGN_DONE
0;JMP
(Y_NEG)
@y_sign
M=1         // y is negative
(Y_SIGN_DONE)

// Compute absolute values for unsigned division
// |x| stored in x_abs
@R5
D=M
@x_abs
M=D         // Assume x is positive
@x_sign
D=M
@X_ABS_DONE
D;JEQ       // Skip negation if x is positive
@R5
D=M
@x_abs
M=-D        // Negate x if it was negative
(X_ABS_DONE)

// |y| stored in y_abs
@R6
D=M
@y_abs
M=D         // Assume y is positive
@y_sign
D=M
@Y_ABS_DONE
D;JEQ       // Skip negation if y is positive
@R6
D=M
@y_abs
M=-D        // Negate y if it was negative
(Y_ABS_DONE)

// Unsigned division loop: Repeated subtraction
@x_abs
D=M
@remainder
M=D         // Initialize remainder with |x|
@quotient
M=0         // Initialize quotient to 0

(DIV_LOOP)
@y_abs
D=M
@remainder
D=M-D       // Compute remainder - |y|
@END_DIV_LOOP
D;JLT       // Exit loop if remainder < |y|

// Subtract |y| from remainder and increment quotient
@y_abs
D=M
@remainder
M=M-D
@quotient
M=M+1
@DIV_LOOP
0;JMP

(END_DIV_LOOP)

// Determine quotient sign: Negative if x and y have different signs
@x_sign
D=M
@y_sign
D=D-M       // Compare x_sign and y_sign
@SAME_SIGN
D;JEQ       // Jump if signs are identical

// Different signs: Negate quotient
@quotient
D=M
@R2
M=-D        // Store negative quotient in R2
@SIGN_DONE
0;JMP

(SAME_SIGN)
// Same signs: Quotient remains positive
@quotient
D=M
@R2
M=D         // Store positive quotient in R2
(SIGN_DONE)

// Adjust remainder sign to match x's sign
@x_sign
D=M
@MAKE_NEG
D;JNE       // Jump if x was negative

// x is positive: Remainder stays positive
@remainder
D=M
@R3
M=D         // Store positive remainder in R3
@REMAINDER_DONE
0;JMP

(MAKE_NEG)
// x is negative: Negate remainder
@remainder
D=M
@R3
M=-D        // Store negative remainder in R3
(REMAINDER_DONE)

// Infinite loop to halt execution
(END)
@END
0;JMP