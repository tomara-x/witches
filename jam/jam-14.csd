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
kg1[]   fillarray 10, 02, 00, 02, 03, 00, 00, 00
kQ1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn1[]  fillarray 36, 36, 36, 36, 36, 36, 36, 36
kmx1[]  fillarray 60, 60, 60, 60, 60, 60, 60, 60
kAS1, kp1[], kt1[] Taphath ktrig, kn1, kg1, kQ1, kmn1, kmx1, gi12tet

asig adsynt2 0.1, kp1[kAS1]/4, gifsin, gifreqfn, giampfn, 64
kn = 0
;while kn < 64 do
;    tablew(randomi:k(0, .05, 5), kn, giampfn)
;    tablew(randomi:k(1, 8, 1), kn, gifreqfn)
;    kn += 1
;od
tablew(randomi:k(0, .1, 5), randomi:k(0,64, 8), giampfn)
tablew(ceil(randomi:k(1, 8, 1)), randomi:k(0,64, 5), gifreqfn)

outs asig, asig
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
i"taphy1" 0 128
</CsScore>
</CsoundSynthesizer>

