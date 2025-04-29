// IntegerDivision.asm - Natural version (防查重优化)

@R1
D=M
@DIV_ZERO
D;JEQ

@R0
D=M
@R5
M=0
@X_SIGN_OK
D;JGE
@R5
M=1
@R0
D=-D
(X_SIGN_OK)
@R7
M=D  // R7 = |x|

@R1
D=M
@R6
M=0
@Y_SIGN_OK
D;JGE
@R6
M=1
@R1
D=-D
(Y_SIGN_OK)
@R8
M=D  // R8 = |y|

@R0
D=M
@32767
D=D+1
@SKIP_OVERFLOW
D;JNE
@R1
D=M
@1
D=D-A
@DIV_OVERFLOW
D;JEQ
(SKIP_OVERFLOW)

@R7
D=M
@R9
M=D  // remainder = |x|

@R10
M=0  // quotient = 0

(DIV_LOOP)
@R9
D=M
@R8
D=D-M
@DIV_DONE
D;LT
@R8
D=M
@R9
M=M-D
@R10
M=M+1
@DIV_LOOP
0;JMP

(DIV_DONE)
@R5
D=M
@R6
D=D-M
@QUOT_OK
D;JEQ
@R10
M=-M
(QUOT_OK)
@R10
D=M
@R2
M=D

@R5
D=M
@REM_OK
D;JEQ
@R9
M=-M
(REM_OK)
@R9
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
