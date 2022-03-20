//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//babe? hbout some additive and vectorial fun? <- epic date
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m0 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #110#
#include "../sequencers.orc"
;#include "../oscillators.orc"
#include "../utils.orc"
#include "../mixer.orc"

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
sbus_write 2, aAdSig
sbus_mult  2, ampdb(-6)
;sbus_write 3, gaBassOut[0]+gaBassOut[1]

;out
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM

kOutEnv linsegr 1, p3, 1, 10, 0
outs aL*kOutEnv, aR*kOutEnv

;exit after main is done
if timeinsts() == p3+10 then
;clear calls if any
scoreline "e", 1 ;(timeinstk() == p3+10? 1 : 0) <- nah, evil
endif
endin
schedule("Main", 0, (2*64)*($TEMPO/60)) ;hbout sumarray?
</CsInstruments>
</CsoundSynthesizer>

