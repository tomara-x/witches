//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

// you! wiggle some body parts!
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   2
0dbfs   =   1

#define TEMPO #128#
#include "../function-tables.orc"
#include "../opcodes.orc"
#include "../send-effects2.orc"
alwayson "verb"
;alwayson "verb2"
;alwayson "dist"
;alwayson "dist2"
alwayson "bcrush"

instr taphy1 ;imma revisit this additive biz later
ism ftgenonce 0,0,-7*10,-51, 7,2,cpspch(4),0,
2^(0/12),2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
ktrig   metro $TEMPO*4/60
kn1[]   fillarray 00, 05, 11, 11, 00, 00, 05, 05
kg1[]   fillarray 02, 02, 01, 01, 02, 02, 02, 02
kQ1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn1[]  fillarray 21, 21, 20, 20, 21, 21, 21, 21
kmx1[]  fillarray 41, 41, 37, 37, 41, 41, 41, 41
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ1, kmn1, kmx1, ism, p6, 0, p7

;ifn1 ftgenonce 0,0,64, 10, 1,1,0, 3,.5,.2
ifnamp ftgenonce 0,0,64,-7, 0.05, 64, 0.05
ifnfrq ftgenonce 0,0,64,-7, 1, 64, 1
asig1 adsynt 0.1*p4, kp1[kAS1]*p5/2, gifsin, ifnfrq, ifnamp, 8
if kt1[kAS1] == 1 then
    tablew(table(kAS1,ifnfrq)+1,kAS1,ifnfrq)
endif

aout = asig1
outs aout, aout
gaBCrushSend += aout*0.2
gaRvbSend += aout*0.3
endin

instr taphy2
ism ftgenonce 0,0,-7*10,-51, 7,2,cpspch(p22),0,
2^(0/12),2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
ktrig   metro $TEMPO*4/60
kn1[]   fillarray 00, 05, 11, 11, 00, 00, 05, 05
kg1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kQ1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn1[]  fillarray 21, 21, 21, 21, 21, 21, 21, 21
kmx1[]  fillarray 48, 48, 48, 48, 48, 48, 48, 48
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ1, kmn1, kmx1, ism, p4, 0, p5
kn1[0] = kn1[0] + kt1[2]*6
kn1[2] = kn1[2] + kt1[6]

kcps = kp1[kAS1]
ke1     linseg p6,p3/($TEMPO/60),p7
ke2     linseg p8,p3/($TEMPO/60),p9
ke3     linseg p10,p3/($TEMPO/60),p11
ke4     linseg p12,p3/($TEMPO/60),p13
aop1    Pmoscili p14, kcps*2^ke1
aop2    Pmoscili p15, kcps*2^ke2,   aop1
aop3    Pmoscili p16, kcps/8,       aop1
aop4    Pmoscili p17, kcps/1,       aop1
aop5    Pmoscili p18, kcps*2^ke3,   aop2+aop3+aop4
aop6    Pmoscili p19, kcps/4,       aop5
aop7    Pmoscili p20, kcps*2^ke4,   aop5
aop8    Pmoscili p21, kcps/2,       aop5

aout = (aop6 + aop7 + aop8)
outs aout, aout
;gaBCrushSend += aout*0.2
gaRvbSend += aout*0.2
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
</CsInstruments>
<CsScore>
t 0 128
;                SM LM  1i 1f 2i 2f 3i 3f 4i 4f op1             op5             R
i"taphy2" +  32  0  0   -4 02 08 -4 -4 02 -8 03 .14 .04 .04 .08 .01 .02 .02 .02 4
i"taphy2" +  32  0  0   -4 02 08 -4 -4 02 -8 03 .14 .04 .04 .08 .05 .02 .02 .02 4

i"taphy2" +  32  0  0   -4 02 08 -4 -4 02 -8 03 .04 .04 .04 .04 .05 .04 .01 .04 4
i"taphy2" +  32  1  0   -4 02 08 -4 -4 02 -8 03 .04 .04 .04 .04 .04 .04 .01 .04 4
i"taphy2" +  08  2  0   -4 02 08 -4 -4 02 -8 03 .04 .04 .04 .20 .04 .02 .01 .02 3
i"taphy2" +  08  0  2   02 02 -4 -4 02 02 03 03 .54 .04 .04 .04 .50 .02 .01 .02 2
i"taphy2" +  08  0  2   02 02 -4 -4 02 02 03 03 .04 .04 .04 .04 .50 .02 .01 .03 2
e
</CsScore>
</CsoundSynthesizer>

