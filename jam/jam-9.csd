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

#include "../sequencers.orc"

instr Tweet
iScale ftgenonce 0,0,-7*4,-51, 7,2,cpspch(8),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
ktrig   metro 4
knote[] fillarray 0, 0, 0, 0, 0, 0, 0, 0
kgain[] fillarray 0, 1, 2, 3, 4, 5, 6, 7
kQ[]    fillarray 0, 0, 0, 0, 0, 0, 0, 0
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, iScale
kcps = kp[kAS]
klfo1   lfo 600, 5+kcps/256
klfo2   lfo 300, kcps/256
asig    poscil 1, kcps+klfo1
aout    rbjeq asig, 40+kcps+klfo2, 4, 8, 1, 4
aout    = aout * 0.1
outs    aout, aout
endin

</CsInstruments>
<CsScore>
i"Tweet" 0 120
e
</CsScore>
</CsoundSynthesizer>

