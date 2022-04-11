//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//test file
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 42
nchnls = 2
0dbfs = 1

#include "../sequencers.orc"

instr Main
kTrig   metro 120*15/60
iCnt[]  fillarray 1, 1/3, 1/3, 1/3, 1, 1/5, 1/5, 1/5, 1/5, 1/5
kCnt[] = iCnt * 15
kAS, kT[] utBasemath kTrig, kCnt

schedkwhen kT[kAS], 0,0, "Beep", 0, 0.05, 440*2^3
schedkwhen kT[0], 0,0, "Beep", 0, 0.05, 440*2^2
endin

instr Beep
aSig = oscil(0.4, p4)
outs aSig, aSig
endin

;schedule(-nstrnum("Main"), 0, 1)
;schedule("Main", 0, -1)
;turnoff2(nstrnum("Main"), 0, 0)
;schedulek("Main", 0, -1)

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>

