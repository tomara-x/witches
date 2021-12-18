trans rights

/*
Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
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

#include "function-tables.orc"
#include "opcodes.orc"

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

kl1[]      fillarray   1,    1,    1,    1
kb1AS, kb1t[] uBasemath ktimeunit, kl1

schedkwhen  kb1t[0], 0, 0, "kick", 0, .0001
schedkwhen  kb1t[2], 0, 0, "snare", 0, .0001
schedkwhen  kb1t[kb1AS]-(kb1t[0]+kb1t[2]), 0, 0, "hat", 0, .0001
endin

instr kick
aaenv   expsegr 1,p3,1,0.1,0.001
afenv   expsegr 230,p3,230,0.05,20
asig    oscili aaenv*.3, afenv
asig    distort asig, 0.2, giftanh
outs    asig, asig
gaRvbSend += asig*0.03
endin

instr snare
kenv    expsegr 1,p3,1,0.9,0.001
asprng  pluck kenv*0.3, 260, 260, 0, 3, 0.5
aaenv   expsegr 1,p3,1,0.1,0.001
afenv   expsegr 260,p3,260,0.05,20
adrm    oscili aaenv*.3, afenv
asig = (asprng+adrm)/2
asig    distort asig, 0.2, giftanh
outs    asig, asig
gaRvbSend += asig*0.03
endin

instr hat
aenv    expsegr 1,p3,1,0.08,0.001
asig    noise   0.1*aenv, 0
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

