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

#define TEMPO #131#
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
    aSig pdhalf aSig, -0.7
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
if p9 == 1 then
    aSig    diode_ladder aSig, p5*8, 10, 1, 10
endif
aEnv    linseg 0, 0.002, 1, p3-0.013, 1, 0.005, 0
aSig *= aEnv
sbus_mix 2, aSig*db(-3)
gaVerbInL += aSig*db(-24)
gaVerbInR += aSig*db(-24)
endin

instr Snare ;lol
ifn ftgenonce 0,0,2^10, -7, -1, 2^8, 1, 2^8, 0, 2^8, 1, 2^8, -1
aSig pluck p4, p5, 15000, ifn, 3, .5
sbus_mix 3, aSig*db(-9), aSig*db(-3)
gaVerbInL += aSig*db(-6)
gaVerbInR += aSig*db(-6)
endin

instr Bambo
aSig bamboo p4, p3, 50, .01, .0, 407, 268, 790
aSig limit aSig, -.5, .5
sbus_mix 4, aSig*db(-6), aSig*db(-3)
gaVerbInL += aSig*db(-6)
gaVerbInR += aSig*db(-6)
endin

instr Crunch
aSig crunch p4, p3, 50, .9;, .001
;aSig limit aSig, -.1, .1
sbus_mix 5, aSig*db(-6), aSig*db(-3)
gaVerbInL += aSig*db(-3)
gaVerbInR += aSig*db(-3)
endin

instr Hat
aSig noise p4, p5
aEnv expseg 1, p3, db(-60)
aSig *= aEnv
sbus_mix 6, aSig*db(-9), aSig*db(-3)
gaVerbInL += aSig*db(-6)
gaVerbInR += aSig*db(-6)
endin

instr Cabasa
aSig cabasa p4, p3, 1000
sbus_mix 7, aSig*db(-6), aSig*db(-3)
gaVerbInL += aSig*db(-3)
gaVerbInR += aSig*db(-3)
endin

instr Bar
endin

gaVerbInL,gaVerbInR init 0
instr Verb
kRoomSize   init      0.65     ; room size (range 0 to 1)
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
;drums------------------------------
ib = 60/$TEMPO ;duration of one beat
kDT     metro $TEMPO/60 ;DrumTrigger
kDC[]   fillarray 1, 1, 1, 1
kDBS, kDBT[] utBasemath kDT, kDC
schedkwhen(kDBT[0],0,0, "Kick",0,ib, 0.09, 230, 40, 1)
schedkwhen(kDBT[1],0,0, "Bambo",0,ib, .1)
schedkwhen(kDBT[2],0,0, "Crunch",0,ib, .1)

schedkwhen(kDBT[3],0,0, "Cabasa",0*ib/3/5,ib/3/5, .1)
schedkwhen(kDBT[3],0,0, "Cabasa",1*ib/3/5,ib/3/5, .1)
schedkwhen(kDBT[3],0,0, "Cabasa",2*ib/3/5,ib/3/5, .1)
schedkwhen(kDBT[3],0,0, "Cabasa",3*ib/3/5,ib/3/5, .1)
schedkwhen(kDBT[3],0,0, "Cabasa",4*ib/3/5,ib/3/5, .1)

schedkwhen(kDBT[3],0,0, "Cabasa",1*ib/3,ib/3, .2)
;schedkwhen(kDBT[3],0,0, "Cabasa",1*ib/3+ib/6,ib/3/2, .1)
schedkwhen(kDBT[3],0,0, "Cabasa",2*ib/3,ib/3, .1)
;bass------------------------------
kFrq  = $TEMPO*4/60
kBT   metro kFrq ;BassTrigger
iBS ftgenonce 0,0,-7*3,-51, 7,2,cpspch(6), 0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12) ;BassScale
kBN[] fillarray 1, 1, 1, 0, 2, 4, 4, 3  ;BassNotes
kBG[] fillarray 0, 2, 0, 0, 0, 1, 0, 2  ;BassGain (transposition)
kBQ[] fillarray 0, 0, 0, 0, 0, 0, 0, 0  ;BassQueue
kBTS, kBTP[], kBTT[] Taphath kBT, kBN,kBG,kBQ, iBS
kp3 = 1/kFrq
;schedkwhen(kBTT[0],0,0, "Bass",0,kp3,-9,kBTP[0], .8,.9,.9)
;schedkwhen(kBTT[3],0,0, "Bass",0,kp3,-9,kBTP[3], .7,.9,.9)
;schedkwhen(kBTT[5],0,0, "Bass",0,kp3,-9,kBTP[5], .8,.9,.8, 1)
;schedkwhen(kBTT[6],0,0, "Bass",0,kp3,-9,kBTP[6], .8,.7,.9)
endin

instr Out
;kCF = randomi(20, 10000, .5)
;kSa = randomi(1, 80, .8)
;kFB = randomi(0, 17, .2)
;ga_sbus[2][0] diode_ladder ga_sbus[2][0], kCF, kFB, 1, kSa
;ga_sbus[2][1] diode_ladder ga_sbus[2][1], kCF, kFB, 1, kSa

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
i"Main" 0 [64*(60/131)]
i"Out"  0 [68*(60/131)]
e
</CsScore>
</CsoundSynthesizer>

