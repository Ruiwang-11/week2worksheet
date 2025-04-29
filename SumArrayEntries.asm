// Check if array length (R1) is <= 0
@R1
D=M
@SET_ZERO
D;JLE       // If R1 <= 0, jump to set R2 = 0

// Initialize variables
@R0
D=M
@R3
M=D         // R3 = current address pointer (start of array)

@R1
D=M
@R4
M=D         // R4 = counter (number of elements remaining)

@R2
M=0         // R2 = sum accumulator = 0

(LOOP)
@R4
D=M
@END
D;JEQ       // If count == 0, done

@R3
A=M         // A = address of current array element
D=M         // D = value at array[i]
@R2
M=D+M       // R2 += D

// Advance address pointer
@R3
M=M+1       // R3 = R3 + 1 (next element)

// Decrease counter
@R4
M=M-1       // R4 = R4 - 1
@LOOP
0;JMP       // Repeat

(SET_ZERO)
@R2
M=0         // If length <= 0, sum = 0

(END)
@END
0;JMP       // Infinite loop to end program
