//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

// 2/3 fm
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #96#
#include "../sequencers.orc"
#include "../oscillators.orc"
#include "../utils.orc"


;taphy
#define ROW #4# ;global array rows (number of simultanious instances)
#define COL #8# ;global array columns (length)
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
gkFM10Amp[][]   init $ROW, 16
gkFM10Cps[][]   init $ROW, 16
gkFM10Rat[][]   init $ROW, 16
gaFM10Out[]     init $ROW

;pluck
gaPluckOut[]    init $ROW

instr Taphy
;spanish mode
iScale ftgenonce 0,0,-7*10,-51, 7,2,cpspch(6),0,
2^(0/12),2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)

kAS, kP[], kT[] Taphath gkTaphyTrig[p4],getrow(gkTaphyNote,p4),
                getrow(gkTaphyGain, p4),getrow(gkTaphyQ, p4),
                getrow(gkTaphyMin, p4), getrow(gkTaphyMax, p4), iScale

gkTaphyAS[p4] = kAS
gkTaphyP setrow kP, p4
gkTaphyT setrow kT, p4
endin

instr FM10
kAmp[]  getrow gkFM10Amp, p4
kCps[]  getrow gkFM10Cps, p4
kRat[]  getrow gkFM10Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp08+aOp09+aOp13
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp00
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp03
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp01+aOp04+aOp05
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp00
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp00
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp03
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp03
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp12
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp12
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp15
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp15
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp10+aOp11+aOp14
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp12
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp15
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
gaFM10Out[p4] = aOp02+aOp06+aOp07
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
kTrig0      metro $TEMPO/60
kC0[]       fillarray 2, 4, 2, 8, 8, 4, 1, 2, 1, 2, 4, 2, 2, 6, 8, 8
kG0[]       fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kMin[]      fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kMax[]      fillarray 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
kQ[]        fillarray 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
kAS0, kT0[] tBasemath kTrig0, kC0, kG0, kMin, kMax, kQ
kQ[kAS0] = 0 ;remove current step from the queue
;if kT0[4] == 1 then ;on step 4
;    kQ[1] = 1 ;enqueue step 1
;endif

kTrig2      metro $TEMPO*8/60
kC2[]       fillarray 03, 01, 03, 01, 02, 02, 02, 02
kAS2, kT2[] utBasemath kTrig2, kC2
kTrig3      metro $TEMPO*4/60
kC3[]       fillarray 03, 01, 03, 01, 02, 02, 02, 02
kAS3, kT3[] utBasemath kTrig3, kC3

;Taphy
gkTaphyTrig[0] = kTrig3
gkTaphyNote = setrow(fillarray(3, 20, 4, 3, 6, 7, 8, 0), 0)
gkTaphyGain = setrow(fillarray(0, 1, 0, 2, 0, 1, 0, 0), 0)
gkTaphyTrig[1] = kT3[kAS3]-(kT3[2]+kT3[4]+kT3[7])
gkTaphyNote = setrow(fillarray(4, 21, 5, 4, 7, 8, 9, 1), 1)
gkTaphyGain = setrow(fillarray(4, 1, 2, 0, 1, -4, 0, 8), 1)
kc2 init 0
while kc2 < $COL do
    gkTaphyMin[0][kc2] = 0
    gkTaphyMax[0][kc2] = 14+1
    gkTaphyMin[1][kc2] = 14
    gkTaphyMax[1][kc2] = 28+1
    gkTaphyMin[2][kc2] = 00
    gkTaphyMax[2][kc2] = 28+1
    kc2 += 1
od
schedule("Taphy", 0, p3, 0)
schedule("Taphy", 0, p3, 1)

