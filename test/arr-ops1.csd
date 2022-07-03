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

#include "../utils.orc"

instr 1
kQ[] init 7, 3
kQ = 2
printarray kQ
endin

instr 2
kQ[] init 7, 3
kQ = ScalarSet(kQ, 3)
printarray kQ
endin
</CsInstruments>
<CsScore>
;i1 0 0.01
i2 0 0.01
e
</CsScore>
</CsoundSynthesizer>


