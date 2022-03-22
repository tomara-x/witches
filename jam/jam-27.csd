//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//babe? hbout some additive and vectorial fun? <- epic date
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m97 ;<- just note amps (1) and colors (96)
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #110#
#include "../sequencers.orc"
#include "../oscillators.orc"
#include "../utils.orc"
#include "../mixer.orc"

;gicharles OSCinit 9000

/*
gkFM10Amp[] init 16
gkFM10Cps[] init 16
gkFM10Rat[] init 16
gaFM10Out   init 0
instr FM10
kAmp[] = gkFM10Amp
kCps[] = gkFM10Cps
kRat[] = gkFM10Rat
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
gaFM10Out = aOp02+aOp06+aOp07
endin
*/

instr Kick
;p4-p9: amp decay, freq decay, freq[i], freq[f], distortion decay, dist[i]
iIFrq   = p6
iEFrq   = p7
aAEnv   expseg 1,p4,0.0001
aFEnv   expseg iIFrq,p5,iEFrq
aSig    oscili aAEnv, aFEnv
iTanh   ftgenonce 0,0,2^10,"tanh", -5, 5, 0
kDEnv   linseg p9,p8,0
aSig    += distort(aSig, kDEnv, iTanh)
aSig    += moogladder(aSig, iIFrq*2^3, .1)
gaKickOut = aSig
endin

instr Hsboscil ;originally stolen from floss example 04A13_hsboscil.csd
;km, kdata[] OSClisten gicharles, "/orientation", "fff" ;that was nuts
iSin    ftgenonce 0, 0, 2^10, 10, 1
iWindow ftgenonce 0, 0, 2^10, -19, 1, 0.5, 270, 0.5
iWav    ftgenonce 0, 0, 2^18, 9, 100,1.000,0, 278,0.500,0, 518,0.250,0,
        816,0.125,0, 1166,0.062,0, 1564,0.031,0, 1910,0.016,0
kAmp = 0.5
kTone rspline -1,1,4,7 ;try using pitch info instead
kBrite rspline -3,3,4,8
iBasFreq = p4
;switch between sin and wav based on p5
if p5 == 0 then
    aSig1 hsboscil kAmp, kTone, kBrite, iBasFreq, iSin, iWindow
else
    aSig1 hsboscil kAmp, kTone, kBrite, iBasFreq/100, iWav, iWindow
endif
aEnv linseg 1, p3, 0
gaHsboscilOut = (aSig1)*aEnv
endin

gaBassOut[] init 4
instr Bass
alin linseg p5, p3, 0
aexp expseg p5, p3, 0.01
aenv = alin*aexp
asig oscili aenv, p6
gaBassOut[p4] = asig
endin

instr Verb ;stolen from the floss manual 05E01_freeverb.csd
gaVerbIn    init 0
kRoomSize   init      0.85     ; room size (range 0 to 1)
kHFDamp     init      0.5      ; high freq. damping (range 0 to 1)
gaVerbOutL,gaVerbOutR freeverb gaVerbIn,gaVerbIn,kRoomSize,kHFDamp
endin

instr Main
;the sacred timeline
kBarN       init 0
kBar        metro $TEMPO/4/60 ;click every 4th beat
kBarN += kBar
kCount[]    fillarray 2, 2, 2, 2, 8, 4, 2, 2, 8, 1, 8, 8, 1, 4, 2, 1
kGain[]     fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kQueue[]    fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kV, kTL[]   tBasemath kBar, kCount, kGain, 1, 17, kQueue
;---
/*
;bass
kTrig0      metro $TEMPO*8/60
kBC0[]      fillarray 3, 1, 3, 1, 2, 2, 2, 2
kBAS0, kBT0[] utBasemath kTrig0, kBC0
iTS0 ftgenonce 0,0,-11,-51, 11,8,cpspch(6),0,
2^(0/12),2^(2/12),2^(2/12),2^(7/12),2^(10/12),2^(12/12),
2^(17/12),2^(20/12),2^(24/12),2^(29/12),2^(32/12)
kTN0[] fillarray 3, 20, 4, 3, 6, 7, 8, 0
kTG0[] fillarray 0, 1, 0, 2, 0, 1, 0, 0
kTQ0[] fillarray 0, 0, 0, 0, 0, 0, 0, 0
kTAS0, kTP0[], kTT0[] Taphath kTrig0,kTN0,kTG0,kTQ0, iTS0
;schedkwhen(kBT0[kBAS0],0,0, "Bass",0,0.1, 0, 0.1, kTP0[kTAS0])
;---
;additive
kTrig1  metro $TEMPO*4/60
iTS1    ftgenonce 0,0,-7*3,-51, 7,2,cpspch(6),0,
2^(0/12),2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
kTN1[]  fillarray 3, 3, 4, 2, 6, 6, 8, 0
kTG1[]  fillarray 0, 0, 17, 0, 0, 1, 1, 1
kTQ1[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0
kTAS1, kTP1[], kTT1[] Taphath kTrig1,kTN1,kTG1,kTQ1, iTS1, 0, 0, 2
iAdAmp  ftgenonce 0,0,64,-7, 0.05, 64, 0.05
iAdFrq  ftgenonce 0,0,64,-7, 1, 64, 64
aAdSig  adsynt 0.5, kTP1[kTAS1], -1, iAdFrq, iAdAmp, 8 ;200?
if ClkDiv(kTrig1, 4) == 1 then
    vadd iAdFrq, 0.01, 5, 1
endif
;---
*/
;hsboscil
kFrq = $TEMPO*4/60
kTrig2  metro kFrq
iTS2    ftgenonce 0,0,-5,-51, 5,2,cpspch(6),0,
2^(0/12),2^(3/12),2^(17/12),2^(7/12),2^(34/12)
kTN2[]  fillarray 3, 3, 4, 2, 6, 6, 8, 0
kTG2[]  fillarray 0, 0, 2, -1, 0, 1, 1, 1
kTQ2[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0
kTAS2, kTP2[], kTT2[] Taphath kTrig2,kTN2,kTG2,kTQ2, iTS2, 0, 0, 2
schedkwhen(kTrig2,0,0, "Hsboscil",0, 1/kFrq, kTP2[kTAS2], 0) ;<- cool switch
gaHsboscilOut moogladder gaHsboscilOut, kTP2[kTAS2]*16, .8
gaHsboscilOut pdhalf gaHsboscilOut, -0.99
sbus_write 0, limit(gaHsboscilOut,-0.1,0.1)
sbus_mult  0, ampdb(-6)


;drums
;kTrig1      metro $TEMPO/2/60
;schedkwhen(kTrig1, 0,0, "Kick", 0, 4, 0.8, 0.08, 830, 40, 0.4, 0.2)

;verb
;schedule("Verb",0,-1)
;gaVerbIn = gaKickOut*0.1 

;mix
;sbus_write 0, gaVerbOutL, gaVerbOutR
;sbus_write 1, gaKickOut
;sbus_mult  1, ampdb(-6)
;sbus_write 2, aAdSig
;sbus_mult  2, ampdb(-6)
;sbus_write 3, gaBassOut[0]+gaBassOut[1]


;out
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM

outs aL, aR

;exit after main is done
if timeinsts() == p3+10 then
;clear calls if any
scoreline "e", 1 ;(timeinstk() == p3+10? 1 : 0) <- nah, evil
endif
endin
schedule("Main", 0, (2*64)*($TEMPO/60)) ;hbout sumarray?
</CsInstruments>
</CsoundSynthesizer>

