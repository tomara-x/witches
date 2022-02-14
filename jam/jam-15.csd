//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//modular instruments
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
#include "../modular-effects.orc"

instr base
ktrig       metro $TEMPO*4/60
kc[]        fillarray 00, 05, 11, 11, 00, 00, 05, 05 ;lmao if I'm gonna calculate
kg[]        fillarray 00, 00, 00, 00, 04, 00, 00, 00 ;these and make sure my notes
kmn[]       fillarray 02, 02, 02, 02, 02, 02, 02, 02 ;fit into bars and shit
kmx[]       fillarray 16, 16, 08, 08, 08, 08, 08, 08
kQ[]        fillarray 00, 00, 00, 00, 00, 00, 00, 00
kAS, kt[]   tBasemath ktrig, kc, kg, kmn, kmx, kQ
gk_base_trig = kt[kAS]
endin

instr t2
iscale ftgenonce 0,0,-7*10,-51, 7,2,cpspch(p6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
gk_t2_trig init 0
kn1[]   fillarray 00, 05, 11, 11, 00, 00, 05, 05
kg1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kQ1[]   fillarray 00, 00, 00, 00, 00, 00, 00, 00
kmn1[]  fillarray 21, 21, 21, 21, 21, 21, 21, 21
kmx1[]  fillarray 48, 48, 48, 48, 48, 48, 48, 48
kAS1, kp1[], kt1[] Taphath gk_t2_trig, kn1, kg1, kQ1, kmn1, kmx1, iscale, p4, 0, p5
kn1[0] = kn1[0] + kt1[2]*6
kn1[2] = kn1[2] + kt1[6]
gk_t2_cps = kp1[kAS1]
endin

instr fm
gk_fm_cps init 440
kcps = gk_fm_cps
ke1     linseg p4,p3/($TEMPO/60),p5
ke2     linseg p6,p3/($TEMPO/60),p7
ke3     linseg p8,p3/($TEMPO/60),p9
ke4     linseg p10,p3/($TEMPO/60),p11
aop1    Pmoscili p12, kcps*2^ke1
aop2    Pmoscili p13, kcps*2^ke2,   aop1
aop3    Pmoscili p14, kcps/8,       aop1
aop4    Pmoscili p15, kcps/1,       aop1
aop5    Pmoscili p16, kcps*2^ke3,   aop2+aop3+aop4
aop6    Pmoscili p17, kcps/4,       aop5
aop7    Pmoscili p18, kcps*2^ke4,   aop5
aop8    Pmoscili p19, kcps/2,       aop5
ga_t2_out = (aop6 + aop7 + aop8)
endin

instr kick
itanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
iifrq   = 230
iefrq   = 20
aaenv   expsegr 1,1.1,0.001
afenv   expsegr iifrq,p3,iifrq,0.08,iefrq
asig    oscili aaenv*.6, afenv
asig    distort asig*2, k(aaenv)*0.4, itanh
asig    limit asig, -0.5,0.5
asig    += moogladder(asig, iifrq*2, .3)
ga_kick_out = asig*0.5
endin

instr bform
ga_bform_in init 0
kalpha lfo 360, 0.04
kbeta init 0
aw, ax, ay, az bformenc1 ga_bform_in, kalpha, kbeta
ga_bform_outl, ga_bform_outr bformdec1 1, aw, ax, ay, az
endin

instr patch
schedule("base", 0, -1)
gk_t2_trig = gk_base_trig
gk_fm_cps = gk_t2_cps
endin
schedule("patch", 0, -1)

instr mix
schedule("verb",0,-1)
ga_verb_in = ga_t2_out*0.5+ga_kick_out*0.3
;aoutl = ga_t2_out+ga_kick_out+ga_verb_outl
;aoutr = ga_t2_out+ga_kick_out+ga_verb_outr
schedule("bform",0,-1)
ga_bform_in = ga_t2_out
aoutl = ga_bform_outl+ga_kick_out+ga_verb_outl
aoutr = ga_bform_outr+ga_kick_out+ga_verb_outr
outs aoutl, aoutr
endin
schedule("mix", 0, -1)
</CsInstruments>
<CsScore>
;need to be gayer
t 0 128
;{ 16 CNT
;i"kick" [$CNT*8] 0.0001
;}
i"t2" 0  32  0  0  4.11 ;step, limit, base-note
i"fm" 0  32  01 02 00 00 00 00 00 00    .14 .04 .04 .08 .21 .02 .02 .02 ;envs, amps

i"t2" +  32  0  0  6
i"fm" +  32  -4 02 08 -4 -4 02 -8 03    .14 .04 .04 .08 .21 .02 .02 .02

i"t2" +  32  0  0  4
i"fm" +  32  -4 02 08 -4 -4 02 -8 03    .14 .04 .04 .08 .05 .02 .02 .02

i"t2" +  32  0  0  4
i"fm" +  32  -4 02 08 -4 -4 02 -8 03    .04 .04 .04 .04 .05 .04 .01 .04

i"t2" +  32  1  0  4
i"fm" +  32  -4 02 08 -4 -4 02 -8 03    .04 .04 .04 .04 .04 .04 .01 .04

i"t2" +  08  2  0  3
i"fm" +  08  -4 02 08 -4 -4 02 -8 03    .04 .04 .04 .20 .04 .02 .01 .02

i"t2" +  08  0  2  2
i"fm" +  08  02 02 -4 -4 02 -2 -3 03    .54 .04 .04 .04 .50 .02 .01 .02

i"t2" +  08  0  2  2
i"fm" +  08  02 02 -4 04 02 02 03 03    .04 .04 .04 .04 .50 .02 .01 .03

i"t2" +  08  0  2  2
i"fm" +  08  02 -2 -4 -4 02 -2 -3 03    .54 .04 .04 .04 .50 .02 .01 .02
e
</CsScore>
</CsoundSynthesizer>

