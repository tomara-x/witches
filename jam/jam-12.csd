//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

// Wolf, Wyoming
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   2
0dbfs   =   1

#define TEMPO #86#
#include "../opcodes.orc"
#include "../function-tables.orc"
#include "../send-effects.orc"
alwayson "taphy"

instr taphy
ktrig   metro $TEMPO*4/60
knote[] fillarray 00, 00, 00, 00, 00, 00, 00, 00
kgain[] fillarray 01, 00, -4, 03, -1, -9, 00, 03
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm6
gkcps = kp[kAS]*4

; Q mode (0=reset, 1=keep)
kQ[kAS] = kQ[kAS] * 0
; sigil
knote[4] = knote[4]+kt[2]
kgain[2] = kgain[2]+kt[4]
kgain[5] = kgain[5]+kt[4]*2
kQ[2]    = kQ[2]+ClkDiv(kt[4], 2)
kQ[5]    = kQ[5]+ClkDiv(kt[3], 3)
kQ[0]    = kQ[0]+ClkDiv(kt[4], 6)
kQ[7]    = kQ[7]+ClkDiv(kt[4], 3)
kQ[6]    = kQ[6]+ClkDiv(kt[4], 5)
endin

instr kick
iifrq   = 230
iefrq   = 20
aaenv   expsegr 1,0.5,0.001
afenv   expsegr iifrq,p3,iifrq,0.05,iefrq
asig    oscili aaenv*.6, afenv
asig    distort asig*2, k(aaenv)*0.4, giftanh
asig    limit asig, -0.5,0.5
asig    += moogladder(asig, iifrq*2, .3)
outs    asig, asig
gaRvbSend += asig*0.06
endin

instr hat
aenv    expsegr 1,p3,1,0.25,0.001
asig    noise   0.06*aenv, -0.9
outs    asig, asig
gaRvbSend += asig*0.06
endin

instr awoo
kamp = transegr(0,p3/10,0, 1,p3,0, 1,p3*2,0, 0)
kfrq = transegr(375,p3/10,0, 400,p3,0, 400,p3*2,0, 330) + randomi(-2,0,4)
a1      oscili randomi(0.9,1.0,4), kfrq
a2      oscili randomi(0.5,0.8,5), kfrq*2
a3      oscili randomi(0.4,0.6,6), kfrq*3
a4      oscili randomi(0.0,0.05,6), kfrq*4
a5      oscili randomi(0.0,0.03,4), kfrq*5
a6      oscili randomi(0.0,0.02,4), kfrq*6
;as = oscili(linseg(1,p3/2,0)*randomi(0.01,0.05,8), kfrq/2)
aout    = kamp*(a1+a2+a3+a4+a5+a6)
aout *= 0.1
gaRvb2Send += aout*0.3
outs aout, aout
endin

instr pluck
iplk    =           p8 ;(0 to 1)
kamp    init        0.15
icps    =           p4
kpick   init        0.8 ;pickup point
krefl   init        p5 ;rate of decay? ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl
kenv2   linsegr     0,0.003,1,p3,1,p6,0 ;declick
asig    *=          kenv2
        outs        asig,asig
gaDstSend += asig*p7
gaRvbSend += asig*0.2
endin

instr 1
ktrig   metro $TEMPO*p5/60
kcnt[]  fillarray p6, p7, p8, p9
kAS1, kt1[] utBasemath ktrig, kcnt
knote[] fillarray p10, p11, p12, p13
kgain[] fillarray p14, p15, p16, p17
kQ[]    fillarray 0, 0, 0, 0
kAS2, kp[], kt2[] Taphath kt1[kAS1], knote, kgain, kQ, gicm4
schedkwhen kt1[kAS1], 0,0, "pluck", 0, p4, kp[kAS2], p18, p19, p20, p21
endin

instr 2
km1 = p4
km2 = p5
ksep = p6
ix, iy, iz = p7, p8, p9
ivx,ivy,ivz = p10,p11,p12
idelta = p13
ifric = p14
ax, ay, az planet km1,km2, ksep, ix,iy,iz, ivx,ivy,ivz, idelta, ifric
aop1, aop2, aop3, aop4 init 0
aop1    Pmoscili limit(ax,-1000,1000)*0.00025, gkcps/1, aop1*.8
aop2    Pmoscili limit(ay,-1000,1000)*0.00025, gkcps/2
aop3    Pmoscili limit(az,-1000,1000)*0.00025, gkcps/4, aop1+aop2
aop4    Pmoscili 0.1, gkcps/8, aop3
aop5    Pmoscili 0.1, gkcps/2, aop3
klfo    lfo 1, $TEMPO*8/60, 5
kenv    linsegr 1,p3,1,p15,0
aout = (aop4+aop5)*(klfo+1)/2
aout *= kenv
outs aout, aout
endin
</CsInstruments>
<CsScore>
;Mixer ops, amy!
t 0 86
;              M1   M2   Sep  I[XYZ]       V[XYZ]       Delta   Fric R
i2   0   64    46   26   002  044 046 018  107 014 020  0.1410  7.6  8
;Wolf, Wyoming   Feet         °   '   " N  °   '   " W  Meters  UTC

i"awoo" 0 4

;my deepest apologies for the following
{ 32 CNT
i"kick" [32+$CNT*0.5] 0.0001
}
{ 32 CNT
i"hat" [32+16+$CNT*0.25] 0.0001
}

;;           P3 xf  Count        Notes        Trans        RD PR Ds Pl
;i1  +   16 .01 02  08 04 01 01  06 10 11 04  00 01 .5 .2  .6 .8 00 .2
;i1  +   16 .01 36  08 02 01 06  06 10 11 04  00 01 .5 .2  .6 .8 00 .2
;i1  +   08 .80 09  04 02 01 02  21 13 42 04  00 01 07 00  .3 .8 .2 .2
;i1  +   08 .02 18  04 02 01 02  21 13 42 04  00 01 07 00  .3 .1 .2 .2
;i1  +   08 .40 09  04 02 01 02  14 17 49 12  01 01 03 01  .3 .1 .4 .2
e
</CsScore>
</CsoundSynthesizer>

