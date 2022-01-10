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

#define TEMPO #64#
#include "../opcodes.orc"
#include "../function-tables.orc"
#include "../send-effects.orc"
alwayson "taphy"

instr taphy
ktrig   metro $TEMPO/60
knote[] fillarray 00, 07, 03, 40, 02, 00, 02, 00
kgain[] fillarray 01, 02, 03, 04, 05, 06, 07, 08
kQ[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm4
gkcps = kp[kAS]*4
endin

instr tweet
klfo1   lfo 600, 5+gkcps/256
klfo2   lfo 300, gkcps/256
asig    poscil 1, gkcps+klfo1;, gifsqur
aout    rbjeq asig, 40+gkcps+klfo2, 4, 8, 1, 4
aout    = aout * 0.1
gaRvbSend += aout*0.08
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
;read the manual, amy! <- Haha! Never!
t 0 64
i"tweet" + 128
;i"kick" ^+2 0.00001
e
</CsScore>
</CsoundSynthesizer>

