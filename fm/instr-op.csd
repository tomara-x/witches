//trans rights
//Copyright © 2022 Amy Universe
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

#define TEMPO #113#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#

#include "../sequencers.orc"
#include "../utils.orc"

gay, gal, gar init 0

instr Taphy
iScale ftgenonce 0,0,-7*3,-51, 7, 2, cpspch(6), 0,
1,2^(2/12),2^(4/12),2^(5/12),2^(7/12),2^(9/12),2^(11/12) ;omfg! major key!
kTrig    metro $FRQ*4
kNote[]  fillarray 1, 2, 3, 4, 2, 2, 0, 1,  1,1,1,1,1,1,1,1
kTrans[] fillarray 0, 0, 0, 0, 0, 0, 0, 0,  0,0,0,0,0,0,0,0
kQueue[] init 16
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale
gkTaphy = kP[kS]
endin

gaOps[] init 16
gkFrq[] init 16
instr Op
;what's even the point if i can't be with my beloved nor write to global a-sigs?
;setksmps 1
aEnv  linseg 0, p4+0.0001, p5, p6, p5, p7, 0
aphs  init 0
acar  phasor gkFrq[p10]*p8
if pcount() > 10 then
    kcnt = 11
    while kcnt <= pcount() do
        aphs += gaOps[p(kcnt)]
        kcnt += 1
    od
endif
asig  tablei acar+aphs, p9, 1,0,1
gaOps[p10] = asig*aEnv
endin
instr Algo ;i know! use schedkwhen + multiple metros... bohahaha!
;                      att  hldA  hldT   rel    Rat   FT   car    mods
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  00,    01
schedule "Op", 0, p3,  0,  .1,    .8,    .5,    01,   -1,  01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  02,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    .5,   -1,  03,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  04,    01
schedule "Op", 0, p3,  0,   1,     5,    .5,    01,   -1,  05,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  06,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  07,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  08,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  09,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  10,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  11,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  12,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  13,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  14,    01
schedule "Op", 0, p3,  0,   1,    .5,    .5,    01,   -1,  15,    01
gkFrq = gkTaphy ;taphy pitch to entire array
gay += (gaOps[5] + gaOps[3] + gaOps[1])*db(-18)
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
i"Out"   0 10
i"Taphy" 0 10
i"Algo"  0 10
e
</CsScore>
</CsoundSynthesizer>


