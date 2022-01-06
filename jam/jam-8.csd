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
knote[] fillarray 38, 10, 08, 02, 14, 21, 09, 32
kgain[] fillarray 00, 00, 01, 00, 04, 00, -2, 00
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm4
kcps    = kp[kAS]*4
aop1    Pmoscili lfo((p04+1)/2,$TEMPO*p12/60,p20), kcps/p28, aop1*.8
aop2    Pmoscili lfo((p05+1)/2,$TEMPO*p13/60,p21), kcps/p29
aop3    Pmoscili lfo((p06+1)/2,$TEMPO*p14/60,p22), kcps/p30, aop1+aop2
aop4    Pmoscili lfo((p07+1)/2,$TEMPO*p15/60,p23), kcps/p31, aop1+aop2
aop5    Pmoscili lfo((p08+1)/2,$TEMPO*p16/60,p24), kcps/p32, aop1+aop2
aop6    Pmoscili lfo((p09+1)/2,$TEMPO*p17/60,p25), kcps/p33, aop3
aop7    Pmoscili lfo((p10+1)/2,$TEMPO*p18/60,p26), kcps/p34, aop4+aop7*0.5
aop8    Pmoscili lfo((p11+1)/2,$TEMPO*p19/60,p27), kcps/p35, aop5
aout    = aop6 + aop7 + aop8
aout    = aout * 0.1
;gaRvbSend += aout*0.3
outs    aout, aout
endin

instr dust
aout dust .5, 10
gaRvbSend += aout*0.1
outs aout, aout
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
i1  +  16  .1  .2  .8  .2  .1  .5  .5  .5   \
           .02 .01 .02 .03 .01 .10 .01 .01  \
            1   5   2   5   1   1   4   2   \
           .25  2   1   4   4   2   4   8
e
</CsScore>
</CsoundSynthesizer>

