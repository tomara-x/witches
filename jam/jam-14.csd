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

instr taphy1
ism ftgenonce 0,0,-7*10,-51, 7,2,cpspch(4),0,
2^(0/12),2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
ktrig   metro $TEMPO*4/60
kn1[]   fillarray 00, 05, 11, 11, 00, 00, 05, 05
kg1[]   fillarray 02, 02, 01, 01, 02, 02, 02, 02
kQ1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn1[]  fillarray 21, 21, 20, 20, 21, 21, 21, 21
kmx1[]  fillarray 41, 41, 37, 37, 41, 41, 41, 41
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ1, kmn1, kmx1, ism, 0, 0, p5

ifn1 ftgenonce 0,0,64, 10, 1
;ifn2 ftgenonce 0,0,64, 7, 1, 64, 1
ifnamp ftgenonce 0,0,64,-24, ifn1, 0, 0.05 ;rescale
ifnfrq ftgenonce 0,0,64,-7, 1, 32,1.00004, 0,16, 32,16.256
asig1 adsynt2 0.1, kp1[kAS1]*p4/2, gifsin, ifnfrq, ifnamp, 64

aout = asig1
outs aout, aout
gaBCrushSend += aout*0.2
gaRvbSend += aout*0.3
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
i"taphy1" +  16 .5 0
i"taphy1" +  32  4 0
i"taphy1" +  32 .5 2
i"taphy1" 48 32  4 2
i"taphy1" 80 32  1 2
i"taphy1" 80 32  8 2
e
</CsScore>
</CsoundSynthesizer>

