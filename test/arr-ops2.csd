//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;shift registers test
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
kQ[] fillarray 2, 4, 5, 6
printarray kQ
kQ = ShiftR(1, 0, kQ)
endin

instr 2
kQ[] fillarray 2, 4, 5, 6
printarray kQ
kQ = ShiftL(1, 0, kQ)
endin

</CsInstruments>
<CsScore>
i1 0 0.1
i2 1 0.1
e
</CsScore>
</CsoundSynthesizer>


