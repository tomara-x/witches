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

instr kick
iifrq   = 230
iefrq   = 20
aaenv   expsegr 1,p3,1,0.3,0.001
afenv   expsegr iifrq,p3,iifrq,0.05,iefrq
asig    oscili aaenv*.6, afenv
asig    distort asig*2, 0.2, giftanh
asig    limit asig, -0.5,0.5
asig    += moogladder(asig, iifrq*2, .3)
outs    asig, asig
gaRvbSend += asig*0.03
endin

instr hat
aenv    expsegr 1,p3,1,0.25,0.001
asig    noise   0.1*aenv, -0.9
outs    asig, asig
gaRvbSend += asig*0.06
endin

instr pluck1
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
schedkwhen kt1[kAS1], 0,0, "pluck1", 0, p4, kp[kAS2], p18, p19, p20, p21
endin

instr 2
ktrig   metro $TEMPO*p4/60
kcnt[]  fillarray p5, p6, p7, p8
kAS1, kt1[] utBasemath ktrig, kcnt
knote[] fillarray p9,  p10, p11, p12
kgain[] fillarray p13, p14, p15, p16
kQ[]    fillarray 0, 0, 0, 0
kAS2, kp[], kt2[] Taphath kt1[kAS1], knote, kgain, kQ, gicm2
kfrq    = kp[kAS2]
ktens   = p17
iatt    = p18
kvibf   = p19
kvamp   = p20/100
asig    wgbrass 0.1, kfrq*2^p22, ktens, iatt, kvibf, kvamp
asig    *=1
gaRvb2Send += asig*p23
        outs asig, asig
endin

instr awoo
kamp = transegr(0,p3/10,0, 1,p3,0, 0)
kfrq = transegr(375,p3/10,0, 400,p3,0, 330)
a1      oscili kamp*0.8, kfrq
a2      oscili kamp*0.9, kfrq*2
a3      oscili kamp*0.9, kfrq*3
a4      oscili kamp*0.1, kfrq*4
a5      oscili kamp*0.1, kfrq*5
a6      oscili kamp*0.1, kfrq*6
aout    = a1+a2+a3+a4+a5+a6
aout *= 0.1
gaRvb2Send += aout*0.3
outs aout, aout
endin
</CsInstruments>
<CsScore>
;read the manual, amy! <- Pfft! Manuaals! Who does that?!
t 0 86
i"awoo" 0 8

;;          xf  Count        Notes        Trans        Tn  At  Vf  Va  Oc Rv
;i2  +   64 04  08 02 01 01  21 13 42 04  00 01 07 00  .35 .1  .05 10  04 .1

;;           P3 xf  Count        Notes        Trans        RD PR Ds Pl
;i1  +   16 .01 36  08 02 01 06  06 10 11 04  00 01 .5 .2  .6 .8 00 .2
;i1  +   08 .80 09  04 02 01 02  21 13 42 04  00 01 07 00  .3 .8 .2 .2
;i1  +   08 .02 18  04 02 01 02  21 13 42 04  00 01 07 00  .3 .1 .2 .2
;i1  +   16 .40 09  04 02 01 02  14 17 49 12  01 01 03 01  .3 .1 .4 .2
e
</CsScore>
</CsoundSynthesizer>

