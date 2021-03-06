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
#include "../sequencers.orc"
#include "../oscillators.orc"
#include "../utils.orc"
#include "../function-tables.orc"
#include "../effects/send-effects.orc"
alwayson "taphy"

instr taphy
ktrig   metro $TEMPO*4/60
knote[] fillarray 23, 21, 22, 02, 14, 21, 09, 32
kgain[] fillarray .5, 02, 01, 00, 04, 00, -2, 00
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm4, 0, ClkDiv(kt[0], 8)
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

instr 2
aop1, aop2, aop3, aop4, aop5, aop6, aop7, aop8 init 0
aop1    Pmoscili p04, gkcps/p12, gifsaw
aop2    Pmoscili p05, gkcps/p13
aop3    Pmoscili p06, gkcps/p14, aop1+aop2
aop4    Pmoscili p07, gkcps/p15, aop1+aop2
aop5    Pmoscili p08, gkcps/p16, aop1+aop2
aop6    Pmoscili p09, gkcps/p17, mirror(aop3*4, -1, 1) ;look, mom, wavefolding!
aop7    Pmoscili p10, gkcps/p18, aop4, gifsqur
aop8    Pmoscili p11, gkcps/p19, aop5
aout    = aop6 + aop7 + aop8
aout    = aout * 0.1
gaRvbSend += aout*0.05
outs    aout, aout
endin

instr 3
aop1, aop2, aop3, aop4, aop5, aop6, aop7, aop8 init 0
aop1    Pmoscili p04, gkcps/p12, aop8
aop2    Pmoscili p05, gkcps/p13, aop1
aop3    Pmoscili p06, gkcps/p14, aop2
aop4    Pmoscili p07, gkcps/p15, aop3
aop5    Pmoscili p08, gkcps/p16, aop4
aop6    Pmoscili p09, gkcps/p17, aop5
aop7    Pmoscili p10, gkcps/p18, aop6
aop8    Pmoscili p11, gkcps/p19, aop7
aout    = (aop1+aop2+aop3+aop4+aop5+aop6+aop7+aop8)/2
aout    = aout * 0.1
gaRvbSend += aout*0.05
outs    aout, aout
endin


instr dust
aout dust .5, 10
gaRvbSend += aout*0.1
outs aout, aout
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
i3      +   08  .1 .2 .0 .0 .0 .5 .2 .5  002 002 001 004 004 004 004 008
i3      +   08  .1 .2 .0 .0 .0 .5 .4 .5  002 002 001 004 004 004 004 008
i3      +   08  .1 .2 .1 .1 .1 .5 .4 .5  002 002 001 004 004 004 004 008
i3      +   08  .1 .2 .8 .2 .1 .5 .5 .5  .50 004 002 004 004 008 004 004
i3      +   08  .1 .2 .8 .2 .1 .5 .5 .5  002 001 004 004 004 .25 004 002
i3      +   08  .1 .2 .8 .2 .1 .5 .5 .5  001 004 008 004 004 016 004 001
i3      +   08  .1 .4 .2 .1 .4 .5 .5 .5  .50 004 008 004 004 016 016 001
i"kick" ^+8 0.00001
i3      +   08  .2 .4 .2 .1 .4 .5 .5 .5  .50 008 008 004 004 016 016 001
i3      +   08  .1 .2 .1 .1 .1 .5 .5 .5  002 001 008 004 004 002 004 001
i"kick" ^+2 0.00001
i"kick" ^+6 0.00001
i3      +   08  .1 .4 .2 .1 .4 .5 .5 .5  .50 004 008 004 004 016 016 001
i"kick" ^+8 0.00001
i3      +   08  .1 .4 .2 .1 .4 .5 .5 .5  .50 004 008 004 004 016 016 001
i"kick" ^+8 0.00001
i"kick" ^+1 0.00001
i3      +   08  .1 .4 .2 .1 .4 .5 .5 .5  .50 004 008 004 004 016 016 001
i3      +   08  .1 .8 .2 .4 .2 .5 .5 .5  .50 008 008 004 008 016 016 002
i3      +   08  .1 .2 .1 .1 .2 .5 .5 .5  .50 008 002 016 004 016 016 002
i3      +   08  .1 .2 .1 .1 .2 .5 .5 .5  .50 008 002 016 004 016 016 002
e
</CsScore>
</CsoundSynthesizer>

