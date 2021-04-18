Author: Samidh Mehta.

Contains the Floating Point 32 and Fixed Point 18*19, 27*27 modes in Stratix 10.

Mode: 
00-> 18*19 fixed point
01-> 27*27 fixed point
1X-> Floating Point 32


| mode |   | Negate   | LoadConst | Sub      | mux9_select | Accumulate  | internal_coeffa | internal_coeffb | resulta                               | resultb          | chainout |
|------|---|----------|-----------|----------|-------------|-------------|-----------------|-----------------|---------------------------------------|------------------|----------|
| 0    | 0 | 0        | 0         | 0/1      | 1           | 0           | 0               | 0               | (ay+az) * ax +/- (by+bz) * bx         | 0                | resulta  |
|      |   | 0        | 0         | 0/1      | 1           | 0           | 1               | 0               | (ay+az) * coeffa +/- (by+bz) * bx     | 0                | resulta  |
|      |   | 0        | 0         | 0/1      | 1           | 0           | 0               | 1               | (ay+az) * ax +/- (by+bz) * coeffb     | 0                | resulta  |
|      |   | 0        | 0         | 0/1      | 1           | 0           | 1               | 1               | (ay+az) * coeffa +/- (by+bz) * coeffb | 0                | resulta  |
|      |   | 0        | 0         | 0/1      | 0           | 0           | 0               | 0               | ay+az) * ax                           |  (by+bz) * bx    | resulta  |
|      |   | 0        | 0         | 0/1      | 0           | 0           | 1               | 0               | (ay+az) * coeffa                      |  (by+bz) * bx    | resulta  |
|      |   | 0        | 0         | 0/1      | 0           | 0           | 0               | 1               | ay+az) * ax                           | (by+bz) * coeffb | resulta  |
|      |   | 0        | 0         | 0/1      | 0           | 0           | 1               | 1               | (ay+az) * coeffa                      | (by+bz) * coeffb | resulta  |
|      |   | 0        | 1         | X        | 1           | 0           | X               | X               | constant                              | 0                | resulta  |
|      |   | 0        | X         | 0/1      | 1           | 1           | 0/1             | 0/1             | current result+ previous result       | 0                | resulta  |
|      |   | 1        | X         | 0/1      | 1           | 1           | 0/1             | 0/1             | ~ current result + previous result    | 0                | resulta  |
|      |   | 1        | 0         | 0/1      | 1           | 0           | 0/1             | 0/1             | ~ current result + chainin            | 0                | resulta  |
| 0    | 1 | 0        | 0         | X        | 1           | 0           | 0               | X               | (ay+az)*ax                            | 0                | resulta  |
|      |   | 0        | 0         | X        | 1           | 0           | 1               | X               | (ay+az)*coeff                         | 0                | resulta  |
|      |   | 0        | 1         | X        | 1           | 0           | X               | X               | constant                              | 0                | resulta  |
|      |   | 0        | X         | X        | 1           | 1           | 0/1             | X               | current result+ previous result       | 0                | resulta  |
|      |   | 1        | X         | X        | 1           | 1           | 0/1             | X               | ~ current result + previous result    | 0                | resulta  |
|      |   | 1        | 0         | X        | 1           | 0           | 0/1             | X               | ~ current result + chainin            | 0                | resulta  |
| 1    | 1 | Funct[3] | Funct[2]  | Funct[1] | Funct[0]    | Accumulate  |                 |                 |                                       |                  |          |
|      |   | 0        | 0         | 0        | 0           | 0           |                 |                 | ay*az                                 | 0                | resulta  |
|      |   | 0        | 0         | 0        | 1           | 0           |                 |                 | Ay + ax                               | 0                | resulta  |
|      |   | 0        | 0         | 1        | 0           | 0           |                 |                 | Ay – ax                               | 0                | resulta  |
|      |   | 0        | 0         | 1        | 1           | 1           |                 |                 | ay * az + previous value              | 0                | resulta  |
|      |   | 0        | 1         | 0        | 0           | 1           |                 |                 | ay * az - previous value              | 0                | resulta  |
|      |   | 0        | 1         | 0        | 1           | 0           |                 |                 | (ay*az) + ax                          | 0                | resulta  |
|      |   | 0        | 1         | 1        | 0           | 0           |                 |                 | (ay*az) + chainin                     | 0                | resulta  |
|      |   | 0        | 1         | 1        | 1           | 0           |                 |                 | ay*az                                 | 0                | ax       |
|      |   | 1        | 0         | 0        | 0           | 0           |                 |                 | (ay*az) + chainin                     | 0                | ax       |
|      |   | 1        | 0         | 0        | 1           | 0           |                 |                 | (ay*az) -  chainin                    | 0                | ax       |
|      |   | 1        | 0         | 1        | 0           | 0           |                 |                 | ax                                    | 0                | resulta  |
|      |   | 1        | 0         | 1        | 1           | 0           |                 |                 | ax + chainin                          | 0                | resulta  |
