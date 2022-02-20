//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231 ;-t128
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #40#
#include "../opcodes.orc"
#include "../modular-effects.orc"

instr basma
ktrig       metro $TEMPO*8/60
kc[]        fillarray 03, 01, 03, 01, 02, 02, 02, 02
kg[]        fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn[]       fillarray 01, 01, 01, 01, 01, 01, 01, 01
kmx[]       fillarray 08, 08, 08, 08, 08, 08, 08, 08
kQ[]        fillarray 00, 00, 00, 00, 00, 00, 00, 00
gk_basma_AS, gk_basma_t[] tBasemath ktrig, kc, kg, kmn, kmx, kQ
endin

instr taphy
iscale ftgenonce 0,0,-7*10,-51, 7,2,cpspch(p6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12) ;I need a diff scale
gk_t2_trig init 0
gk_taphy_n[]    fillarray 00, 05, 11, 11, 00, 00, 05, 05
gk_taphy_g[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
gk_taphy_Q[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
gk_taphy_mn[]   fillarray 21, 21, 21, 21, 21, 21, 21, 21
gk_taphy_mx[]   fillarray 48, 48, 48, 48, 48, 48, 48, 48
gk_taphy_AS, gk_taphy_p[], kt[] Taphath gk_t2_trig, gk_taphy_n, gk_taphy_g, 
        gk_taphy_Q, gk_taphy_mn, gk_taphy_mx, iscale, p4, 0, p5
endin

gk_fm_amp[] init 8
gk_fm_cps[] init 8
instr fm
aop1    Pmoscili gk_fm_amp[0], gk_fm_cps[0]
aop2    Pmoscili gk_fm_amp[1], gk_fm_cps[1],  aop1
aop3    Pmoscili gk_fm_amp[2], gk_fm_cps[2],  aop1
aop4    Pmoscili gk_fm_amp[3], gk_fm_cps[3],  aop1
aop5    Pmoscili gk_fm_amp[4], gk_fm_cps[4],  aop2+aop3+aop4
aop6    Pmoscili gk_fm_amp[5], gk_fm_cps[5],  aop5
aop7    Pmoscili gk_fm_amp[6], gk_fm_cps[6],  aop5
aop8    Pmoscili gk_fm_amp[7], gk_fm_cps[7],  aop5
ga_fm_out = (aop6 + aop7 + aop8)
endin

instr kick
itanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
iifrq   = 230
iefrq   = 40
aaenv   expsegr 1,1.1,0.0001
afenv   expsegr iifrq,p3,iifrq,0.06,iefrq
asig    oscili aaenv*.6, afenv
asig    distort asig, k(aaenv)*0.2, itanh
asig    limit asig, -0.5,0.5
asig    += moogladder(asig, iifrq*2, .3)
ga_kick_out = asig*0.5
endin

instr drum
aenv1 expsegr 1, p4, 0.0001
aenv2 expsegr 1, p5, 0.0001
aenv3 expsegr 1, p6, 0.0001
aop1  Pmoscili aenv1, p7
aop2  Pmoscili aenv1, p8
aop3  Pmoscili aenv1, p9, aop1+aop2
ga_drum_out = aop3*0.1
endin

;instr granny ;use partikkel
;
;endin

instr patch
gk_t2_trig = gk_basma_t[gk_basma_AS]
;gk_fm_cps = gk_taphy_p ;setting frequency of each operator to each node's output
ga_verb_in = ga_kick_out*0.1

kkicktrig = gk_basma_t[0]+gk_basma_t[4]
schedkwhen(kkicktrig, 0,0, "kick", 0, 0.0001)

kdrumtrig = gk_basma_t[gk_basma_AS]-(gk_basma_t[2]+gk_basma_t[4]+gk_basma_t[7])
kd1 = trandom(kdrumtrig,0.1,5)
kd2 = trandom(kdrumtrig,0.1,4)
kd3 = trandom(kdrumtrig,0.1,2)
schedkwhen(kdrumtrig,0,0,"drum",0,0.0001, kd1,kd2,kd3, 440, 55, 220)

endin

instr mix
aoutl = ga_kick_out+ga_verb_outl
aoutr = ga_kick_out+ga_verb_outr

aoutl += ga_drum_out
aoutr += ga_drum_out
outs aoutl, aoutr
endin

instr sched
schedule("basma", 0, -1)
schedule("patch", 0, -1)
schedule("mix", 0, -1)
schedule("verb",0,-1)

;iv1[] fillarray 3.7, 7, 8, 9
;icnt = 0
;while icnt < 4 do
;    schedule("i1", 0, 1, iv1[icnt])
;od

ktrig1   metro $TEMPO*8/60
kc1[]    fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS1, kt1[]   utBasemath ktrig1, kc1

endin
schedule("sched", 0, -1)
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>

