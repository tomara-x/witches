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

instr 1
ift0 ftgenonce 0, 0, 8, -2, 0,1,2,3,4,5,6,7,8 ;8 points long (power of 2)
ift1 ftgenonce 0, 0,-9, -2, 0,1,2,3,4,5,6,7,8 ;9 points long (negative size)
ift2 ftgenonce 0, 0, 9, -2, 0,1,2,3,4,5,6,7,8 ;8 points long (power of 2 + 1 as guard point)
print(ftlen(ift0), ftlen(ift1), ftlen(ift2))
endin
</CsInstruments>
<CsScore>
i1 0 0.1
e
</CsScore>
</CsoundSynthesizer>


