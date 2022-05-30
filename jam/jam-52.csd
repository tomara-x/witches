//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;please don't like this
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
;#include "../utils.orc"
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

instr Grain2
seed 114
iScale ftgenonce 0,0,-7*3,-51, 14,4,cpspch(8), 0,
2^(00/12),2*2^(00/12),
2^(02/12),2*2^(02/12),
2^(03/12),2*2^(03/12),
2^(05/12),2*2^(05/12),
2^(07/12),2*2^(07/12),
2^(08/12),2*2^(08/12),
2^(10/12),2*2^(10/12)
kTrig    metro $FRQ*4
kNote[]  fillarray 0, 1, 3, 2, 19, 1, 2, 7
kTrans[] fillarray 1, 1, 3, 0, 1,  0, 0, 0
kQueue[] init 8
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale, 0,0,2
kGFrq = kP[kS]
kFMD = randomi(0, 1, $FRQ/4)
kGDur = randomi($BEAT/8, $BEAT/128, $FRQ*4)
kGDens = randomi(1/kGDur, 16/kGDur, $FRQ*16)
iMaxOvr = 30
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,0, kFMD,0, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
aSig diode_ladder aSig, 10000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

instr Grain3
seed 114
iScale ftgenonce 0,0,-7*3,-51, 7, 2, cpspch(8), 0,
2^(00/12),2^(02/12),2^(03/12),2^(05/12),2^(07/12),2^(08/12),2^(10/12)
kTrig    metro $FRQ*4
kNote[]  fillarray 0, 1, 3, 2, 10, 1, 2, 7
kTrans[] fillarray 0, 1, 0, 0, 1,  0,-2, 0
kQueue[] init 8
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale
kGFrq = kP[kS]
kFMD = randomi(0, 1, $FRQ/4)
kGDur = randomh(128/kP[kS], $BEAT/128, $FRQ*16)
kGDens = randomi(1/kGDur, 16/kGDur, $FRQ*2)
iMaxOvr = 30
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,0, kFMD,0, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
aSig diode_ladder aSig, 10000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

instr Grain4
seed 114
iScale ftgenonce 0,0,-7*3,-51, 7, 2, cpspch(8), 0,
2^(00/12),2^(02/12),2^(03/12),2^(05/12),2^(07/12),2^(08/12),2^(10/12)
kTrig    metro $FRQ*4
kNote[]  fillarray 0, 1, 3, 2, 10, 1, 2, 7
kTrans[] fillarray 0, 1, 0, 0, 1,  0,-2, 0
kQueue[] init 8
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale
kGFrq = kP[kS]
kFMD = randomi(0, 1, $FRQ/4)
kGDur = randomh(128/kP[kS], $BEAT/128, $FRQ*4)
kGDens = randomi(1/kGDur, 16/kGDur, $FRQ*8)
iMaxOvr = 30
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,0, kFMD,0, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
aSig diode_ladder aSig, 10000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

instr Grain5
seed 114
iScale ftgenonce 0,0,-7*3,-51, 7, 2, cpspch(8), 0,
2^(00/12),2^(02/12),2^(03/12),2^(05/12),2^(07/12),2^(08/12),2^(10/12)
kTrig    metro $FRQ*4
kNote[]  fillarray 0, 1, 3, 2, 10, 1, 2, 7
kTrans[] fillarray 0, 1, 0, 0, 1,  0,-2, 0
kQueue[] init 8
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale
kGFrq = kP[kS]
kFMD = randomi(0, 100, $FRQ/4)
kGDur = randomh(128/kP[kS], $BEAT/8, $FRQ*4)
kGDens = randomh(1/kGDur, 16/kGDur, $FRQ*8)
iMaxOvr = 30
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,0, kFMD,0, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
aSig diode_ladder aSig, 10000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

instr Grain6
seed 114
iScale ftgenonce 0,0,-7*3,-51, 7, 2, cpspch(8), 0,
2^(00/12),2^(02/12),2^(03/12),2^(05/12),2^(07/12),2^(08/12),2^(10/12)
kTrig    metro $FRQ*4
kNote[]  fillarray 0, 1, 3, 2, 10, 1, 2, 7
kTrans[] fillarray 0, 1, 0, 0, 1,  0,-2, 0
kQueue[] init 8
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale
kGFrq = kP[kS]
kFMD = randomi(0, 1, $FRQ/4)
kGDur = randomh($BEAT/64, $BEAT/8, $FRQ*4)
kGDens = randomh(1/kGDur, 1/kGDur, $FRQ*8)
iMaxOvr = 30
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,0, kFMD,0.5, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
aSig diode_ladder aSig, 10000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

;;begone, evil thought!
;;single operator instrument
;gaOps[] init 17 ;index 16 for empty modulation
;instr Op
;;setksmps 1
;aEnv  linseg 0, p4, 1, p5, 1, p6, 0
;acar  phasor kfreq
;aphs  = gaOps[p7]
;asig  tablei acarrier+aphs, -1, 1,0,1
;gaOps[p8] += asig
;endin

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
kCount[] fillarray 1, 1, 1, 1
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
i"KickSq"   +   60   0 ;puney kick
i"Grain2"   0   64 -18 0.5
s
t 0 113
i"Out"      0   [4*32+8]
i"Rawr"     0   16  .1
i"KickSq"   16  [4*28] 0
i"Grain3"   0   32 -18 0.5
i"Grain4"   32  32 -18 0.5
i"Grain5"   64  32 -18 0.5
i"Grain6"   96  32 -18 0.5
e
</CsScore>
</CsoundSynthesizer>

