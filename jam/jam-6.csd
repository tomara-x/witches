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
gaRvbSend init 0
alwayson "verb"
gaDstSend init 0
alwayson "dist"

instr 1
ktrig   metro $TEMPO*4/60
knote[] fillarray p4,p5,p6,p7
kgain[] fillarray p8,p9,p10,p11
kQ[]    fillarray 0, 0, 0, 0
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm4
kcps    = kp[kAS]*4
kenv    = linsegr(1,p3,1,p12,0)
aop1    Pmoscili kenv*0.1, kcps*4, aop1*.8
aop2    Pmoscili kenv*0.2, kcps/2
aop3    Pmoscili kenv*0.8, kcps/1, aop1+aop2
aop4    Pmoscili kenv*0.2, kcps/2, aop1+aop2
aop5    Pmoscili kenv*0.1, kcps/4, aop1+aop2
aop6    Pmoscili kenv*0.5, kcps/2, aop3
aop7    Pmoscili kenv*0.5, kcps/4, aop4+aop7*0.5
aop8    Pmoscili kenv*0.5, kcps/8, aop5
aout    = aop6 + aop7 + aop8
aout    = aout * 0.1
gaRvbSend += aout*0.3
outs    aout, aout
endin

instr 2
ktrig   metro $TEMPO*4/60
knote[] fillarray p4,p5,p6,p7
kgain[] fillarray p8,p9,p10,p11
kQ[]    fillarray 0, 0, 0, 0
kAS, kp[], kt[] Taphath ktrig, knote, kgain, kQ, gicm4
kfreq = kp[kAS]
iz = 0.001
kamp = expsegr(0.2,1,iz)
kpres = 1 ;useful range [1,5]
krat = 0.13 ;bow position along string
kvibf = 8
kvamp = 0.001
asig wgbow kamp, kfreq, kpres, krat, kvibf, kvamp
outs asig,asig
gaRvbSend += asig*0.05
endin

;instr 2
;ktrig   metro $TEMPO*8/60
;kcnt[]  fillarray 2, 2, 2, 2
;kAS1, kt1[] utBasemath ktrig, kcnt
;kcnt[3] = wrap(kcnt[3]-2*kt1[0], 2, 9)
;kcnt[1] = wrap(kcnt[1]+2*kt1[0], 2, 9)
;endin
;
;instr 3
;ktrig   metro $TEMPO*4/60
;knote[] fillarray p4, p5
;kgain[] fillarray p6, p7
;kQ[]    fillarray 0,  0
;kAS,kp[],kt[] Taphath ktrig,knote,kgain,kQ,giud4
;aout = Pmoscili(0.5, kp[kAS], aout*0.6)
;outs aout, aout
;endin

instr dust
aout dust .5, 10
gaRvbSend += aout*0.1
outs aout, aout
endin

instr dist ;distortion
kdist = 0.4
ihp = 10
istor = 0
ares        distort gaDstSend, kdist, giftanh, ihp, istor
outs        ares, ares
clear       gaDstSend
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
t       0       128
i1      0       16      28 29 28 35      00 01 00 00    00
i1      +       16      07 10 08 12     
i1      +       16      28 29 28 35     
i1      +       16      28 29 46 28      02 01 00 00
i1      +       08      28 29 28 35      01 01 01 01
i1      ^+8     08      28 29 28 35      -1 -1 -1 -1
i1      ^+8     16      00 29 00 28      07 08 03 -4
i1      +       16      28 29 46 00     
i1      +       08      28 29 28 35      02 02 02 02
i1      +       16      28 29 46 28      02 01 00 00
i1      +       16      21 22 39 21      02 01 00 00    10
e
</CsScore>
</CsoundSynthesizer>

