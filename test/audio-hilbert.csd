//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #60#
#include "../mixer.orc"

instr Main
aSig soundin "../28.11.21.wav", 53
iSine ftgen 0, 0, 2^10, 10, 1
aSin poscil 1, 100, iSine, 0
aCos poscil 1, 100, iSine, 0.25
aReal, aImag hilbert aSig

sbus_write 0, (aReal*aCos) - (aImag*aSin)

;out
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM
outs aL, aR
endin
schedule("Main", 0, 120)

</CsInstruments>
</CsoundSynthesizer>


