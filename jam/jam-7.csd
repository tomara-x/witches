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

#define TEMPO #86#
#include "../opcodes.orc"
#include "../function-tables.orc"
gaRvbSend init 0
alwayson "verb"
gaDstSend init 0
alwayson "dist"

instr kick
iifrq   = 230
iefrq   = 20
aaenv   expsegr 1,p3,1,0.3,0.001
afenv   expsegr iifrq,p3,iifrq,0.05,iefrq
asig    oscili aaenv*.6, afenv
asig    distort asig*2, 0.2, giftanh
asig    limit asig, -0.5,0.5
asig    += moogladder(asig, iifrq*2, .3)
outs    asig, asig
gaRvbSend += asig*0.03
endin

instr snare
ifreq   = 280
kenv    expsegr 1,p3,1,1,0.001
asprng  pluck kenv*0.8, ifreq, ifreq, 0, 3, 0.6
aaenv   expsegr 1,p3,1,0.3,0.001
afenv   expsegr ifreq,p3,ifreq,0.05,20
adrm    oscili aaenv*.4, afenv
asig    = (asprng+adrm)/2
asig    distort asig, 0.4, giftanh
asig    += moogladder(asig, ifreq, .5)*2
outs    asig, asig
gaRvbSend += asig*0.03
endin

instr hat
aenv    expsegr 1,p3,1,0.25,0.001
asig    noise   0.1*aenv, -0.9
outs    asig, asig
gaRvbSend += asig*0.06
endin

instr pluck1
iplk    =           0.2 ;(0 to 1)
kamp    init        0.15
icps    =           p4
kpick   init        0.8 ;pickup point
krefl   init        p5 ;rate of decay? ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl
kenv2   linsegr     0,0.003,1,p3,1,p6,0 ;declick
asig    *=          kenv2
        outs        asig,asig
gaDstSend += asig*p7
gaRvbSend += asig*p8
endin

instr 1
ktrig   metro $TEMPO*p5/60
kcnt[]  fillarray p6, p7, p8, p9
kAS1, kt1[] utBasemath ktrig, kcnt
knote[] fillarray p10, p11, p12, p13
kgain[] fillarray p14, p15, p16, p17
kQ[]    fillarray 0, 0, 0, 0
kAS2, kp[], kt2[] Taphath kt1[kAS1], knote, kgain, kQ, gicm4
schedkwhen kt1[kAS1], 0,0, "pluck1", 0, p4, kp[kAS2], p18, p19, p20, p21
endin

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
t 0 128
;           PD Mu Count         Notes        Trans        RD Rl Ds Rv
i1  0   16 .80 08 04 02 01 02   21 13 42 04  00 01 07 00  .3 .8 .2 .2
i1  +   16 .02 16 04 02 01 02   21 13 42 04  00 01 07 00  .3 .1 .2 .2
i1  +   08 .02 16 04 02 01 02   21 13 42 04  01 -1 01 -1  .3 .1 .2 .2
i1  +   08 .02 16 04 02 01 02   21 13 42 04  -1 01 -1 01  .3 .1 .2 .2
e
</CsScore>
</CsoundSynthesizer>

