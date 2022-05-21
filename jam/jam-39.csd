//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;stop looking for the ultimate setup, just enjoy the jam!
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231 ;-m97
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #110#
#include "../sequencers.orc"
#include "../oscillators.orc"
#include "../mixer.orc"
#include "../utils.orc"

instr Kick
;;the holy kick (for good luck)
;itanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
;iifrq, iefrq = 230, 20
;aaenv   expseg 1,p3,0.001
;afenv   expseg iifrq,0.05,iefrq
;asig    oscili aaenv*.6, afenv
;asig    distort asig*2, 0.2, itanh
;asig    limit asig, -0.5,0.5
;asig    += moogladder(asig, iifrq*2, .3)

;p4, p5, p6, p7 : freq decay, freq[i], freq[f], effect
iIFrq, iEFrq = p5, p6
aAEnv   expseg 1,p3,0.0001
aFEnv   expseg iIFrq,p4,iEFrq
aSig    oscili aAEnv, aFEnv
if p7 == 1 then
    aSig pdhalf aSig, -0.8
endif
aEnv    linseg 0, p3*0.05, 1, p3*0.9, 1, p3*0.05, 0
aSig *= aEnv
sbus_mix 1, aSig*ampdb(-3)
gaVerbInL += aSig*ampdb(-12)
gaVerbInR += aSig*ampdb(-12)
endin

instr Bass
iPlk    =    p6 ;(0 to 1)
kAmp    =    ampdb(p4)
iCps    =    p5 ;cpspch(p5)
kPick   =    p7 ;pickup point
kRefl   =    p8 ;rate of decay ]0,1[
aSig    wgpluck2 iPlk,kAmp,iCps,kPick,kRefl
aSig    diode_ladder aSig, p5*4, 1, 1, 10
aEnv    linseg 0, p3*0.05, 1, p3*0.9, 1, p3*0.05, 0
aSig *= aEnv
sbus_mix 2, aSig*ampdb(-3)
gaVerbInL += aSig*ampdb(-12)
gaVerbInR += aSig*ampdb(-12)
endin

gkAmp[] init 16
gkRat[] init 16
instr FM10
kCps = p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili gkAmp[00], kCps*gkRat[00], aOp08+aOp09+aOp13
aOp01   Pmoscili gkAmp[01], kCps*gkRat[01], aOp00
aOp02   Pmoscili gkAmp[02], kCps*gkRat[02], aOp03
aOp03   Pmoscili gkAmp[03], kCps*gkRat[03], aOp01+aOp04+aOp05
aOp04   Pmoscili gkAmp[04], kCps*gkRat[04], aOp00
aOp05   Pmoscili gkAmp[05], kCps*gkRat[05], aOp00
aOp06   Pmoscili gkAmp[06], kCps*gkRat[06], aOp03
aOp07   Pmoscili gkAmp[07], kCps*gkRat[07], aOp03
aOp08   Pmoscili gkAmp[08], kCps*gkRat[08], aOp12
aOp09   Pmoscili gkAmp[09], kCps*gkRat[09], aOp12
aOp10   Pmoscili gkAmp[10], kCps*gkRat[10], aOp15
aOp11   Pmoscili gkAmp[11], kCps*gkRat[11], aOp15
aOp12   Pmoscili gkAmp[12], kCps*gkRat[12], aOp10+aOp11+aOp14
aOp13   Pmoscili gkAmp[13], kCps*gkRat[13], aOp12
aOp14   Pmoscili gkAmp[14], kCps*gkRat[14], aOp15
aOp15   Pmoscili gkAmp[15], kCps*gkRat[15]
aSig = aOp02+aOp06+aOp07
;p3-time declick (doesn't scale with p3)
sbus_mix 3, aSig*ampdb(-3)
gaVerbInL += aSig*ampdb(-12)
gaVerbInR += aSig*ampdb(-12)
endin

gaVerbInL,gaVerbInR init 0
instr Verb
kRoomSize   init      0.55     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
aVerbL,aVerbR freeverb gaVerbInL,gaVerbInR,kRoomSize,kHFDamp
sbus_mix 15, aVerbL, aVerbR
clear gaVerbInL,gaVerbInR
endin

;instr am
;anoise noise 1, .5
;atrig mpulse 1, 1/kf
;asig samphold anoise, atrig
;asig tone asig, kff
;endin

instr Main
;the sacred timeline
kBarN       init 0 ;number of current bar (zero indexed)
kBar        metro $TEMPO/4/60 ;click every 4th beat
kBarN += kBar
kCount[]    fillarray 2, 2, 4, 2, 8, 4, 2, 4
kGain[]     fillarray 0, 0, 0, 0, 0, 0, 0, 0
kQueue[]    fillarray 0, 0, 0, 0, 0, 0, 0, 0
kS, kTL[]   tBasemath kBar, kCount, kGain, 1, 17, kQueue ;Section# and TimeLine array
kQueue[kS] = 0
;TEST QUEUE LOOPS, AMY!

;kick------------------------------
kKT metro $TEMPO/60 ;KickTrigger
if kS == 0 then
    schedkwhen(kKT,0,0, "Kick",0,1, 0.08, 230, 40)
elseif kS > 4 then
    schedkwhen(kKT,0,0, "Kick",0,1, 0.09, 230, 40, 1)
endif
;bass------------------------------
kFrq  = $TEMPO*8/60
kBT   metro kFrq ;BassTrigger
kBC[] fillarray 3, 1, 3, 1, 2, 2, 2, 2 ;BassCount
kBBS, kBBT[] utBasemath kBT, kBC ;BassBasmaStep, BassBasmaTrigger array
iBS ftgenonce 0,0,-7*3,-51, 7,2,cpspch(6), 0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12) ;BassScale
kBN[] fillarray 3, 20, 4, 3, 6, 7, 8, 0 ;BassNotes
kBG[] fillarray 0, 1, 0, 2, 0, 1, 0, 0  ;BassGain (transposition)
kBQ[] fillarray 0, 0, 0, 0, 0, 0, 0, 0  ;BassQueue
kBTS, kBTP[], kBTT[] Taphath kBBT[kBBS] ,kBN,kBG,kBQ, iBS
kp3 = kBC[kBBS]/kFrq
kp5 = kBTP[kBTS]
schedkwhen(kBBT[kBBS],0,0, "Bass",0,kp3,.5,kp5, .85,.9,.9)
endin

instr Out
aL, aR sbus_out
iSM = .5
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM
outs aL, aR
;kFade linseg 1, p3-10, 1, 10, 0
;outs aL*kFade, aR*kFade
sbus_clear_all
endin
</CsInstruments>
<CsScore>
i"Verb" 0 -1
i"Main" 0 [228*(60/110)]
i"Out"  0 [228*(60/110)]
e
</CsScore>
</CsoundSynthesizer>

