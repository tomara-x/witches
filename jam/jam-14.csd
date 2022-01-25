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

instr taphy1
ktrig   metro $TEMPO*4/60
kn1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kg1[]   fillarray 00, 16, 08, 00, 24, 08, 00, 16
kQ1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn1[]  fillarray 36, 36, 36, 36, 36, 36, 36, 36
kmx1[]  fillarray 60, 60, 60, 84, 84, 60, 60, 84
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ1, kmn1, kmx1, gi12tet, 0, 0, 2

asig1 adsynt2 0.1, kp1[kAS1]/4, gifsin, gifreqfn, giampfn, 64

ii = 0
while ii < 64 do
    tablew(0.05, ii, giampfn)
    ii += 1
od

ii = 0
ival1 = p4
ival2 = p5
while ii < 32 do
    tablew(ival1, ii, gifreqfn)
    tablew(ival2, ii+32, gifreqfn)
    ii += 1
    ival1 += p6
    ival2 += p7
od

asig = asig1
outs asig, asig
;gaRvbSend += asig*0.2
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
i"taphy1" 0 64 1 8 1 0.1
</CsScore>
</CsoundSynthesizer>

