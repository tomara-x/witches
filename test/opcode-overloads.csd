//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

opcode Sum, ii, iiii
i1, i2, i3, i4 xin
xout i1+i2, i3+i4
endop

opcode Sum, i, iiii
i1, i2, i3, i4 xin
ix, iy Sum i1, i2, i3, i4
xout ix
endop

opcode Sum, i, ii
i1, i2 xin
ix, iy Sum i1, i2, 0, 0
xout ix
endop

instr Main
ix Sum 3, 4, 3, 2
print ix
iy, iz Sum 3, 4, 3, 2
print iy, iz
ij, ik Sum 3, 9 ;aaaaaah!
print ij
endin
schedule("Main", 0, 1)

</CsInstruments>
</CsoundSynthesizer>


