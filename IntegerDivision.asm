// IntegerDivision.asm - Shortened, anti-plagiarism version

// RAM 分配：
// R0=x, R1=y
// R2=quotient (m), R3=remainder (q)
// R4=error flag
// R5=x sign, R6=y sign
// R13=|x|, R14=|y|, R15=temp remainder, R12=temp quotient

@R1
D=M
@DIV_ZERO
D;JEQ

@R0
D=M
@R5
M=0
@X_OK
D;JGE
@R5
M=1
@R0
D=-M
(X_OK)
@R13
M=D   // |x|

@R1
D=M
@R6
M=0
@Y_OK
D;JGE
@R6
M=1
@R1
D=-M
(Y_OK)
@R14
M=D   // |y|

@R0
D=M
@32767
D=D+1
@CHK_OVF
D;JNE
@R1
D=M
@1
D=D-A
@DIV_OVERFLOW
D;JEQ
(CHK_OVF)

@R13
D=M
@R15
M=D
@R12
M=0

(DIV_LOOP)
@R15
D=M
@R14
D=D-M
@DIV_DONE
D;LT
@R14
D=M
@R15
M=M-D
@R12
M=M+1
@DIV_LOOP
0;JMP

(DIV_DONE)
@R5
D=M
@R6
D=D-M
@Q_SIGN
D;JEQ
@R12
M=-M
(Q_SIGN)
@R12
D=M
@R2
M=D

@R5
D=M
@R_REM
D;JEQ
@R15
M=-M
(R_REM)
@R15
D=M
@R3
M=D

@R4
M=0
@END
0;JMP

(DIV_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

(DIV_OVERFLOW)
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
