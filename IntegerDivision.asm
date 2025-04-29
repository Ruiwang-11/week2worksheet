// Check if divisor (R1) is zero
@R1
D=M
@ERR
D;JEQ           // If y == 0, division invalid

// Create working copies of x and y
@R0
D=M
@R6
M=D             // Copy of x (dividend)

@R1
D=M
@R7
M=D             // Copy of y (divisor)

@R8
M=0             // Initialize quotient (count)

(CHECK_LOOP)
@R6
D=M
@R7
D=D-M
@FINISH
D;LT            // If x < y, done dividing

// Subtract y from x
@R6
M=M
@R7
D=M
@R6
M=M-D           // x = x - y

// Increase quotient
@R8
M=M+1
@CHECK_LOOP
0;JMP

(FINISH)
// Set quotient result
@R8
D=M
@R2
M=D

// Set remainder result
@R6
D=M
@R3
M=D

// Division is valid
@R4
M=0
@HALT
0;JMP

(ERR)
// If invalid (y == 0), set flag and zero outputs
@R2
M=0
@R3
M=0
@R4
M=1

(HALT)
// End of program
@HALT
0;JMP
