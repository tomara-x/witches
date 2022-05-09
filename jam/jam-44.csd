//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231 ;-m97
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #128#
#include "../sequencers.orc"
;#include "../oscillators.orc"
#include "../mixer.orc"
#include "../utils.orc"

instr Kick
;p4, p5, p6, p7 : freq decay, freq[i], freq[f], effect
iIFrq, iEFrq = p5, p6
aAEnv   expseg 1,p3,0.0001
aFEnv   expseg iIFrq,p4,iEFrq
aSig    oscili aAEnv, aFEnv
aSig    moogladder aSig, p5*4, .2
if p7 == 1 then
    aSig pdhalf aSig, -0.8
endif
sbus_mix 1, aSig*db(-3), aSig*db(-6)
gaVerbInL += aSig*db(-3)
gaVerbInR += aSig*db(-3)
endin

instr Bass
iPlk    =    p6 ;(0 to 1)
kAmp    =    ampdb(p4)
iCps    =    p5 ;cpspch(p5)
kPick   =    p7 ;pickup point
kRefl   =    p8 ;rate of decay ]0,1[
aSig    wgpluck2 iPlk,kAmp,iCps,kPick,kRefl
aSig    diode_ladder aSig, p5*8, 10, 1, 10
aEnv    linseg 1, p3-0.05, 1, 0.05, 0
aSig *= aEnv
sbus_mix 2, aSig*db(-3)
gaVerbInL += aSig*db(-24)
gaVerbInR += aSig*db(-24)
endin

gaVerbInL,gaVerbInR init 0
instr Verb
kRoomSize   init      0.55     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
aVerbL,aVerbR freeverb gaVerbInL,gaVerbInR,kRoomSize,kHFDamp
sbus_mix 15, aVerbL, aVerbR
clear gaVerbInL,gaVerbInR
endin

instr Main
;the sacred timeline
kBar        metro $TEMPO/4/60 ;click every 4th beat
kCount[]    fillarray 2, 4, 4, 8, 8,16, 2, 4
kGain[]     fillarray 0, 0, 0, 0, 0, 0, 0, 0
kQueue[]    fillarray 0, 0, 0, 0, 0, 0, 0, 0
kS, kTL[]   tBasemath kBar, kCount, kGain, 1, 17, kQueue ;Section# and TimeLine array
kReps[] init 8 ;count how many times each step is activated
kReps[kS] = kReps[kS] + kTL[kS] 
kQueue[kS] = 0 ;unqueue the current step
;kick------------------------------
kKT metro $TEMPO/60 ;KickTrigger
;if kS == 3 || kS == 4 then
;    schedkwhen(kKT,0,0, "Kick",0,1, 0.09, 230, 40, 1)
;endif
;bass------------------------------
kFrq  = $TEMPO*4/60
kBT   metro kFrq ;BassTrigger
;iBS ftgenonce 0,0,-3*2,-51, 3,2,cpspch(6), 0,
;2^(0/12),2^(2/12),2^(5/12) ;BassScale
iBS ftgenonce 0,0,-7*3,-51, 7,2,cpspch(6), 0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12) ;BassScale
kBN[] fillarray 1, 1, 1, 0, 2, 4, 4, 3  ;BassNotes
kBG[] fillarray 0, 2, 0, 0, 0, 1, 0, 2  ;BassGain (transposition)
kBQ[] fillarray 0, 0, 0, 0, 0, 0, 0, 0  ;BassQueue
kBTS, kBTP[], kBTT[] Taphath kBT, kBN,kBG,kBQ, iBS
kp3 = 1/kFrq
schedkwhen(kBT,0,0, "Bass",0,kp3,-6,kBTP[kBTS], .6,.9,.8)
schedkwhen(kBT,0,0, "Bass",0,kp3,-9,kBTP[(kBTS+1)%8]*2, .8,.9,.95)
schedkwhen(kBT,0,0, "Bass",0,kp3,-9,kBTP[(kBTS+2)%8]*2, .8,.9,.95)
schedkwhen(kBT,0,0, "Bass",0,kp3,-9,kBTP[(kBTS+3)%8]*2, .8,.9,.95)
endin

instr Out
;kCO = linseg(20, 2, 10000, 2, 20, 1, 10000)
;kFB = linseg(10, 4, 60, 2, 40)
;ga_sbus[2][0] diode_ladder ga_sbus[2][0], kCO, 10, 1, kFB
;ga_sbus[2][1] diode_ladder ga_sbus[2][1], kCO, 10, 1, kFB

aL, aR sbus_out
;kSM = linseg(1, p3/2, .01, p3/2, 1)
kSM = 1
aL limit aL, -kSM, kSM
aR limit aR, -kSM, kSM
outs aL, aR
sbus_clear_all
endin
</CsInstruments>
<CsScore>
i"Verb" 0 -1
i"Main" 0 [2*184*(60/170)]
i"Out"  0 [2*186*(60/170)]
e
</CsScore>
</CsoundSynthesizer>

