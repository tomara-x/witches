//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//i have a thing in mind this time
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #113#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#

#include "../sequencers.orc"
gay, gal, gar init 0

instr Grain
seed 113
iScale ftgenonce 0,0,-31*3,-51, 31,2,cpspch(p7+4),0,
2^(00/31),2^(01/31),2^(02/31),2^(03/31),
2^(04/31),2^(05/31),2^(06/31),2^(07/31),
2^(08/31),2^(09/31),2^(10/31),2^(11/31),
2^(12/31),2^(13/31),2^(14/31),2^(15/31),
2^(16/31),2^(17/31),2^(18/31),2^(19/31),
2^(20/31),2^(21/31),2^(22/31),2^(23/31),
2^(24/31),2^(25/31),2^(26/31),2^(27/31),
2^(28/31),2^(29/31),2^(30/31)
kTrig    metro $FRQ*p6
kCount[] fillarray  4, 4, 2, 8, 8, 2, 2, 4,  8, 8, 2, 1, 4, 2, 1, 4,
                    4, 4, 2, 8, 8, 2, 2, 4,  8, 8, 2, 1, 4, 2, 1, 4
kBS, kBT[] utBasemath kTrig, kCount

kNote[]  fillarray 15,15, 0, 3,15,15, 7,15, 15,15, 0, 4,15,15, 8, 3,
                   15,15, 0, 3,15,15,15,15, 15,15, 0, 4,15,15,15, 3
kTrans[] init 32 
kQueue[] init 32
kR[]     init 32

kS, kP[], kT[], kI[] Taphath kBT[kBS], kNote, kTrans, kQueue, iScale

if kR[0]%4 == 0 && kR[0] != 0 && kT[0] == 1 then
;there should be a cleaner way to force assign at k-time without them silly k()
    kTrans fillarray k(8), 3, 9, 3, 0, 0, 0, 2,  0, 0, 6, 0, 0, 6,31, 0,
                        0,31, 0,-9, 0,31, 2, 1,  2, 4,-3,31, 0,31, 0, 3
elseif kT[0] == 1 then
    kTrans fillarray k(8), 7, 9, 6, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,
                        0, 0, 0, 0, 0, 0, 0, 0,  6,14, 0, 0, 0, 0, 0, 0
endif
kR[kS] = kR[kS] + kT[kS]


kGFrq = kP[kS]
kGPhs = 0
kFMD = randomi(0, 1, $FRQ/4)
kPMD = .1
if p11 == 0 then
    kGDur = randomi($BEAT/128, $BEAT/2, $FRQ*4)
    ;kGDens = randomi(1/kGDur, 16/kGDur, $FRQ*8)
    kGDens = randomi($FRQ*16, $FRQ*32, $FRQ*8)
elseif p11 == 1 then
    kGDur = 1/kP[kS]
    kGDens = kP[kS]
endif
iMaxOvr = 32
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,kGPhs, kFMD,kPMD, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
if p8 == 1 then
    aSig *= (1 - phasor:a($FRQ*p6))^2 ;envelope (long story)
endif
if p9 == 1 then
    aSig pdhalf aSig, -0.8 
endif
if p10 == 1 then
    iTanh ftgenonce 0,0,2^10+1,"tanh", -5, 5, 0
    aSig distort aSig, .8, iTanh
endif
aSig diode_ladder aSig, 10000, 1, 1
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-6)
gaVerbR += ar*db(-6)
endin

gaVerbL,gaVerbR init 0
instr Verb
kRoomSize  init  0.85 ; room size (range 0 to 1)
kHFDamp    init  0.9  ; high freq. damping (range 0 to 1)
denorm gaVerbL, gaVerbR
aVerbL,aVerbR freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp
gal += aVerbL
gar += aVerbR
clear gaVerbL,gaVerbR
endin

instr Out
kSM = 1
gal limit gal+gay, -kSM, kSM
gar limit gar+gay, -kSM, kSM
outs gal, gar
clear gay, gal, gar
endin
</CsInstruments>
<CsScore>
i"Verb"  0      -1 ;reverb always running

t 0 113 ;tempo = 113bpm
i"Out"   0      [1*64]
;        start  dur     db pan    clk  oct  env dist more  mode
i"Grain" 0      [1*64] -06 0.50   .5   3    0   0    0     1
i"Grain" 0      [1*64] -03 0.55   4    2    0   0    0     1
i"Grain" 0      [1*64] -06 0.45   4    5    0   0    0     1
s ;end section

t 0 113
i"Out"   0      [8*64+2]
;        start  dur     db pan    clk  oct  env dist more  mode
i"Grain" 0      [8*64] -12 0.50   .5   2    0   0    0     0
i"Grain" 0      [8*64] -12 0.50   .5   3    0   0    0     0
i"Grain" 0      [8*64] -03 0.55   1    0    0   0    0     0
i"Grain" 0      [1*64] -06 0.45   1    5    0   0    0     0
i"Grain" [1*64] [1*64] -12 0.45   1    5    0   1    1     0
i"Grain" [2*64] [1*64] -06 0.45   1    6    0   0    0     0
i"Grain" [3*64] [5*64] -06 0.45   1    8    0   0    1     0
s

t 0 113
i"Out"   0      [1*64]
;        start  dur     db pan    clk  oct  env dist more  mode
i"Grain" [0*64] [1*64] -06 0.50   .5   3    0   0    0     1
i"Grain" [0*64] [1*64] -03 0.55   4    8    0   0    0     1
i"Grain" [0*64] [1*64] -06 0.45   4    5    0   0    0     1
s

t 0 113
i"Out"   0      [8*64+4]
;        start  dur     db pan    clk  oct  env dist more  mode
i"Grain" 0      [8*64] -12 0.50   .5   2    0   0    0     0
i"Grain" 0      [8*64] -12 0.50   .5   3    0   0    0     0
i"Grain" 0      [8*64] -03 0.55   4    0    0   0    0     0
i"Grain" 0      [8*64] -12 0.45   4    5    0   1    1     0
e
</CsScore>
</CsoundSynthesizer>

