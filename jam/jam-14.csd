//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

// Don't mind me, just testing sequencers over here
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   2
0dbfs   =   1

#define TEMPO #256#
#include "../function-tables.orc"
#include "../opcodes.orc"
#include "../send-effects2.orc"
alwayson "verb"
;alwayson "verb2"
alwayson "dist"
alwayson "dist2"
;alwayson "taphy"

instr taphy1
ktrig   metro $TEMPO/4/60
kn1[]   fillarray 05, 00, 00, 00, 00, 00, 00, 00
kn2[]   fillarray 00, 00, 10, 20, 00, 30, 00, 13
kn3[]   fillarray 17, 10, 08, 13, 09, 00, 16, 23
kg1[]   fillarray 21, 07, 11, 03, 15, 14, 00, 06
kg2[]   fillarray 21, 07, -8, 03, 15, 14, 00, 06
kg3[]   fillarray 21, 07, 02, 03, 15, 14, 00, 06
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ, gism4
kAS2, kp2[], kt2[] Taphath ktrig, kn2, kg2, kQ, gism4
kAS3, kp3[], kt3[] Taphath ktrig, kn3, kg3, kQ, gism4

;pluck a string                                       RD   Rl   Ds   Pl
schedkwhen kt1[kAS1], 0,0, "pluck", 0, 01, kp1[kAS1], 0.5, 0.9, 0.1, 0.2
schedkwhen kt2[kAS2], 0,0, "pluck", 0, 01, kp2[kAS2], 0.5, 0.9, 0.1, 0.2
schedkwhen kt3[kAS3], 0,0, "pluck", 0, 01, kp3[kAS3], 0.5, 0.9, 0.1, 0.2
/*
;send to another instr
gkcps[] init 3
kn = 2
gkcps[0] = tlineto(kp1[kn], 0.1, kt1[kn])
gkcps[1] = tlineto(kp2[kn], 0.2, kt2[kn])
gkcps[2] = tlineto(kp3[kn], 0.3, kt3[kn])
*/
; Q mode (0=reset, 1=keep)
kQ[kAS1] = kQ[kAS1] * 0
; sigil
;knote[4] = knote[4]+kt[2]
;kgain[2] = kgain[2]+kt[4]
;kgain[5] = kgain[5]+kt[4]*2
kQ[2]    = kQ[2]+ClkDiv(kt1[4], 2)
kQ[5]    = kQ[5]+ClkDiv(kt1[3], 3)
kQ[0]    = kQ[0]+ClkDiv(kt1[4], 6)
kQ[7]    = kQ[7]+ClkDiv(kt1[4], 3)
kQ[6]    = kQ[6]+ClkDiv(kt1[4], 5)
endin
instr taphy2
ktrig   metro $TEMPO/60
kn1[]   fillarray 05, 00, 00, 00, 00, 00, 00, 00
kg1[]   fillarray 21, 07, -8, 03, 15, 14, 00, 06
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmin[]    fillarray 00, 00, 00, 00, 00, 21, 21, 21
kmax[]    fillarray 14, 14, 14, 14, 14, 35, 35, 35
kfn = gism6
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ, kmin, kmax, kfn
schedkwhen kt1[kAS1], 0,0, "pluck", 0, 0.2, kp1[kAS1], 0.6, 0.2, 0.0, 0.01
endin
instr taphy3
ktrig   metro $TEMPO/60
kn1[]   fillarray 05, 00, 00, 00, 00, 00, 00, 00
kg1[]   fillarray 21, 07, -8, 03, 15, 14, 00, 06
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ, gism2
kQ[kAS1] = kQ[kAS1] * 0
kQ[2]    = kQ[2]+ClkDiv(kt1[4], 2)
kQ[5]    = kQ[5]+ClkDiv(kt1[3], 3)
kQ[0]    = kQ[0]+ClkDiv(kt1[4], 6)
kQ[7]    = kQ[7]+ClkDiv(kt1[4], 3)
kQ[6]    = kQ[6]+ClkDiv(kt1[4], 5)
;schedkwhen kt1[kAS1], 0,0, "pluck", 0, 0.2, kp1[kAS1]*2, 0.6, 0.2, 0.0, 0.01
asig1    oscili .01, tlineto(kp1[kAS1]*2^3, 0.01, kt1[kAS1])
asig2    oscili asig1, tlineto(kp1[kAS1]*2^4, 0.01, kt1[kAS1])
aout = asig2
gaRvb2Send += aout*0.5
outs aout, aout
endin

instr fm
iz = 0.00001
aenv    expsegr 1, p3, 1, 2, iz
kfreq = p4
aop1, aop2 init 0
aop1    Pmoscili 0.1, kfreq/2, aop1*0.2
aop2    Pmoscili 0.1, kfreq, aop1
aout = aop2*0.2
aout *= aenv
gaRvbSend += aout*0.1
outs aout, aout
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
asig *= 0.5
outs    asig, asig
gaRvbSend += asig*0.15
endin

instr hat
aenv    expsegr 1,p3,1,0.07,0.001
asig    noise   0.06*aenv, -0.9
outs    asig, asig
asig *= 0.1
gaRvbSend += asig*0.2
endin

instr pluck
iplk    =           p8 ;(0 to 1)
kamp    init        0.1
icps    =           p4
kpick   init        0.8 ;pickup point
krefl   init        p5 ;rate of decay? ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl
;asig    rbjeq       asig, 200, 2, 0, 8, 10
kenv2   linsegr     0,0.005,1,p3,1,p6,0 ;declick
asig    *=          kenv2
        outs        asig,asig
gaDst2Send += asig*p7
gaRvbSend += asig*0.3
endin

instr taphy4
ktrig   metro $TEMPO*p5/60
kcnt[]  fillarray p6, p7, p8, p9
kAS1, kt1[] utBasemath ktrig, kcnt
knote[] fillarray p10, p11, p12, p13
kgain[] fillarray p14, p15, p16, p17
kQ[]    fillarray 0, 0, 0, 0
kAS2, kp[], kt2[] Taphath kt1[kAS1], knote, kgain, kQ, gism4
schedkwhen kt1[kAS1], 0,0, "pluck", 0, p4, kp[kAS2], p18, p19, p20, p21
endin

</CsInstruments>
<CsScore>
;mixer ops, amy! (and amp converters)
t 0 256
;i"taphy1" 32 256
i"taphy2" 0 256
;i"taphy3" 00 256
;;                  P3 xf   Count        Notes        Trans        RD PR Ds Pl
;i"taphy4"  +   32 .80 009  16 08 04 08  21 13 42 04  00 01 07 00  .3 .8 .1 .2
;i"taphy4"  +   32 .02 018  16 08 04 08  21 13 42 04  00 01 07 00  .3 .1 .1 .2
;i"taphy4"  +   32 .40 009  16 08 04 08  14 17 49 12  01 01 03 01  .3 .1 .2 .2
</CsScore>
</CsoundSynthesizer>

