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

#define TEMPO #113#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#

#include "../sequencers.orc"
#include "../utils.orc"
gay, gal, gar init 0

instr Grain1
seed 113
;nine-tone blues
iScale ftgenonce 0,0,-9*3,-51, 9,2,cpspch(p7+4), 0,
2^(00/12),2^(02/12),2^(03/12),
2^(04/12),2^(05/12),2^(06/12),
2^(07/12),2^(09/12),2^(10/12)
kTrig    metro $FRQ*p6
kNote[]  fillarray 1, 1, 0, 3, 1, 1, 7, 1,  1, 1, 0, 4, 1, 1, 8, 3,
                   1, 1, 0, 3, 1, 1, 5, 1,  1, 1, 0, 4, 1, 1, 5, 3
kTrans[] init 32 
kQueue[] init 32
kR[]     init 32
if kR[0]%4 == 0 then
;there should be a cleaner way to force assign at k-time without them silly k()
    kTrans fillarray k(8), 3, 9, 3, 0, 0, 0, 2,  0, 0, 6, 0, 0, 6, 7, 0,
                        0, 7, 0,-9, 0, 7, 2, 1,  2, 4,-3, 7, 0, 7, 0, 3
else
    kTrans fillarray k(2), 3, 9, 3, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0, 0, 0,  2, 4, 0, 0, 0, 0, 0, 0
endif
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale
kR[kS] = kR[kS] + kT[kS]


kGFrq = kP[kS]
kGPhs = 0 ;(lfo:k(1, $FRQ*1, 4)+1)/2
kFMD = randomi(0, 1, $FRQ/4)
kPMD = .1
kGDur = randomi($BEAT/2, $BEAT/128, $FRQ*4)
kGDens = randomi(1/kGDur, 16/kGDur, $FRQ*8)
;kGDens = randomi($FRQ*16, $FRQ*32, $FRQ*8)
;kGDur = 1/kP[kS]
;kGDens = kP[kS]
iMaxOvr = 32
iWav ftgenonce 0,0,2^14,9, 1,.1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,kGPhs, kFMD,kPMD, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
;aSig *= trigExpseg(kT[kS], 1, 1/($FRQ*4), 0.01)
if p8 == 1 then
    aSig *= (1 - phasor:a($FRQ*p6))^2 ;envelope (long story)
endif
if p9 == 1 then
    aSig pdhalf aSig, -0.8 
endif
if p10 == 1 then
    iTanh ftgenonce 0,0,2^10+1,"tanh", -5, 5, 0
    aSig distort aSig, .8, iTanh
endif
aSig diode_ladder aSig, 10000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

/*
instr Kick
;p4, p5, p6, p7 : freq decay, freq[i], freq[f], distortion
iIFrq, iEFrq = p5, p6
aAEnv   expseg 2,p3,0.0001
aFEnv   expseg iIFrq,p4,iEFrq
aSig    oscili aAEnv, aFEnv
aSig    moogladder aSig, p5*4, .2
aSig    pdhalf aSig, p7
gay += aSig*db(p8) ;trying something
gaVerbL += aSig*db(p9)
gaVerbR += aSig*db(p9)
endin

instr KickSq
kTrig metro $FRQ
schedkwhen(kTrig, 0,0, "Kick", 0, .8, 0.1, 230, 20, p6, p4, p5) ;evil
endin
*/

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
i"Out"      0   [8*64+4]
;                       db pan    clk  oct  env dist more
i"Grain1"   0   [8*64] -03 0.55   4    0    1   0    0
i"Grain1"   0   [8*64] -06 0.45   4    7    1   0    0
i"Grain1"   0   [8*64] -12 0.50   .5   2    0   0    0
e
</CsScore>
</CsoundSynthesizer>

