//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//instrumental taphy
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
iLen    init 8
kStep   init -1
kTrig   metro 4
iScale  ftgenonce 0,0,-7*3,-51, 7,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
kNote[] fillarray 0,1,2,3,14,15,16,17
kFrq    table kNote[kStep], iScale
kStep   wrap kStep+kTrig, 0, iLen
if kTrig == 1 && kStep == 2 then
    kNote[4] = wrap(kNote[4]+2, 0, 14)
    printarray kNote
endif

asig oscil 0.5, kFrq
sbus_write 0, asig
;out
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM

outs aL, aR

endin
schedule("Main", 0, 40)

</CsInstruments>
</CsoundSynthesizer>


