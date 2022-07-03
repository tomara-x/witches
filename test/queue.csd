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
ksmps   =   4410
nchnls  =   1
0dbfs   =   1

#include "../sequencers2.orc"

instr taphy
iFT ftgenonce 0,0, 32, -7, 0, 32, 32 ;0 to 32
kNotes[] fillarray 7, 0, 2, 6, 2, 3, 5, 4
kQ[]     fillarray 0, 0, 0, 0, 0, 0, 0, 0
kS, kP[], kT[] Taphy 1, kNotes, kQ, iFT
kQ[kS] = 0
if kT[3] == 1 then
    kQ[2] = 1
endif
if kT[2] == 1 then
    kQ[5] = 1
    kQ[3] = 1
endif
printk2 kS
endin
</CsInstruments>
<CsScore>
i1 0 1
e
</CsScore>
</CsoundSynthesizer>

