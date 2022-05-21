//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;hail satan tonight
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #131#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#

#include "../sequencers.orc"
#include "../mixer.orc"
;#include "../utils.orc"

instr Grain
seed 420 ;good for the environment
iScale ftgenonce 0,0,-7*4,-51, 10,4,cpspch(5), 0,
2^(00/12),2*2^(00/12),
2^(02/12),2*2^(02/12),
2^(05/12),2*2^(05/12),
2^(08/12),2*2^(08/12),
2^(10/12),2*2^(10/12)
kTrig    metro $FRQ*4
kNote[]  fillarray 0,  1,  3,  2,  2,  4,  4,  4
kTrans[] fillarray 1,  1,  3,  0,  0,  1,  9,  6
kQueue[] fillarray 0,  0,  0,  0,  0,  0,  0,  0
kMin[]   fillarray 0,  0,  0,  0,  0,  0,  14, 0
kMax[]   fillarray 32, 32, 32, 32, 32, 32, 32, 32
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, kMin, kMax, iScale
kGFrq = kP[kS]
kGPhs = (lfo:k(1, $FRQ*1, 4)+1)/2
kFMD = randomi(0, 1, $FRQ/4)
kPMD = .0
kGDur = randomh($BEAT/8, $BEAT/4, $FRQ/2);*((lfo:k(1, $FRQ*4, 4)+1.001)/2)
kGDens = randomi(1/kGDur, 4/kGDur, $FRQ/16)
iMaxOvr = 30
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.1,0, 4,.05,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,kGPhs, kFMD,kPMD, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
aSig pdhalf aSig, randomi:k(-.8, -.4, $FRQ/4)
iTanh ftgenonce 0,0,2^10+1,"tanh", -5, 5, 0
aSig distort aSig, (lfo:k(.8, $FRQ)+1)/2, iTanh
aSig diode_ladder aSig, 18000, 1, 1
sbus_mix 0, aSig*db(-6)
;gaVerbInL += aSig*db(-12)
;gaVerbInR += aSig*db(-12)
endin

gaVerbInL,gaVerbInR init 0
instr Verb
kRoomSize   init      0.65     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
aVerbL,aVerbR freeverb gaVerbInL,gaVerbInR,kRoomSize,kHFDamp
sbus_mix 15, aVerbL, aVerbR
clear gaVerbInL,gaVerbInR
endin

instr Out
aL, aR sbus_out
kSM = 1
aL limit aL, -kSM, kSM
aR limit aR, -kSM, kSM
outs aL, aR
sbus_clear_all
endin
</CsInstruments>
<CsScore>
i"Verb"  0 -1
i"Grain" 0 -1
i"Out"   0 [4*64*(60/131)]
e
</CsScore>
</CsoundSynthesizer>

