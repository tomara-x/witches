//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//don't know if this is better than osc with letency, i didn't finish
//researching this
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   100
nchnls  =   2
0dbfs   =   1

#include "../mixer.orc"

instr Main
aSig sockrecv 7777, 200

sbus_write 0, aSig

;out
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM

outs aL, aR
endin
</CsInstruments>
<CsScore>
i"Main" 0 120
e
</CsScore>
</CsoundSynthesizer>


