// Load x from R0
@R0
D=M          // D = x

// Store original x into R1 as a default
@R1
M=D          // R1 = x (may be updated later)

// Check if x == -32768 (most negative number: 1000000000000000)
@R0
D=M
@NEG_LIMIT
D=D-A        // D = x - (-32768)
@CANNOT_COMPUTE
D;JEQ        // If x == -32768, jump to handle special case

// Check if x is negative (i.e., if the sign bit is 1)
@R0
D=M
@POSITIVE
D;JGE        // If x >= 0, jump (no change needed)

// x is negative and != -32768, compute -x
@R0
D=M
D=-D         // D = -x
@R1
M=D          // R1 = |x|

// Set R2 = 1 (was negative)
@R2
M=1
// Set R3 = 0 (abs was computable)
@R3
M=0
@END
0;JMP

// Label: x >= 0
(POSITIVE)
@R2
M=0          // R2 = 0 (not negative)
@R3
M=0          // R3 = 0 (computable)
@END
0;JMP

// Label: x == -32768, cannot compute absolute value
(CANNOT_COMPUTE)
@R1
@R0
M=M          // R1 = R0 (unchanged)
@R2
M=1          // R2 = 1 (was negative)
@R3
M=1          // R3 = 1 (not computable)

// Label: end of program
(END)
@END
0;JMP

// Constant: -32768 = 0b1000000000000000 = -32768
(NEG_LIMIT)
@32768
D=A
D=-D         // D = -32768
