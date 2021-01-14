Int8 version- Stratix 10
Author: Samidh Mehta
Date: 23rd June, 2020

All registers are positive edge triggered.
These registers are not reset after power up and may hold unwanted data.
Assert the CLR signal to clear the registers before starting an operation.
Each multiplier operand can feed an input register or a multiplier directly, bypassing the input registers.

There are 2 columns of pipeline registers for fixed-point arithmetic.
Pipeline registers are used to get the maximum Fmax performance. 
The pipeline registers can be bypassed if high Fmax is not needed.

For the int mode, two preadders are used. They share the same operation type (add/ sub). We have added two other modes (simple and input)
We have two multipliers available.
Use the dynamic SUB port to select the adder to perform addition or subtraction operation.

NEGATE, LOADCONST, ACCUMULATE are used to control the functions of the accumulator

| Function                 | Loadconst | Accumulate | Negate |
|--------------------------|-----------|------------|--------|
| Zeroing                  |     0     |      0     | 0      |
| Preload                  |     1     |      0     | 0      |
| Accumulation             |     X     |      1     | 0      |
| Decimation+ Accumulation |     X     |      1     | 1      |
| Decimation+ Chainout     |     0     |      0     | 1      |



| LoadConst | Accumulate | Negate | Funct | Resulta                                       | Resultb |
|-----------|------------|--------|-------|-----------------------------------------------|---------|
| 0         | 0          | 0      | 2’b00 | ay*ax                                         | by*bx   |
|           |            |        | 2’b10 | 0                                             | 0       |
|           |            |        | 2’b11 | 0                                             | 0       |
| 0         | 0          | 1      | 2’b00 | ay*ax                                         | by*bx   |
|           |            |        | 2’b10 | ~[(bx * by) +/- (ax * ay)] + chainin          | 0       |
|           |            |        | 2’b11 | ~[(ax * ay) +/- by] + chainin                 | 0       |
| X         | 1          | 0      | 2’b00 | ay*ax                                         | by*bx   |
|           |            |        | 2’b10 | [(bx * by) +/- (ax * ay)] + previous_resulta  | 0       |
|           |            |        | 2’b11 | [(ax * ay) +/- by] + previous_resulta         | 0       |
| X         | 1          | 1      | 2’b00 | ay*ax                                         | by*bx   |
|           |            |        | 2’b10 | ~[(bx * by) +/- (ax * ay)] + previous_resulta | 0       |
|           |            |        | 2’b11 | ~[(ax * ay) +/- by] + previous_resulta        | 0       |
| 1         | 0          | 0      | 2’b00 | ay*ax                                         | by*bx   |
|           |            |        | 2’b10 | preload                                       | preload |
|           |            |        | 2’b11 | preload                                       | preload |

The accumulator supports double accumulation by enabling the 64-bit double accumulation registers  located between the output register bank and the accumulator feedback path.

If the double accumulation register is enabled, an extra clock cycle delay is added into the feedback path of the accumulator.