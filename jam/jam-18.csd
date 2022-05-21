//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//you get a global array, and you get a global array..
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #69# ;pulses. per. minute.
#include "../opcodes.orc"

#define ROW #4# ;global array rows (number of simultanious instances)
#define COL #8# ;global array columns (length)

;taphy
gkTaphyAS[]     init $ROW
gkTaphyP[][]    init $ROW, $COL
gkTaphyT[][]    init $ROW, $COL

gkTaphyTrig[]   init $ROW
gkTaphyNote[][] init $ROW, $COL
gkTaphyGain[][] init $ROW, $COL
gkTaphyQ[][]    init $ROW, $COL
gkTaphyMin[][]  init $ROW, $COL
gkTaphyMax[][]  init $ROW, $COL

;FM
gkFmAmp[][]     init $ROW, 8
gkFmCps[][]     init $ROW, 8
gkFmRat[][]     init $ROW, 8
gaFmOut[]       init $ROW

;pluck
gaPluckOut[]    init $ROW

instr Taphy
iScale ftgenonce 0,0,-7*10,-51, 7,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)

kAS, kP[], kT[] Taphath gkTaphyTrig[p4],getrow(gkTaphyNote,p4),
                getrow(gkTaphyGain, p4),getrow(gkTaphyQ, p4),
                getrow(gkTaphyMin, p4), getrow(gkTaphyMax, p4), iScale

gkTaphyAS[p4] = kAS
gkTaphyP setrow kP, p4
gkTaphyT setrow kT, p4
endin

instr Fm
kAmp[] getrow gkFmAmp, p4
kCps[] getrow gkFmCps, p4
kRat[] getrow gkFmRat, p4
aOp1    Pmoscili kAmp[0], kCps[0]*kRat[0]
aOp2    Pmoscili kAmp[1], kCps[1]*kRat[1],  aOp1
aOp3    Pmoscili kAmp[2], kCps[2]*kRat[2],  aOp1
aOp4    Pmoscili kAmp[3], kCps[3]*kRat[3],  aOp1
aOp5    Pmoscili kAmp[4], kCps[4]*kRat[4],  aOp2+aOp3+aOp4
aOp6    Pmoscili kAmp[5], kCps[5]*kRat[5],  aOp5
aOp7    Pmoscili kAmp[6], kCps[6]*kRat[6],  aOp5
aOp8    Pmoscili kAmp[7], kCps[7]*kRat[7],  aOp5
gaFmOut[p4] = (aOp6 + aOp7 + aOp8)
endin

instr Kick
;use a fixed duration (the p3 being the entire duration including release)
iTanh   ftgenonce 0,0,1024,"tanh", -5, 5, 0
iIFrq   = 230
iEFrq   = 40
aAEnv   expsegr 1,1.1,0.0001
aFEnv   expsegr iIFrq,p3,iIFrq,0.06,iEFrq
aSig    oscili aAEnv*.6, aFEnv
aSig    distort aSig, k(aAEnv)*0.2, iTanh
aSig    limit aSig, -0.5,0.5
aSig    += moogladder(aSig, iIFrq*2, .3)
gaKickOut = aSig*0.5
endin

instr Drum
aEnv1 expsegr 1, p4, 0.0001
aEnv2 expsegr 1, p5, 0.0001
aEnv3 expsegr 1, p6, 0.0001
aOp1  Pmoscili aEnv1, p7
aOp2  Pmoscili aEnv1, p8
aOp3  Pmoscili aEnv1, p9, aOp1+aOp2
gaDrumOut = aOp3*0.05
endin

instr Granny ;use partikkel

endin

instr Pluck
iplk    =           p6 ;(0 to 1)
kamp    init        0.1
icps    =           p5
kpick   init        0.8 ;pickup point
krefl   init        p7 ;rate of decay ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl
;asig    rbjeq       asig, 200, 2, 0, 8, 10
aenv    linsegr     0,0.005,1,p3,1,p8,0 ;declick
gaPluckOut[p4] = asig*aenv
endin

instr Dist ;distortion
gaDistIn init 0
iTanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
kDist = 0.4
iHP = 10
iStor = 0
gaDistOut distort gaDistIn, kDist, iTanh, iHP, iStor
endin

instr Verb ;stolen from the floss manual 05E01_freeverb.csd
gaVerbIn    init 0
kRoomSize   init      0.85     ; room size (range 0 to 1)
kHFDamp     init      0.5      ; high freq. damping (range 0 to 1)
gaVerbOutL,gaVerbOutR freeverb gaVerbIn,gaVerbIn,kRoomSize,kHFDamp
endin

instr Main
kTrig0      metro $TEMPO/60 ;could div tempo by 4 (or whatever) and work in bars?
kC0[]       fillarray 8, 4, 2, 8, 8, 4, 1, 2, 1, 2, 4, 2, 2, 6, 2, 8
kG0[]       fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kMin[]      fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kMax[]      fillarray 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
kQ[]        fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kAS0, kT0[] tBasemath kTrig0, kC0, kG0, kMin, kMax, kQ
kQ[kAS0] = 0 ;remove current step from the queue
if kT0[4] == 1 then ;on step 4
    kQ[1] = 1 ;enqueue step 1
endif

kTrig1      metro $TEMPO/60
kC1[]       fillarray 08, 04, 01, 01, 01, 01, 02, 02
kAS1, kT1[] utBasemath kTrig1, kC1
kTrig2      metro $TEMPO*8/60
kC2[]       fillarray 03, 01, 03, 01, 02, 02, 02, 02
kAS2, kT2[] utBasemath kTrig2, kC2
kTrig3      metro $TEMPO*4/60
kC3[]       fillarray 03, 01, 03, 01, 02, 02, 02, 02
kAS3, kT3[] utBasemath kTrig3, kC3

