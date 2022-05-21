trans rights

/*
Copyright © 2021 Amy Universe
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
*/

<CsoundSynthesizer>
<CsOptions>
-odac -L stdin
</CsOptions>
; ==============================================
<CsInstruments>

sr      =   44100
ksmps   =   42
;kr     =   1050
nchnls  =   2
0dbfs   =   1

#define TEMPO #128#

#include "../function-tables.orc"
#include "../opcodes.orc"

gaRvbSend init 0
alwayson "verb"

gaDstSend init 0
alwayson "dist"

instr 1
ktimeunit   =           1/($TEMPO/60)
klen[]      fillarray   1,    1,    1,    1,    1,    1,    1,    1
klgain[]    fillarray   0,    0,    0,    0,    0,    0,    0,    0
kminlen[]   fillarray   0,    0,    0,    0,    0,    0,    0,    0
kmaxlen[]   fillarray   8,    8,    8,    8,    8,    8,    8,    8

kdiv[]      fillarray   0,    0,    0,    3,    0,    0,    0,    0
kdgain[]    fillarray   0,    0,    0,    0,    0,    0,    0,    0
kmaxdiv[]   fillarray   8,    8,    8,    8,    8,    8,    8,    8

kQ[]        fillarray   0,    0,    0,    0,    0,    0,    0,    0

kbAS, kbtrig[], kbdiv[] Basemath ktimeunit, klen,klgain,kminlen,kmaxlen,
                                 kdiv,kdgain,kmaxdiv, kQ

knotes[]    fillarray   0,    9,    0,    4
kincs[]     fillarray   1,    3,    3,    0
kQ[]        fillarray   0,    0,    0,    0

ktAS, kpitch[], kttrig[] Taphath kbdiv[kbAS], knotes, kincs, kQ, giud
kQ[ktAS] = kQ[ktAS] * 0

;schedkwhen  kbdiv[kbAS]-kbdiv[4], 0, 0, "pluck1", 0, .1, kpitch[ktAS], 0.7, 0.0
;schedkwhen  ClkDiv(kbdiv[0], 4), 0, 0, "pluck1", 0, 6, kpitch[ktAS]*2, 0.3, 0.4

kl1[]      fillarray   1,    1/3, 1/3, 1/3,    1,    1/5, 1/5, 1/5, 1/5, 1/5
kb1AS, kb1t[] uBasemath ktimeunit, kl1
schedkwhen  kb1t[0], 0, 0, "kick", 0, .0001
schedkwhen  kb1t[4], 0, 0, "snare", 0, .0001
schedkwhen  kb1t[kb1AS]-(kb1t[0]+kb1t[4]), 0, 0, "hat", 0, .0001

kl2[]      fillarray   8/3, 8/3, 8/3
kb2AS, kb2t[] uBasemath ktimeunit, kl2
schedkwhen  kb2t[kb2AS], 0, 0, "FM1", 0, .0001
endin

instr FM1
iz = 0.0001
ama1    expsegr 10,0.1,iz
amod1   oscili ama1,220
ama2    expsegr 10,0.1,iz
amod2   oscili ama2,55

aca1 expsegr 1,2,iz
kcf1 expsegr 220,1.8,55
acar1   Pmoscili aca1, kcf1, amod1
aca2 expsegr 1,2,iz
kcf2 expsegr 880,0.6,110
acar2   Pmoscili aca2, kcf2, amod2
asig    = acar1+acar2
asig    *= 0.08
outs    asig, asig
endin

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
aenv    expsegr 1,p3,1,0.06,0.001
asig    noise   0.1*aenv, -0.8
outs    asig, asig
gaRvbSend += asig*0.03
endin

instr pluck1
iplk    =           0.2 ;(0 to 1)
kamp    init        0.15
icps    =           p4
kpick   init        0.8 ;pickup point
krefl   init        p5 ;rate of decay? ]0,1[
asig1   wgpluck2    iplk,kamp,icps,kpick,krefl
asig2   wgpluck2    iplk,kamp,icps*1.5,kpick,krefl
asig3   wgpluck2    iplk,kamp,icps*2.0,kpick,krefl
asig    =           asig1+asig2+asig3
kenv2   linsegr     1,p3,1,0.8,0 ;to avoid end click
asig    *=          kenv2
        outs        asig,asig
gaDstSend += asig*p6
gaRvbSend += asig*0.05
endin

instr dist ;distortion effect
kdist = 0.4
ihp = 10
istor = 0
ares        distort gaDstSend, kdist, giftanh, ihp, istor
outs        ares, ares
clear       gaDstSend
endin

; stolen from the floss manual (05E01_freeverb.csd)
instr verb ; reverb - always on
kroomsize    init      0.85         ; room size (range 0 to 1)
kHFDamp      init      0.5          ; high freq. damping (range 0 to 1)
aRvbL,aRvbR  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aRvbL, aRvbR
             clear     gaRvbSend
endin

</CsInstruments>
; ==============================================
<CsScore>
;read the manual, amy!
t       0       128
i1      0       [128*4]
e
</CsScore>
</CsoundSynthesizer>

