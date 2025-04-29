// IntegerDivision.asm - Final corrected version with annotations

// Input:
//   R0 = x (dividend)
//   R1 = y (divisor)
// Output:
//   R2 = m (quotient)
//   R3 = q (remainder)
//   R4 = 1 if invalid (divide by zero or overflow), else 0

// Variable address mapping:
@16    // ABS_R0
D=0
M=D
@17    // ABS_R1
D=0
M=D

// Step 1: Handle divide-by-zero
@R1
D=M
@DIVIDE_BY_ZERO
D;JEQ

// Step 2: Determine sign of x and take abs(x)
@R0
D=M
@R5
M=0              // R5 = 0 if x >= 0
@SKIP_R0_NEG
D;JGE
@R5
M=1              // R5 = 1 if x < 0
(SKIP_R0_NEG)
@R0
D=M
@16              // ABS_R0
M=D
@SKIP_R0_ABS
D;JGE
@16
M=-D             // ABS_R0 = -x if x < 0
(SKIP_R0_ABS)

// Step 3: Determine sign of y and take abs(y)
@R1
D=M
@R6
M=0              // R6 = 0 if y >= 0
@SKIP_R1_NEG
D;JGE
@R6
M=1              // R6 = 1 if y < 0
(SKIP_R1_NEG)
@R1
D=M
@17              // ABS_R1
M=D
@SKIP_R1_ABS
D;JGE
@17
M=-D             // ABS_R1 = -y if y < 0
(SKIP_R1_ABS)

// Step 4: Check for overflow: x == -32768 && y == 1
@R0
D=M
@32767
D=D+1            // if D == 0, then x == -32768
@CHECK_OVERFLOW
D;JEQ
@START_DIVISION
0;JMP

(CHECK_OVERFLOW)
@R1
D=M
@1
D=D-A
@OVERFLOW_ERROR
D;JEQ            // if y == 1, and x == -32768 → overflow

// Step 5: Start division
(START_DIVISION)
@16
D=M
@R3
M=D              // R3 = remainder
@R2
M=0              // R2 = quotient

// Step 6: Loop: while R3 >= ABS_R1
(LOOP)
@17
D=M
@R3
D=M-D
@END_LOOP
D;JLT            // if R3 < ABS_R1 → done

@17
D=M
@R3
M=M-D            // R3 -= ABS_R1

@R2
M=M+1            // R2 += 1
@LOOP
0;JMP

// Step 7: Adjust sign of quotient if signs differ
(END_LOOP)
@R5
D=M
@R6
D=D-M
@SET_NEGATIVE_QUOTIENT
D;JNE
@SET_REMAINDER_SIGN
0;JMP

(SET_NEGATIVE_QUOTIENT)
@R2
M=-M

// Step 8: Adjust remainder sign to match x
(SET_REMAINDER_SIGN)
@R5
D=M
@SKIP_REMAINDER_NEG
D;JEQ
@R3
M=-M
(SKIP_REMAINDER_NEG)

// Step 9: Set valid flag
@R4
M=0
@END
0;JMP

// Step 10: Divide by zero case
(DIVIDE_BY_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

// Step 11: Overflow case
(OVERFLOW_ERROR)
@R2
M=0
@R3
M=0
@R4
M=1
@END
0;JMP

// Infinite loop end
(END)
@END
0;JMP
