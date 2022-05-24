//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//testing Pmoscili2
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
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
knote[] fillarray 00, 00, 00, 00, 00, 00, 00, 00
kgain[] fillarray 01, 02, 03, 04, 05, 06, 07, 08
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm2
gkcps = kp[kAS]*4
endin
instr 1
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
aop1    poscil  p04, gkcps/p12 + phasor(gkcps/p12)
aop2    poscil  p05, gkcps/p13 
aop3    poscil  p06, gkcps/p14 + phasor(gkcps/p14)
aop4    poscil  p07, gkcps/p15 + phasor(gkcps/p15)
aop5    poscil  p08, gkcps/p16 + phasor(gkcps/p16)
aop6    poscil  p09, gkcps/p17 + phasor(gkcps/p17)
aop7    poscil  p10, gkcps/p18 + phasor(gkcps/p18)
aop8    poscil  p11, gkcps/p19 + phasor(gkcps/p19)
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
t 0 128
i2      +   28  .1 .2 .0 .0 .0 .5 .4 .5  002 002 001 004 004 004 004 008
i2      +   28  .1 .2 .1 .1 .1 .5 .4 .5  002 002 001 004 004 004 004 008
i"kick" ^+28 0.00001
i2      +   28  .1 .4 .2 .1 .4 .5 .5 .5  .50 004 008 004 004 016 016 001
i"kick" ^+28 0.00001
i2      +   28  .2 .4 .2 .1 .4 .5 .5 .5  .50 008 008 004 004 016 016 001
i"kick" ^+28 0.00001
i2      +   28  .1 .2 .1 .1 .1 .5 .5 .5  002 001 008 004 004 002 004 001
i"kick" ^+28 0.00001
i2      +   28  .1 .2 .0 .0 .0 .5 .2 .5  002 002 001 004 004 004 004 008
e
</CsScore>
</CsoundSynthesizer>

