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
#include "../mixer.orc"

instr Grain
seed 420 ;good for the environment
iScale ftgenonce 0,0,-7*4,-51, 7,2,cpspch(6), 0,
1,2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
;kGFrq = table(randomi:k(0, 7*4, $FRQ/4), iScale)
kGFrq = table(rspline(0, 7*4, $FRQ/16, $FRQ), iScale)
kGPhs = 0
kFMD = randomi(0, 1, $FRQ/4)
kPMD = .0
kGDur = randomh(0.01, .7, $FRQ/4)
kGDens = randomh(3, 16, $FRQ/2)
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

