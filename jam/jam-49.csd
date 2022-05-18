//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #131#
#define FRQ #$TEMPO/60#
#define Beat #1/$FRQ#

#include "../sequencers.orc"
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
if pcount() > 8 then
    aSig diode_ladder aSig, p5*8, p9, 1, p10
endif
aEnv    linseg 0, 0.002, 1, p3-0.013, 1, 0.005, 0
aSig *= aEnv
sbus_mix 2, aSig*db(-3)
gaVerbInL += aSig*db(-24)
gaVerbInR += aSig*db(-24)
endin

instr Grain
seed 420 ;good for the environment
iScale ftgenonce 0,0,-7*4,-51, 7,2,cpspch(6), 0,
1,2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
kGFrq = table(randomh:k(0, 7*4, $FRQ/4), iScale)
;kGFrq = table(rspline(0, 7*4, $FRQ/16, $FRQ), iScale)
kGPhs = 0
kFMD = randomi(0, 1, $FRQ/4)
kPMD = .0
kGDur = randomi(0.01, .7, $FRQ/4)
kGDens = randomi(3, 16, $FRQ/2)
iMaxOvr = 20
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.1,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,kGPhs, kFMD,kPMD, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
;aSig pdhalf aSig, randomi:k(-.9, -.4, $FRQ/4)
iTanh ftgenonce 0,0,2^10+1,"tanh", -5, 5, 0
aSig distort aSig, randomi:k(.05, .4, $FRQ/4), iTanh
aSig *= db(-24)
sbus_mix 3, aSig*db(-6)
gaVerbInL += aSig*db(-12)
gaVerbInR += aSig*db(-12)
endin
schedule("Grain", 0, -1)

gaVerbInL,gaVerbInR init 0
instr Verb
kRoomSize   init      0.65     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
aVerbL,aVerbR freeverb gaVerbInL,gaVerbInR,kRoomSize,kHFDamp
sbus_mix 15, aVerbL, aVerbR
clear gaVerbInL,gaVerbInR
endin

instr Out
aL, aR sbus_out
kSM = 1
aL limit aL, -kSM, kSM
aR limit aR, -kSM, kSM
outs aL, aR
sbus_clear_all
endin
</CsInstruments>
<CsScore>
i"Verb" 0 -1
i"Out"  0 [4*64*(60/131)]
e
</CsScore>
</CsoundSynthesizer>

