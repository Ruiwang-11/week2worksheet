// Check if divisor (y = R1) == 0
@R1
D=M
@DIV_BY_ZERO
D;JEQ        // If y == 0, jump to error handling

// Initialize registers
@R0
D=M
@R5
M=D          // R5 = x (dividend), working copy

@R1
D=M
@R6
M=D          // R6 = y (divisor), working copy

@R2
M=0          // R2 = m = quotient = 0

// Loop: while R5 >= R6
(LOOP)
@R5
D=M
@R6
D=D-M        // D = R5 - R6
@DONE
D;LT         // If R5 < R6, done

// R5 = R5 - R6
@R5
M=M
@R6
D=M
@R5
M=M-D        // R5 -= R6

// R2++
@R2
M=M+1

@LOOP
0;JMP

(DONE)
// R3 = R5 (remainder)
@R5
D=M
@R3
M=D

// R4 = 0 (valid)
@R4
M=0
@END
0;JMP

(DIV_BY_ZERO)
// R2, R3 can be set to 0
@R2
M=0
@R3
M=0
@R4
M=1         // R4 = 1 (invalid division)

(END)
// End infinite loop
@END
0;JMP
