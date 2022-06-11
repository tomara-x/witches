//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//taphy better inside main (for custom scales and stuff)
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
;#include "../utils.orc"
#include "../mixer.orc"

;FM
gkFM10Amp[][]   init 4, 16
gkFM10Cps[][]   init 4, 16
gkFM10Rat[][]   init 4, 16
gaFM10Out[]     init 4
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

gaPluckOut[]    init 4
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
kBC0[]      fillarray 2, 4, 2, 8, 8, 4, 1, 2, 1, 2, 4, 2, 2, 6, 8, 8
kBG0[]      fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kBQ[]       fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kBAS0, kBT0[] tBasemath kTrig0, kBC0, kBG0, 0, 9, kBQ

kTrig2      metro $TEMPO*8/60
kBC2[]      fillarray 03, 01, 03, 01, 02, 02, 02, 02
kBAS2, kBT2[] utBasemath kTrig2, kBC2
kTrig3      metro $TEMPO*4/60
kBC3[]      fillarray 03, 01, 03, 01, 02, 02, 02, 02
kBAS3, kBT3[] utBasemath kTrig3, kBC3
kTrig4      metro $TEMPO/2/60
kTrig5      = kBT3[kBAS3]-(kBT3[2]+kBT3[4]+kBT3[7])

;Taphy
iTS0 ftgenonce 0,0,-11,-51, 7,8,cpspch(6),0,
2^(0/12),2^(2/12),2^(2/12),2^(7/12),2^(10/12),2^(12/12),
2^(17/12),2^(20/12),2^(24/12),2^(29/12),2^(32/12)

kTN0[] fillarray 3, 20, 4, 3, 6, 7, 8, 0
kTG0[] fillarray 0, 1, 0, 2, 0, 1, 0, 0
kTQ0[] fillarray 0, 0, 0, 0, 0, 0, 0, 0
kTAS0, kTP0[], kTT0[] Taphath kTrig3,kTN0,kTG0,kTQ0, iTS0

kTN1[] fillarray 4, 21, 5, 4, 7, 8, 9, 1
kTG1[] fillarray 4, 1, 2, 0, 1, -4, 0, 8
kTQ1[] fillarray 0, 0, 0, 0, 0, 0, 0, 0
kTAS1, kTP1[], kTT1[] Taphath kTrig5,kTN1,kTG1,kTQ1, iTS0

;FM
gkFM10Amp[0][00] lfo 0.5, 0.01
gkFM10Amp[0][01] lfo 0.5, 0.02
gkFM10Amp[0][03] lfo 0.5, 0.001
gkFM10Amp[0][04] lfo 0.5, 0.004
gkFM10Amp[0][05] lfo 0.5, 0.005
gkFM10Amp[0][08] lfo 0.5, 0.011
gkFM10Amp[0][09] lfo 0.5, 0.002
gkFM10Amp[0][10] lfo 0.5, 0.007
gkFM10Amp[0][11] lfo 0.5, 0.104
gkFM10Amp[0][12] lfo 0.5, 0.09
gkFM10Amp[0][13] lfo 0.5, 0.009
gkFM10Amp[0][14] lfo 0.5, 0.08
gkFM10Amp[0][15] lfo 0.5, 0.019
gkFM10Amp[0][2], gkFM10Amp[0][6], gkFM10Amp[0][7] = 0.01
ktmp1[] = fillarray(1/4,1/2,1,1,1,1,1/2,1,1/4,1/2,1,2,1,1/8,1/2,1)
gkFM10Rat = setrow(ktmp1, 0)
kc1 = 0
while kc1 < 16 do
    gkFM10Cps[0][kc1] = kTP1[kTAS1]*4
    kc1 += 1
od
schedule("FM10", 0, p3, 0)

;pluck                                             ;pr   dr   rl
schedkwhen(kTrig4,0,0, "Pluck",0,1.2, 0, kTP0[kTAS0],.4,.3,.1)
if kBAS0 == 1 then
schedkwhen(kTrig5,0,0,"Pluck",0,0.8, 1, kTP1[kTAS1],.1,.2,.1)
endif
if kBAS0 == 4 then
schedkwhen(kBT3[0]+kBT3[4],0,0,"Pluck",0,8, 2, kTP1[kTAS1],.3,.2,3)
endif

;drums
if kBAS0 > 4 then
    schedkwhen(kBT2[0]+kBT2[4], 0,0, "Kick", 0, 0.0001)
endif
if kBAS0 > 3 && kBAS0%2==1 then
    kDrmTrg = kBT2[kBAS2]-(kBT2[2]+kBT2[4])
    schedkwhen(kDrmTrg,0,0,"Drum",0,0.0001,.5,.1,2,450,59,220)
endif

;effects
;verb
schedule("Verb",0,-1)
gaVerbIn = gaKickOut*0.1 
gaVerbIn += gaFM10Out[0]*0.2
gaVerbIn += gaPluckOut[0]*0.1
gaVerbIn += gaPluckOut[1]*0.1
gaVerbIn += gaDistOut*0.02

;distortion
schedule("Dist",0,-1)
gaDistIn = gaPluckOut[0] + gaPluckOut[1] + 8*limit(gaPluckOut[2], -0.01, 0.01)

;mix
sbus_write 0, gaVerbOutL, gaVerbOutR
sbus_write 1, gaKickOut
sbus_mult  1, ampdb(-18)
sbus_write 2, gaDrumOut
sbus_write 3, gaFM10Out[0]
sbus_mult  3, ampdb(-6)
sbus_write 4, gaDistOut
sbus_mult  4, ampdb(-24)
sbus_write 5, gaPluckOut[0]+gaPluckOut[1]+gaPluckOut[2]
sbus_mult  5, ampdb(-6)

;out
aL, aR sbus_out
iSM = .05
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM

kOutEnv linsegr 1, p3, 1, 10, 0
outs aL*kOutEnv, aR*kOutEnv

;exit after main is done
if timeinsts() == p3+10 then
scoreline "e", 1
endif
endin
schedule("Main", 0, (2*64)*($TEMPO/60)) ;2 loops of tBasemath in seconds <- lmao i was wrong here (60/tempo for beat duration)
</CsInstruments>
</CsoundSynthesizer>

