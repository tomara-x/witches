//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;need ma clock dividah
;dissect this shit!
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #113#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#

#include "../sequencers.orc"
#include "../utils.orc"
gay, gal, gar init 0

instr Grain1
seed 113
iScale ftgenonce 0,0,-7*3,-51, 14,4,cpspch(6), 0,
2^(00/12),2*2^(00/12),
2^(02/12),2*2^(02/12),
2^(03/12),2*2^(03/12),
2^(05/12),2*2^(05/12),
2^(07/12),2*2^(07/12),
2^(08/12),2*2^(08/12),
2^(10/12),2*2^(10/12)
kTrig    metro $FRQ
kNote[]  fillarray 0, 1, 3, 2, 19, 1, 2, 7
kTrans[] fillarray 1, 1, 3, 0, 1,  0, 0, 0
kQueue[] init 8
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale
kGFrq = kP[kS]
kGPhs = (lfo:k(1, $FRQ*1, 4)+1)/2
kFMD = randomi(0, 1, $FRQ/4)
kPMD = .0
kGDur = randomi($BEAT/2, $BEAT/128, $FRQ*4)
kGDens = randomi(1/kGDur, 16/kGDur, $FRQ*8)
;kGDens = randomi($FRQ*16, $FRQ*32, $FRQ*8)
iMaxOvr = 30
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,kGPhs, kFMD,kPMD, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
;aSig pdhalf aSig, randomi:k(-.8, -.4, $FRQ/4)
;iTanh ftgenonce 0,0,2^10+1,"tanh", -5, 5, 0
;aSig distort aSig, (lfo:k(.8, $FRQ)+1)/2, iTanh
;aSig diode_ladder aSig, 10000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

instr Rawr
aSig bamboo p4, p3, 50, .01, .0, 407, 268, 790
aSig limit aSig, -.5, .5
gay += aSig*db(-6)
gaVerbL += aSig*db(-6)
gaVerbR += aSig*db(-6)
endin

instr Kick
;p4, p5, p6, p7 : freq decay, freq[i], freq[f], effect
iIFrq, iEFrq = p5, p6
aAEnv   expseg 1,p3,0.0001
aFEnv   expseg iIFrq,p4,iEFrq
aSig    oscili aAEnv, aFEnv
aSig    moogladder aSig, p5*4, .2
if p7 == 1 then
    aSig pdhalf aSig, -0.7
endif
gay += aSig*db(-3)
gaVerbL += aSig*db(-3)
gaVerbR += aSig*db(-3)
endin

instr KickSq
kTrig metro $FRQ
schedkwhen(kTrig, 0,0, "Kick", 0, 1, 0.1, 230, 20, p4)
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
i"Verb"    0 -1
;-------------
t 0 113
i"Out"      0   64
i"Grain1"   0   64 -18 0.5
s
t 0 113
i"Out"      0   64
i"KickSq"   0   4    1 ;kick
i"KickSq"   +   60   0 ;puny kick
i"Grain2"   0   64 -18 0.5
e
</CsScore>
</CsoundSynthesizer>

