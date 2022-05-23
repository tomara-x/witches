//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
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
#include "../opcodes.orc"
#include "../function-tables.orc"
#include "../effects/send-effects.orc"
alwayson "taphy"

instr taphy
ktrig   metro $TEMPO*4/60
;lol finally started to "Buffer uderrun in RT audio out" with 16384 long arrs!
;this is done on a 1.8GHz octa-core cpu (running on proot so i think single thread)
knote[] init 2^14
kgain[] init 2^14
kQ[]    init 2^14
knote   genarray 0, 2^14
kgain   genarray 0, 2^14
kQ      genarray 0, 2^14
print(lenarray(kQ))
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm2
gkcps = kp[kAS]*4
endin
instr 1
;setksmps 1 ;messes up the global sends of course, but for some reason the kick too
aop1, aop2, aop3, aop4, aop5, aop6, aop7, aop8 init 0
aop1    Pmoscili p04, gkcps/p12, aop1*.8
aop2    Pmoscili p05, gkcps/p13
aop3    Pmoscili p06, gkcps/p14, aop1+aop2
aop4    Pmoscili p07, gkcps/p15, aop1+aop2
aop5    Pmoscili p08, gkcps/p16, aop1+aop2
aop6    Pmoscili p09, gkcps/p17, aop3
aop7    Pmoscili p10, gkcps/p18, aop4+aop7*0.5
aop8    Pmoscili p11, gkcps/p19, aop5
aout    = aop6 + aop7 + aop8
aout    = aout * 0.1
gaRvbSend += aout*0.05
outs    aout, aout
endin

instr kick
iifrq   = 230
iefrq   = 20
aaenv   expsegr 1,p3,1,0.5,0.001
afenv   expsegr iifrq,p3,iifrq,0.05,iefrq
asig    oscili aaenv*.6, afenv
asig    distort asig*2, 0.2, giftanh
asig    limit asig, -0.5,0.5
asig    += moogladder(asig, iifrq*2, .3)
outs    asig, asig
gaRvbSend += asig*0.05
endin
</CsInstruments>
<CsScore>
;read the manual, amy!
t 0 128
i1      +   28  .1 .2 .0 .0 .0 .5 .4 .5  002 002 001 004 004 004 004 008
i1      +   28  .1 .2 .1 .1 .1 .5 .4 .5  002 002 001 004 004 004 004 008
i"kick" ^+28 0.00001
i1      +   28  .1 .4 .2 .1 .4 .5 .5 .5  .50 004 008 004 004 016 016 001
i"kick" ^+28 0.00001
i1      +   28  .2 .4 .2 .1 .4 .5 .5 .5  .50 008 008 004 004 016 016 001
i"kick" ^+28 0.00001
i1      +   28  .1 .2 .1 .1 .1 .5 .5 .5  002 001 008 004 004 002 004 001
i"kick" ^+28 0.00001
i1      +   28  .1 .2 .0 .0 .0 .5 .2 .5  002 002 001 004 004 004 004 008
e
</CsScore>
</CsoundSynthesizer>

