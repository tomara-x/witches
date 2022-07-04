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

#define TEMPO #128#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#
#include "../sequencers2.orc"
#include "../utils.orc"
gay, gal, gar init 0

instr Seq1
kTrig    metro $FRQ*4
kCount[] fillarray 1, 1, 1, 1, 1, 1, 1, 1
kGain[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0
iScale   ftgenonce 0,0,-7*3,-51, 7,2,cpspch(5),0,
1,2^(3/12),2^(4/12),2^(5/12),2^(6/12),2^(7/12),2^(10/12) ;7-tone blues
kNote[]  fillarray 6, 2, 9, 1, 0, 7, 0, 4
kTrans[] fillarray 0, 0, 0, 0, 0, 0, 0, 0
kQueue[] fillarray 0, 0, 0, 0, 0, 0, 0, 0

kBS, kBT[] Basma kTrig, kCount, 1, 4, kQueue
kTS, kTP[], kTT[] Taphy kBT[kBS], kNote, kQueue, iScale

kCount[kBS] = kCount[kBS] + kGain[kBS]*kBT[kBS]
kNote[kTS] = kNote[kTS] + kTrans[kTS]*kTT[kTS]

kTrans[0] = randomh(0, 3, $FRQ/16)
kTrans[1] = randomh(0, 3, $FRQ/16)
kTrans[2] = randomh(0, 3, $FRQ/16)
kTrans[3] = randomh(0, 3, $FRQ/16)
kTrans[4] = randomh(0, 3, $FRQ/16)
kTrans[5] = randomh(0, 3, $FRQ/16)
kTrans[6] = randomh(0, 3, $FRQ/16)
kTrans[7] = randomh(0, 3, $FRQ/16)

kGain[4] = randomh(-4, 4, $FRQ)
kGain[5] = randomh(-4, 4, $FRQ)
kGain[6] = randomh(-4, 4, $FRQ)
kGain[7] = randomh(-4, 4, $FRQ)

schedkwhen(kBT[kBS],0,0, "Bleep", 0, .2, -06, .5, kTP[kTS])
;schedkwhen(kBT[0],0,0, "Drm1", 0, .5, -18, .5)
;schedkwhen(kBT[4],0,0, "Drm2", 0, .1, -32, .5)
endin

instr Bleep
aEnv linseg 1, p3, 0
aS1  oscili aEnv^4, p6   +(1-aEnv)*lfo(41, 3.1)
aS2  oscili aEnv^4, p6*2 +(1-aEnv)*lfo(33, 5.5)
aS3  oscili aEnv^4, p6*3 +(1-aEnv)*lfo(25, 4.9)
aSig = (aS1+aS2+aS3)/3
klmt = 0.5 * aEnv
aSig limit aSig, -klmt, klmt
aSig diode_ladder aSig, 8000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

instr Drm1
iTanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
iIFrq   = 230
iEFrq   = 20
aAEnv   linseg 1,p3,0
aSig1   oscili aAEnv^2, expseg:k(iIFrq,p3/4,iEFrq)
aSig2   oscili aAEnv^2, expseg:k(iIFrq,p3/4,iEFrq)
aSig3   oscili aAEnv^2, expseg:k(iIFrq,p3/2,iEFrq*2^7)
aSig = (aSig1*2+aSig2+aSig3*.5)/3
aSig    distort aSig*2, 0.6, iTanh
;aSig    limit aSig, -0.5,0.5
aSig    += moogladder(aSig, iIFrq*2, .3)
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-12)
gaVerbR += ar*db(-12)
endin

instr Drm2
iTanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
iIFrq   = 420
iEFrq   = 230
aAEnv   linseg 1,p3,0
aSig1   oscili aAEnv^2, expseg:k(iIFrq,p3/4,iEFrq)
aSig2   oscili aAEnv^2, expseg:k(iIFrq,p3/4,iEFrq)
aSig3   oscili aAEnv^2, expseg:k(iIFrq,p3/2,iEFrq*2^7)
aSig4   noise  aAEnv^2, expseg:k(-0.9, p3/4, -0.1)
aSig = (aSig1*2+aSig2+aSig3*.5+aSig4)/4
aSig    distort aSig*2, 0.6, iTanh
;aSig    limit aSig, -0.5,0.5
aSig    += moogladder(aSig, iIFrq*2, .3)
aSig    pdhalf aSig, -0.8
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-12)
gaVerbR += ar*db(-12)
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

