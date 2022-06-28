//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//Defensive Cargoes
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
#include "../oscillators.orc"

gay, gal, gar init 0

instr Grain
seed 113

kTrig    metro $FRQ*p6
kCount[] fillarray p26, p27
kBS, kBT[] utBasemath kTrig, kCount

;7-tone blues
iScale ftgenonce 0,0,-7*3,-51, 7,2,cpspch(p7+4),0,
1,2^(3/12),2^(4/12),2^(5/12),2^(6/12),2^(7/12),2^(10/12)
kNote[]  fillarray p18,p19,p20,p21
kTrans[] fillarray p22,p23,p24,p25
kQueue[] init 4
kS, kP[], kT[] Taphath kBT[kBS], kNote, kTrans, kQueue, iScale

kGFrq = kP[kS]
kGPhs = 0
kFMD = randomi(0, 1, $FRQ/4)
kPMD = 0
if p11 == 0 then
    kGDur = randomi($BEAT/p12, $BEAT/p13, $FRQ*p14)
    kGDens = randomi($FRQ*p15, $FRQ*p16, $FRQ*p17)
elseif p11 == 1 then
    kGDur = randomh($BEAT/p12, $BEAT/p13, $FRQ*p14)
    kGDens = randomh($FRQ*p15, $FRQ*p16, $FRQ*p17)
elseif p11 == 2 then
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
elseif p8 == 2 then
    aSig *= (1 - phasor:a($FRQ*p6)) ;linear
endif
if p9 == 1 then
    aSig pdhalf aSig, -0.8 
endif
if p10 == 1 then
    iTanh ftgenonce 0,0,2^10+1,"tanh", -5, 5, 0
    aSig distort aSig, .8, iTanh
endif
aSig diode_ladder aSig, 8000, 1, 1
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
i"Out"   0       [8*16]
;basma count ----------------------------------------------------------------------------------------------+
;taphy transposition ---------------------------------------------------------------------------+          |
;taphy notes -----------------------------------------------------------------------+           |          |
;frequency of randomization -----------------------------------------------------+  |           |          |
;minimum, maximum of rand density factor ($FRQ*factor) ------------------+---+   |  |           |          |
;frequency of randomization -----------------------------------------+   |   |   |  |           |          |
;minimum, maximum of rand duration factor ($BEAT/factor) ----+---+   |   |   |   |  |           |          |
;silly preset (0 randomi, 1 randomh 2 no random) -------+    |   |   |   |   |   |  |           |          |
;waveshap distortion ------------------------------+    |    |   |   |   |   |   |  |           |          |
;pd half distortion --------------------------+    |    |    |   |   |   |   |   |  |           |          |
;messy env (0 sustained, 1 exp, 2 linear) +   |    |    |    |   |   |   |   |   |  |           |          |
;octave ------------------------------+   |   |    |    |    |   |   |   |   |   |  |           |          |
;clock multiplier (1 = $FRQ) -----+   |   |   |    |    |    |   |   |   |   |   |  |           |          |
;stereo pan ----------------+     |   |   |   |    |    |    |   |   |   |   |   |  |           |          |
;amp (no grain overlap) -+  |     |   |   |   |    |    |    |   |   |   |   |   |  |           |          |
;note duration --+       |  |     |   |   |   |    |    |    |   |   |   |   |   |  |           |          |
;note start -+   |       |  |     |   |   |   |    |    |    |   |   |   |   |   |  |           |          |
;            |   |       |  |     |   |   |   |    |    |    |   |   |   |   |   |  |           |          |
;            v   v       v  v     v   v   v   v    v    v    v   v   v   v   v   v  v           v          v
;        start   dur     db pan   clk oct env dist more mode Dum DuM f   Dem DeM f  note        trans      count
i"Grain" [0*16]  [8*16] -06 0.50  2   8   0   0    0    1    128 8   32  8   2   32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [1*16]  [7*16] -06 0.50  2   2   0   0    0    2    128 8   32  8   2   32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [2*16]  [6*16] -06 0.50  2   8   0   0    0    1    128 8   32  8   2   32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [3*16]  [5*16] -06 0.50  2   1   0   0    0    2    128 8   32  8   2   32 15 15 00 03 7  7 -7  7 4 2
s

t 0 113
i"Out"   0       [14*16+4]
;        start   dur     db pan   clk oct env dist more mode Dum DuM f   Dim DiM f  note        trans      count
i"Grain" [0*16]  [2*16] -06 0.50  2   8   0   1    1    0    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2

i"Grain" [2*16]  [2*16] -09 0.50  2   8   0   1    1    0    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [2*16]  [2*16] -09 0.50  2   9   0   1    1    0    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2

i"Grain" [4*16]  [2*16] -09 0.50  2   8   0   1    1    0    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [4*16]  [2*16] -09 0.50  2   9   0   1    1    0    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [4*16]  [2*16] -12 0.50  2   2   0   1    1    2    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2

i"Grain" [6*16]  [6*16] -09 0.50  2   8   0   1    1    0    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [6*16]  [4*16] -09 0.50  2   9   1   1    1    1    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [6*16]  [8*16] -12 0.50  2   2   0   1    1    2    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2
i"Grain" [6*16]  [8*16] -12 0.50  2   0   0   1    1    2    128 8   32  2   16  32 15 15 00 03 7  7 -7  7 4 2
s

e
</CsScore>
</CsoundSynthesizer>

