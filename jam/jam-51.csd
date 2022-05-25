//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;hail satan
;hail satan tonight
;hail satan
;hail hail
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
;#include "../utils.orc"
gay, gal, gar init 0

instr Grain
seed 420 ;good for the environment
iScale ftgenonce 0,0,-7*4,-51, 10,4,cpspch(6), 0,
2^(00/12),2*2^(00/12),
2^(02/12),2*2^(02/12),
2^(05/12),2*2^(05/12),
2^(08/12),2*2^(08/12),
2^(10/12),2*2^(10/12)
kTrig    metro $FRQ*4
;4 step
kNote[]  fillarray 0,  1,  3,  2;,  2,  4,  4,  4
kTrans[] fillarray 1,  1,  3,  0;,  0,  1,  9,  6
kQueue[] fillarray 0,  0,  0,  0;,  0,  0,  0,  0
kMin[]   fillarray 0,  0,  0,  0;,  0,  0,  14, 0
kMax[]   fillarray 32, 32, 32, 32;, 32, 32, 32, 32
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, kMin, kMax, iScale
kGFrq = kP[kS]/2
kGPhs = (lfo:k(1, $FRQ*1, 4)+1)/2
kFMD = randomi(0, 1, $FRQ/4)
kPMD = .0
kGDur = 1/kI[kS]
kGDens = kI[kS]
iMaxOvr = 50
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.1,0, 4,.05,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,kGPhs, kFMD,kPMD, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
aSig pdhalf aSig, randomi:k(-.8, -.4, $FRQ/4)
iTanh ftgenonce 0,0,2^10+1,"tanh", -5, 5, 0
aSig distort aSig, (lfo:k(.8, $FRQ)+1)/2, iTanh
aSig diode_ladder aSig, 10000, 1, 1
gay += aSig*db(-6)
gaSp += aSig*db(-3)
endin

gaSp init 0
instr Sp
idep    =  3    /* early reflection depth       */
ift ftgenonce   1, 0, 64, -2,                                   \
		/* depth1, depth2, max delay, IR length, idist, seed */ \
		idep, 48, -1, 0.01, 0.25, 123,                          \
		1, 21.982, 0.05, 0.87, 4000.0, 0.6, 0.7, 2, /* ceil  */ \
		1,  1.753, 0.05, 0.87, 3500.0, 0.5, 0.7, 2, /* floor */ \
		1, 15.220, 0.05, 0.87, 5000.0, 0.8, 0.7, 2, /* front */ \
		1,  9.317, 0.05, 0.87, 5000.0, 0.8, 0.7, 2, /* back  */ \
		1, 17.545, 0.05, 0.87, 5000.0, 0.8, 0.7, 2, /* right */ \
		1, 12.156, 0.05, 0.87, 5000.0, 0.8, 0.7, 2  /* left  */
aW,aX,aY,aZ spat3d gaSp, 7, 6, 8, 5, ift, 1, 2, 2
gal += aW
gar += aY
clear gaSp
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
;i"Sp"     0 -1
i"Grain"  0 -1
i"Out"    0 [4*64*(60/113)]
e
</CsScore>
</CsoundSynthesizer>

