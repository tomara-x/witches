//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #256#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#
#include "../sequencers2.orc"
gay, gal, gar init 0

instr Seq1
kTrig    metro $FRQ*4
kCount[] fillarray 1, 1, 1, 1
kGain[]  fillarray 1, 3, 1, 2
iScale   ftgenonce 0,0,-7*3,-51, 7,2,cpspch(7),0,
1,2^(3/12),2^(4/12),2^(5/12),2^(6/12),2^(7/12),2^(10/12) ;7-tone blues
kNote[]  fillarray 6, 2, 9, 1
kTrans[] fillarray 1, 0, 0, 3
kQueue[] init 4

kBS, kBT[] Basma kTrig, kCount, 1, 4, kQueue
kTS, kTP[], kTT[] Taphy kBT[kBS], kNote, kQueue, iScale

kCount[kBS] = kCount[kBS] + kGain[kBS]*kBT[kBS]
kNote[kTS] = kNote[kTS] + kTrans[kTS]*kTT[kTS]

schedkwhen(kBT[kBS],0,0, "Bleep", 0, .1, -06, .5, kTP[kTS])
endin

instr Bleep
aEnv linseg 1, p3, 0
aS1  oscili aEnv^4, p6   +(1-aEnv)*lfo(100, 2)
aS2  oscili aEnv^4, p6*2 +(1-aEnv)*lfo(200, 4)
aS3  oscili aEnv^4, p6*3 +(1-aEnv)*lfo(150, 3)
aSig = (aS1+aS2+aS3)/3
aSig diode_ladder aSig, 8000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

gaVerbL,gaVerbR init 0
instr Verb
kRoomSize  init  0.85 ; room size (range 0 to 1)
kHFDamp    init  0.9  ; high freq. damping (range 0 to 1)
denorm gaVerbL, gaVerbR
aVerbL,aVerbR freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp
gal += aVerbL
gar += aVerbR
clear gaVerbL,gaVerbR
endin

instr Out
kSM = 1
gal limit gal+gay, -kSM, kSM
gar limit gar+gay, -kSM, kSM
outs gal, gar
clear gay, gal, gar
endin
</CsInstruments>
<CsScore>
i"Verb" 0 -1
t 0 256
i"Out"  0 [8*64]
i"Seq1" 0 [8*64]
</CsScore>
</CsoundSynthesizer>

