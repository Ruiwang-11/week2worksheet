// === IntegerDivision.asm ===
// RAM Usage:
// R0 = dividend (x)
// R1 = divisor (y)
// R2 = quotient (m)
// R3 = remainder (q)
// R4 = error flag (1=invalid, 0=valid)
// R13 = sign_x (0=pos,1=neg)
// R14 = sign_y (0=pos,1=neg)
// R15 = abs(x)
// R12 = abs(y)
// R10 = remainder (working)
// R11 = quotient (working)

// --- Step 1: Check y == 0
@R1
D=M
@ERROR_CASE
D;JEQ

// --- Step 2: Get sign and abs of x
@R0
D=M
@R13
M=0
@X_NOT_NEG
D;JGE
@R13
M=1
D=-D
(X_NOT_NEG)
@R15
M=D     // abs(x)

// --- Step 3: Get sign and abs of y
@R1
D=M
@R14
M=0
@Y_NOT_NEG
D;JGE
@R14
M=1
D=-D
(Y_NOT_NEG)
@R12
M=D     // abs(y)

// --- Step 4: Check for overflow: x == -32768 && y == -1
@R0
D=M
@32767
D=D+1
@NO_OVERFLOW
D;JNE
@R1
D=M
@1
D=D-A
@ERROR_CASE
D;JEQ
(NO_OVERFLOW)

// --- Step 5: Init loop
@R15
D=M
@R10
M=D     // remainder = abs(x)
@R11
M=0     // quotient = 0

(DIV_LOOP)
@R10
D=M
@R12
D=D-M
@DIV_DONE
D;LT
@R12
D=M
@R10
M=M-D
@R11
M=M+1
@DIV_LOOP
0;JMP

(DIV_DONE)
// --- Step 6: Apply sign to quotient
@R13
D=M
@R14
D=D+M
@Q_SIGN_OK
D;JEQ
@R11
M=-M
(Q_SIGN_OK)
@R11
D=M
@R2
M=D

// --- Step 7: Apply sign to remainder (same as x)
@R13
D=M
@REM_SIGN_OK
D;JEQ
@R10
M=-M
(REM_SIGN_OK)
@R10
D=M
@R3
M=D

// --- Step 8: Success
@R4
M=0
@END
0;JMP

// --- Step 9: Error handler (div by 0 or overflow)
(ERROR_CASE)
@R2
M=0
@R3
M=0
@R4
M=1

(END)
@END
0;JMP
