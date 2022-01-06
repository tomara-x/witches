//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
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
gaRvbSend init 0
alwayson "verb"

instr 1
ktrig   metro $TEMPO*4/60
knote[] fillarray 23, 26, 08, 02, 14, 21, 09, 32
kgain[] fillarray .5, 02, 01, 00, 04, 00, -2, 00
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm4
kcps    = kp[kAS]*4
aop1    Pmoscili p04, kcps/p12, aop1*.8
aop2    Pmoscili p05, kcps/p13
aop3    Pmoscili p06, kcps/p14, aop1+aop2
aop4    Pmoscili p07, kcps/p15, aop1+aop2
aop5    Pmoscili p08, kcps/p16, aop1+aop2
aop6    Pmoscili p09, kcps/p17, aop3
aop7    Pmoscili p10, kcps/p18, aop4+aop7*0.5
aop8    Pmoscili p11, kcps/p19, aop5
aout    = aop6 + aop7 + aop8
aout    = aout * 0.1
gaRvbSend += aout*0.2
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
gaRvbSend += asig*0.03
endin

instr verb ;reverb (stolen from the floss manual 05E01_freeverb.csd)
kroomsize    init      0.85         ; room size (range 0 to 1)
kHFDamp      init      0.5          ; high freq. damping (range 0 to 1)
aRvbL,aRvbR  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aRvbL, aRvbR
             clear     gaRvbSend
endin
</CsInstruments>
<CsScore>
;read the manual, amy!
t 0 128
i1  +  08  .1 .2 .0 .0 .0 .5 .2 .5  002 002 001 004 004 004 004 008
i1  +  08  .1 .2 .8 .2 .1 .5 .5 .5  .50 004 002 004 004 008 004 004
i1  +  08  .1 .2 .8 .2 .1 .5 .5 .5  002 001 004 004 004 .25 004 002
i1  +  08  .1 .2 .8 .2 .1 .5 .5 .5  001 004 008 004 004 016 004 001
i1  +  08  .1 .4 .2 .1 .4 .5 .5 .5  .50 004 008 004 004 016 016 001
i1  +  08  .2 .4 .2 .1 .4 .5 .5 .5  .50 008 008 004 004 016 016 001
i1  +  08  .1 .2 .1 .1 .1 .5 .5 .5  002 001 008 004 004 002 004 001
i"kick" ^+8 0.00001
i1  +  08  .1 .4 .2 .1 .4 .5 .5 .5  .50 004 008 004 004 016 016 001
i"kick" ^+8 0.00001
i1  +  08  .1 .4 .2 .2 .4 .5 .5 .5  .50 004 008 008 004 016 016 001
e
</CsScore>
</CsoundSynthesizer>

