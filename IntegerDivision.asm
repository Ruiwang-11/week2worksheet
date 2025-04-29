// ------------------------
// Step 1: Handle y == 0
@R1
D=M
@DIV_ZERO
D;JEQ        // If y == 0, division invalid

// ------------------------
// Step 2: Store x, y signs in R5, R6
@R0
D=M
@X_NEG
D;JLT
@R5
M=0          // R5 = 0 => x >= 0
@X_DONE
0;JMP
(X_NEG)
@R5
M=1          // R5 = 1 => x < 0
(X_DONE)

@R1
D=M
@Y_NEG
D;JLT
@R6
M=0          // R6 = 0 => y >= 0
@Y_DONE
0;JMP
(Y_NEG)
@R6
M=1          // R6 = 1 => y < 0
(Y_DONE)

// ------------------------
// Step 3: Get abs(x) -> R7, abs(y) -> R8
@R0
D=M
@ABSX_POS
D;JGE
D=-D
(ABSX_POS)
@R7
M=D          // R7 = |x|

@R1
D=M
@ABSY_POS
D;JGE
D=-D
(ABSY_POS)
@R8
M=D          // R8 = |y|

// ------------------------
// Step 4: Division Loop
@R7
D=M
@R9
M=D          // R9 = remainder (initially = |x|)

@R10
M=0          // R10 = quotient = 0

(DIV_LOOP)
@R9
D=M
@R8
D=D-M
@DIV_DONE
D;LT         // If remainder < y, done

@R8
D=M
@R9
M=M-D        // R9 -= y

@R10
M=M+1        // quotient++

@DIV_LOOP
0;JMP

(DIV_DONE)
// R10 = |quotient|
// R9 = |remainder|

// ------------------------
// Step 5: Set quotient sign
@R5
D=M
@R11
M=D          // R11 = sign of x

// if x_sign != y_sign then quotient = -quotient
@R5
D=M
@R6
D=D-M
@POS_QUOTIENT
D;JEQ        // if signs equal, leave quotient positive

@R10
D=M
D=-D
@R2
M=D
@REM_SIGN
0;JMP

(POS_QUOTIENT)
@R10
D=M
@R2
M=D

// ------------------------
// Step 6: Set remainder sign same as x
(REM_SIGN)
@R5
D=M
@REM_POS
D;JEQ

@R9
D=M
D=-D
@R3
M=D
@SET_VALID
0;JMP

(REM_POS)
@R9
D=M
@R3
M=D

// ------------------------
// Step 7: Set flag = 0 (valid)
(SET_VALID)
@R4
M=0
@END
0;JMP

// ------------------------
// Step 8: Division by zero
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