;Taphy
gkTaphyTrig[0] = kTrig3
gkTaphyTrig[1] = kT3[kAS3]-(kT3[2]+kT3[4]+kT3[7])
gkTaphyNote = setrow(fillarray(3, 20, 4, 3, 6, 7, 8, 0), 0)
gkTaphyNote = setrow(fillarray(4, 21, 5, 4, 7, 8, 9, 1), 1)
gkTaphyGain = setrow(fillarray(0, 1, 0, 2, 0, 1, 0, 0), 0)
gkTaphyGain = setrow(fillarray(4, 1, 2, 0, 1, -4, 0, 8), 1)
kc2 init 0
while kc2 < $COL do
    gkTaphyMin[0][kc2] = 0
    gkTaphyMax[0][kc2] = 14+1
    gkTaphyMin[1][kc2] = 14
    gkTaphyMax[1][kc2] = 28+1
    kc2 += 1
od

schedule("Taphy", 0, p3, 0)
schedule("Taphy", 0, p3, 1)

;FM
;gkFmAmp = setrow(fillarray(0.37,0.05,0.25,0.05,0.35,0.05,0.05,0.05), 0)
;gkFmAmp = setrow(fillarray(0.22,0.15,0.35,0.35,0.12,0.05,0.05,0.05), 1)
;gkFmRat = setrow(fillarray(0.25,0.50,1.00,1.00,1.00,1.00,0.50,1.00), 0)
;gkFmRat = setrow(fillarray(0.25,0.50,1.00,1.00,1.00,0.25,0.50,1.00), 1)
;kc1 = 0
;while kc1 < $COL do
;    gkFmCps[0][kc1] = gkTaphyP[0][gkTaphyAS[0]]
;    gkFmCps[1][kc1] = gkTaphyP[1][gkTaphyAS[1]]
;    kc1 += 1
;od
;;gkFmCps = setrow(getrow(gkTaphyP, 0), 0)
;;gkFmCps = setrow(getrow(gkTaphyP, 1), 1)
;
;schedule("Fm", 0, p3, 0)
;schedule("Fm", 0, p3, 1)
;schedule("Fm", 0, p3, 2)

;pluck                                                             ;pr   dr   rl
schedkwhen(kTrig3,0,0, "Pluck",0,0.2, 0, gkTaphyP[0][gkTaphyAS[0]], 0.1, 0.9, 0.1)
if kAS0 = 1 then
    schedkwhen(gkTaphyTrig[1],0,0, "Pluck",0,0.8, 1, gkTaphyP[1][gkTaphyAS[1]], 0.1, 0.2, 0.1)
endif
if kAS0 = 4 then
    schedkwhen(kT3[0]+kT3[4],0,0, "Pluck",0,2.0, 1, gkTaphyP[1][gkTaphyAS[1]], 0.3, 0.2, 0.1)
endif


;drums
if kAS0 = 3 then
    schedkwhen(kT2[0]+kT2[4], 0,0, "Kick", 0, 0.0001)
    kDrmTrg = kT2[kAS2]-(kT2[2]+kT2[4]+kT2[7])
    schedkwhen(kDrmTrg,0,0,"Drum",0,0.0001,.1,.1,1,450,59,220)
elseif kAS0 = 2 then
    schedkwhen(kT2[0]+kT2[5], 0,0, "Kick", 0, 0.0001)
endif

;envelope
;gaFmOut[1] = gaFmOut[1]*trigexpseg(gkTaphyTrig[1], 1, 1.2, 0.0001)

;effects
;verb
schedule("Verb",0,-1)
gaVerbIn = gaKickOut*0.1 + gaFmOut[0]*0.2 + gaFmOut[1]*0.1
gaVerbIn += gaPluckOut[0]*0.1
gaVerbIn += gaPluckOut[1]*0.1
gaVerbIn += gaDistOut*0.02
;what if..
;gaVerbIn += (gaVerbOutL+gaVerbOutR)*0.5 ;yep! 🔄❗

;distortion
schedule("Dist",0,-1)
gaDistIn = gaPluckOut[0] + gaPluckOut[1]

;mix 🎚️🎚️🎚️🎚️🎛️ (db scale, amy)
aOutL = gaVerbOutL
aOutR = gaVerbOutR

aOutL += gaKickOut*0.3
aOutR += gaKickOut*0.3

aOutL += gaDrumOut
aOutR += gaDrumOut

aOutL += gaFmOut[0]*0.5+gaFmOut[1]*0.1;+gaFmOut[2]
aOutR += gaFmOut[0]*0.5+gaFmOut[1]*0.1;+gaFmOut[2]

;maybe init all globals outside?
aOutL += gaDistOut*0.01;+limit(gaDistOut, -0.01, 0.01)
aOutR += gaDistOut*0.01;+limit(gaDistOut, -0.01, 0.01)

aOutL += gaPluckOut[0]*0.5 + gaPluckOut[1]*0.5
aOutR += gaPluckOut[0]*0.5 + gaPluckOut[1]*0.5
;hbout a noise gate? <- maybe learn compression, aim?
outs aOutL, aOutR
endin
schedule("Main", 0, 120*($TEMPO/60)) ;120 beats
</CsInstruments>
</CsoundSynthesizer>

