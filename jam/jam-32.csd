//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//for everyone stuck, living where they don't want <3 (hang in there)
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m97
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

gaKickOut init 0
instr Kick
;p4-p7: amp decay, freq decay, freq[i], freq[f]
iIFrq   = p6
iEFrq   = p7
aAEnv   expseg 1,p4,0.0001
aFEnv   expseg iIFrq,p5,iEFrq
aSig    oscili aAEnv, aFEnv
;aSig    += moogladder(aSig, aFEnv*2^3, .5)
gaKickOut = aSig
endin

gaHsboscilOut init 0
instr Hsboscil ;originally stolen from floss example 04A13_hsboscil.csd
iSin    ftgenonce 0, 0, 2^10, 10, 1
iWindow ftgenonce 0, 0, 2^10, -19, 1, 0.5, 270, 0.5
iWav    ftgenonce 0, 0, 2^18, 9, 100,1.000,0, 278,0.500,0, 518,0.250,0,
        816,0.125,0, 1166,0.062,0, 1564,0.031,0, 1910,0.016,0
kAmp = .5
kTone rspline -1,1,4,7
;kBrite rspline -3,3,4,8
kBrite rspline -1,1,1,2
iBasFreq = 220
;switch between sin and wav based on p5
if p5 == 0 then
    aSig hsboscil kAmp, p4, kBrite, iBasFreq, iSin, iWindow, 6
elseif p5 == 1 then
    aSig hsboscil kAmp, p4, kBrite, iBasFreq/100, iWav, iWindow, 3
elseif p5 == 2 then
    aSig = sum(hsboscil(kAmp, p4, kBrite, iBasFreq, iSin, iWindow, 3),
               hsboscil(kAmp, p4, kBrite, 228, iSin, iWindow, 3))
endif
aEnv adsr p6, p7, p8, p9
gaHsboscilOut += aSig * (aEnv*.5)
endin

instr Graint
;grain3
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
kRoomSize   init      0.55     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
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
kQueue[kV] = 0
;bass------------------------------
/*
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
;sbus_write 3, gaBassOut[0]+gaBassOut[1]
*/
;additive------------------------------
/*
kTrig1  metro $TEMPO*4/60
kBC1[]      fillarray 7, 1, 3, 1, 2, 2, 2, 2
kBAS1, kBT1[] utBasemath kTrig1, kBC1
iTS1    ftgenonce 0,0,-3*5,-51, 3,2,cpspch(5),0,
2^(2/12),2^(7/12),2^(8/12)
kTN1[]  init 128                               ;FTS! I'M TIRED!
kTG1[]  init 128
kTQ1[]  init 128
itmp ftgenonce 0,0,128,-21,1,34
copyf2array kTN1, itmp
kTAS1, kTP1[], kTT1[] Taphath kBT1[kBAS1],kTN1,kTG1,kTQ1, iTS1
kcps = kTP1[kTAS1]
iAdAmp  ftgenonce 0,0,32,-21,1,0.1
iAdFrq  ftgenonce 0,0,32,-7, 1, 32, 65
;iAdFrq  ftgenonce 0,0,32,-5, 1, 16, 2^16, 16, 18
;ftprint iAdFrq
aAdSig  adsynt2 0.5, kcps, -1, iAdFrq, iAdAmp, 8
;if ClkDiv(kTrig1, 4) == 1 then
;    vadd iAdFrq, 0.01, 5, 1
;endif

sbus_write 2, aAdSig
sbus_mult  2, ampdb(-12)
*/
;hsboscil------------------------------
/*
kFrq = $TEMPO*2/60
kWav = 0
kDist = -0.8
kTrig2  metro kFrq
iTS2    ftgenonce 0,0,-5,-51, 5,8,cpspch(6.05),0,
2^(0/12),2^(3/12),2^(17/12),2^(7/12),2^(34/12)
kTN2[]  fillarray 3, 3, 0, 0, 0, 0, 0, 0
kTG2[]  fillarray 0, 0, 2, -1, 0, 1, 1, 1
kTQ2[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0
kTAS2, kTP2[], kTT2[] Taphath kTrig2,kTN2,kTG2,kTQ2, iTS2, 0, 0, 2
schedkwhen(kTrig2,0,0, "Hsboscil",0, 2/kFrq, kTP2[kTAS2], kWav, .001, .6, .001,.1)
;gaHsboscilOut pdhalf gaHsboscilOut, kDist
;gaHsboscilOut moogladder gaHsboscilOut, kTP2[kTAS2]*8, .8
;gaHsboscilOut limit gaHsboscilOut, -0.1, 0.1
sbus_write 0, gaHsboscilOut
sbus_mult  0, ampdb(-6)
if kV == 9 then
    clear gaHsboscilOut
    sbus_mult 0, 0
endif
*/
;kick------------------------------
kTrig3  metro $TEMPO/60
if kV == 3 || kV == 9 then
    schedkwhen(kTrig3, 0,0, "Kick", 0, 4, 0.4, 0.03, 290, 40)
elseif kV >= 4 && kV < 7 then
    schedkwhen(kTrig3, 0,0, "Kick", 0, 4, 0.5, 0.08, 230, 40)
;elseif kV > 7 then
;    schedkwhen(kTrig3, 0,0, "Kick", 0, 4, 0.7, 0.09, 230, 40)
;    gaKickOut pdhalf gaKickOut, -0.8
endif
;gaKickOut limit gaKickOut, -0.7, 0.7
;gaKickOut pdhalf gaKickOut, -0.8
;gaKickOut moogladder gaKickOut, 8000, 0.2
sbus_write 1, gaKickOut
sbus_mult  1, ampdb(-18)
if kV == 9 then
    sbus_mult 1, 0
endif
;verb------------------------------
schedule("Verb",0,-1)
gaVerbIn = gaKickOut*ampdb(-32) +
           gaHsboscilOut*ampdb(-64)
sbus_write 15, gaVerbOutL, gaVerbOutR
;out------------------------------
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM
kFade linseg 1, p3-10, 1, 10, 0
outs aL*kFade, aR*kFade
;clear-globals------------------------------
clear gaFM10Out, gaKickOut, gaHsboscilOut
endin
</CsInstruments>
<CsScore>
i"Main" 0 [228*(60/110)]
e
</CsScore>
</CsoundSynthesizer>

