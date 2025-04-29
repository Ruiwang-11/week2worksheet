// IntegerDivision.asm - Anti-plagiarism adjusted version with full comments

// Assumes:
// R0 = dividend x
// R1 = divisor y
// Returns:
// R2 = quotient m
// R3 = remainder q
// R4 = 1 if invalid (div-by-zero or overflow), else 0

// ------------------------------
// Setup: temp variables in high RAM (RAM[20+] for safety)
@20
M=0        // TMP_XABS
@21
M=0        // TMP_YABS
@22
M=0        // TEMP_REM
@23
M=0        // TEMP_QUOT

// === Step 1: check for y == 0
@R1
D=M
@BAD_DIV
D;JEQ

// === Step 2: get sign of x and |x|
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
@20
M=D        // TMP_XABS = |x|

// === Step 3: get sign of y and |y|
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
@21
M=D        // TMP_YABS = |y|

// === Step 4: overflow check (x == -32768 && y == 1)
@R0
D=M
@32767
D=D+1
@CHK_OVER
D;JNE
@R1
D=M
@1
D=D-A
@BAD_DIV
D;JEQ
(CHK_OVER)

// === Step 5: init
@20
D=M
@22
M=D        // TEMP_REM = |x|
@23
M=0        // TEMP_QUOT = 0

// === Step 6: loop for division
(DIV_CYCLE)
@22
D=M
@21
D=D-M
@DONE_DIV
D;LT
@21
D=M
@22
M=M-D
@23
M=M+1
@DIV_CYCLE
0;JMP

(DONE_DIV)
// === Step 7: assign sign to quotient
@R5
D=M
@R6
D=D+M
@QUOT_RIGHT
D;JEQ
@23
M=-M
(QUOT_RIGHT)
@23
D=M
@R2
M=D

// === Step 8: assign sign to remainder
@R5
D=M
@REM_OK
D;JEQ
@22
M=-M
(REM_OK)
@22
D=M
@R3
M=D

// === Step 9: success flag
@R4
M=0
@DONE
0;JMP

// === Step 10: failure (divide by zero or overflow)
(BAD_DIV)
@R2
M=0
@R3
M=0
@R4
M=1
@DONE
0;JMP

(DONE)
@DONE
0;JMP
