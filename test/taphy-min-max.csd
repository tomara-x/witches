//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//testing the range arrays (issue #34)
// - you wanna play here or go to the wrap opcode src? (Opcodes/uggab.c)
// - yes
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   4410
nchnls  =   1
0dbfs   =   1

#include "../sequencers.orc"

instr taphy
iFT ftgenonce 0,0, 32, -7, 0, 32, 32 ;0 to 32
kNotes[] fillarray 7, 0
kTrans[] fillarray 1, 1
kQ[]     fillarray 0, 0
kMin[]   fillarray 0, 0
kMax[]   fillarray 6, 8
kAS, kP[], kT[], kI[] Taphath 1, kNotes, kTrans, kQ, kMin, kMax, iFT
;printarray kI
printarray kP
endin
</CsInstruments>
<CsScore>
i1 0 4
e
</CsScore>
</CsoundSynthesizer>

