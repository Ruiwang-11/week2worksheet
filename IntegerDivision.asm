// === Division by zero check ===
@R1
D=M
@HANDLE_DIV_ZERO
D;JEQ        // If divisor is zero, invalid division

// === Determine sign of dividend (R0) and record in R5 ===
@R0
D=M
@R5
M=0
@SKIP_SIGN_R0
D;JGE
@R5
M=1         // R5 = 1 if x < 0
(SKIP_SIGN_R0)

// === Take absolute value of R0 and store in ABS_R0 ===
@R0
D=M
@ABS_R0
M=D
@SKIP_ABS_R0
D;JGE
@D
D=-D
@ABS_R0
M=D
(SKIP_ABS_R0)

// === Determine sign of divisor (R1) and record in R6 ===
@R1
D=M
@R6
M=0
@SKIP_SIGN_R1
D;JGE
@R6
M=1         // R6 = 1 if y < 0
(SKIP_SIGN_R1)

// === Take absolute value of R1 and store in ABS_R1 ===
@R1
D=M
@ABS_R1
M=D
@SKIP_ABS_R1
D;JGE
D=-D
@ABS_R1
M=D
(SKIP_ABS_R1)

// === Check overflow case: x == -32768 and y == 1 ===
@ABS_R0
D=M
@32768
D=D-A
@CHECK_EXACT_OVERFLOW
D;JEQ
@BEGIN_DIV
0;JMP

(CHECK_EXACT_OVERFLOW)
@ABS_R1
D=M
@ONE
M=1
D=D-M
@OVERFLOW_CASE
D;JEQ

// === Division logic ===
(BEGIN_DIV)
@ABS_R0
D=M
@R3
M=D           // R3 = remainder
@R2
M=0           // R2 = quotient

(DIV_LOOP)
@ABS_R1
D=M
@R3
D=M-D
@EXIT_DIV
D;LT
@ABS_R1
D=M
@R3
M=M-D
@R2
M=M+1
@DIV_LOOP
0;JMP

(EXIT_DIV)
// If signs of x and y differ, negate the quotient
@R5
D=M
@R6
D=D-M
@NEGATE_QUOT
D;JNE
@CHECK_REM_SIGN
0;JMP

(NEGATE_QUOT)
@R2
M=-M

(CHECK_REM_SIGN)
// If x < 0, negate remainder
@R5
D=M
@SKIP_REM_SIGN
D;JEQ
@R3
M=-M
(SKIP_REM_SIGN)

// Valid division flag
@R4
M=0
@END
0;JMP

// === Handle y == 0 (division by zero) ===
(HANDLE_DIV_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

// === Handle overflow x = -32768 and y = 1 ===
(OVERFLOW_CASE)
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
