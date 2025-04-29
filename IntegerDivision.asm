// Step 1: Handle y == 0 (illegal division)
@R1
D=M
@DIV_ZERO
D;JEQ            // if y == 0, jump to error

// Step 2: Store sign of x in R5, |x| in R7
@R0
D=M
@R5
M=0              // R5 = 0 means x >= 0
@CHECK_X_POS
D;JGE
@R5
M=1              // R5 = 1 means x < 0
@R0
D=M
D=-D             // D = |x|
(CHECK_X_POS)
@R7
M=D              // R7 = abs(x)

// Step 3: Store sign of y in R6, |y| in R8
@R1
D=M
@R6
M=0              // R6 = 0 means y >= 0
@CHECK_Y_POS
D;JGE
@R6
M=1              // R6 = 1 means y < 0
@R1
D=M
D=-D             // D = |y|
(CHECK_Y_POS)
@R8
M=D              // R8 = abs(y)

// Step 4: Handle x = -32768 and y = -1 (overflow case)
@R0
D=M
@NEG32768
D=D+A            // D = x + 32768
@SKIP_OF_CHECK
D;JNE
@R1
D=M
@MINUS_ONE
D=D+1            // D = y + 1, if 0 => y == -1
@DIV_OVERFLOW
D;JEQ
(SKIP_OF_CHECK)

// Step 5: Initialize division
@R7
D=M
@REM
M=D              // Remainder = |x|
@R2
M=0              // Quotient = 0

(DIV_LOOP)
@REM
D=M
@R8
D=D-M            // if remainder < divisor, stop
@AFTER_DIV
D;LT
@REM
M=M-D            // REM = REM - divisor
@R2
M=M+1            // quotient++
@DIV_LOOP
0;JMP

(AFTER_DIV)
// Step 6: Apply correct sign to quotient
@R5
D=M
@R6
D=D+M
@POS_QUOT
D;JEQ
@R2
M=-M             // negate quotient if signs differ
(POS_QUOT)

// Step 7: Apply sign to remainder (same as x)
@R5
D=M
@SKIP_NEG_REM
D;JEQ
@REM
M=-M
(SKIP_NEG_REM)

// Step 8: Store final remainder and valid flag
@REM
D=M
@R3
M=D              // R3 = remainder
@R4
M=0              // R4 = 0 => valid division
@END
0;JMP

// Division by zero handler
(DIV_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

// Overflow case: x = -32768, y = -1
(DIV_OVERFLOW)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

// Program end loop
(END)
@END
0;JMP

// Constant labels (helpful for overflow detection)
(NEG32768)
@32768
D=A
D=-D
@R0
D=D+M            // x + 32768

(MINUS_ONE)
@1
D=-A             // D = -1
