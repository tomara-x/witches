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

instr Main1
iArr[] = fillarray(13, 42, 69, 105)
kFlag init 0
if kFlag == 0 then
    kFlag = 1
    kArr[] = iArr
endif
kArr[3] = kArr[3] + 1
printarray(kArr)
endin

instr Main2
iArr[] = fillarray(13, 42, 69, 105)
kFlag init 0
kArr[] = iArr
kArr[3] = kArr[3] + 1
printarray(kArr)
endin

instr Main3
iArr[] = fillarray(13, 42, 69, 105)
if timeinstk() == 1 then
    kArr[] = iArr
endif
kArr[3] = kArr[3] + 1
printarray(kArr)
endin

</CsInstruments>
<CsScore>
i"Main3" 0 .1
e
</CsScore>
</CsoundSynthesizer>


