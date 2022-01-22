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
kg1[]   fillarray 00, 02, 00, 00, 00, 00, 00, 00
kQ1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn1[]  fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmx1[]  fillarray 14, 24, 14, 14, 14, 35, 35, 35
kft init giud4
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ1, /*kmn1, kmx1,*/ kft, 0, 0, 2
asig oscil .05, kp1[kAS1]
outs asig, asig
;schedkwhen kt1[kAS1], 0,0, "", 0, 0.5, kp1[kAS1]
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
</CsInstruments>
<CsScore>
t 0 128
i"taphy1" 0 128
</CsScore>
</CsoundSynthesizer>