;FM
gkFM10Amp[0][00] = ampdb(randomi(-24, -1,  2))
gkFM10Amp[0][01] = ampdb(randomi(-64, -3,  1))
gkFM10Amp[0][03] = ampdb(randomi(-12, -3,  3))
gkFM10Amp[0][04] = ampdb(randomi(-64, -3, .8))
gkFM10Amp[0][05] = ampdb(randomi(-64,  0,  3))
gkFM10Amp[0][08] = ampdb(randomi(-64, -3,  5))
gkFM10Amp[0][09] = ampdb(randomi(-48, -3,  8))
gkFM10Amp[0][10] = ampdb(randomi(-64,  0,  5))
gkFM10Amp[0][11] = ampdb(randomi(-96, -3,  5))
gkFM10Amp[0][12] = ampdb(randomi(-24,  0, .2))
gkFM10Amp[0][13] = ampdb(randomi(-64, -3,  5))
gkFM10Amp[0][14] = ampdb(randomi(-64, -3,  4))
gkFM10Amp[0][15] = ampdb(randomi(-24, -1,  2))
gkFM10Amp[0][2], gkFM10Amp[0][6], gkFM10Amp[0][7] = 0.01
ktmp1[] = fillarray(1/4,1/2,1,1,1,1,1/2,1,1/4,1/2,1,2,1,1/8,1/2,1)
gkFM10Rat = setrow(ktmp1, 0)
kc1 = 0
while kc1 < $COL do
    gkFM10Cps[0][kc1] = gkTaphyP[1][gkTaphyAS[1]]
    gkFM10Cps[0][kc1+8] = gkTaphyP[1][gkTaphyAS[1]]
    kc1 += 1
od
schedule("FM10", 0, p3, 0)

kbass init 0
if kAS0 == 0 then ;bass comes in at step 0
kbass = 1
endif
if kbass == 1 then
;pluck                                                          ;pr   dr   rl
schedkwhen(kTrig3,0,0, "Pluck",0,0.2, 0, gkTaphyP[0][gkTaphyAS[0]],.1,.9,.1)
endif

if kAS0 == 1 then
schedkwhen(gkTaphyTrig[1],0,0,"Pluck",0,0.8, 1, gkTaphyP[1][gkTaphyAS[1]],.1,.2,.1)
endif
if kAS0 == 4 then
schedkwhen(kT3[0]+kT3[4],0,0,"Pluck",0,8, 2, gkTaphyP[1][gkTaphyAS[1]],.3,.2,.1)
endif

;drums
if kAS0 == 3 then
    schedkwhen(kT2[0]+kT2[4], 0,0, "Kick", 0, 0.0001)
    kDrmTrg = kT2[kAS2]-(kT2[2]+kT2[4]+kT2[7])
    schedkwhen(kDrmTrg,0,0,"Drum",0,0.0001,.1,.1,1,450,59,220)
elseif kAS0 == 2 || kAS0 = 5 then
    schedkwhen(kT2[0]+kT2[5], 0,0, "Kick", 0, 0.0001)
endif

;effects
;verb
schedule("Verb",0,-1)
gaVerbIn = gaKickOut*0.1 + gaFM10Out[0]*0.2 + gaFM10Out[1]*0.1
gaVerbIn += gaPluckOut[0]*0.1
gaVerbIn += gaPluckOut[1]*0.1
gaVerbIn += gaDistOut*0.02
;what if..
;gaVerbIn += (gaVerbOutL+gaVerbOutR)*0.5 ;yep! 🔄❗

;distortion
schedule("Dist",0,-1)
gaDistIn = gaPluckOut[0] + gaPluckOut[1] + 8*limit(gaPluckOut[2], -0.01, 0.01)

;mix 🎚️🎚️🎚️🎚️🎛️ (db scale, amy)
aOutL = gaVerbOutL
aOutR = gaVerbOutR

aOutL += gaKickOut*0.3
aOutR += gaKickOut*0.3

aOutL += gaDrumOut
aOutR += gaDrumOut

aOutL += gaFM10Out[0]*0.5+gaFM10Out[1]*0.1;+gaFM10Out[2]
aOutR += gaFM10Out[0]*0.5+gaFM10Out[1]*0.1;+gaFM10Out[2]

;maybe init all globals outside?
aOutL += gaDistOut*0.03;+limit(gaDistOut, -0.01, 0.01)
aOutR += gaDistOut*0.03;+limit(gaDistOut, -0.01, 0.01)

aOutL += gaPluckOut[0]*0.5 + gaPluckOut[1]*0.5+gaPluckOut[2]*0.5
aOutR += gaPluckOut[0]*0.5 + gaPluckOut[1]*0.5+gaPluckOut[2]*0.7
;hbout a noise gate? <- maybe learn compression, aim?
outs aOutL, aOutR
endin
schedule("Main", 0, 120*($TEMPO/60)) ;120 beats
</CsInstruments>
</CsoundSynthesizer>

