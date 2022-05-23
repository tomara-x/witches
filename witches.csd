//trans rights
//Copyright © 2021 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//This one's for my witches
<CsoundSynthesizer>
<CsOptions>
; RT/Render
-odac -L stdin -m 231
; -o magic.wav
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   1
0dbfs   =   1

#include "function-tables.orc"
#include "sequencers.orc"
#include "oscillators.orc"
#include "utils.orc"

instr 1
ktmpo       init    137 ;bpm
kclkx1      metro   ktmpo/60 ;whole notes
knotes[]    fillarray   0,0,0,0,0,0,0,0
kincs[]     fillarray   0,-1,2,0,1,0,-3,1
kQ[]        fillarray   0,0,0,0,0,0,0,0

;kreset = ClkDiv(kclkx1, 8)  ;reset must be 1-k-cycle-long trigger

;if kclkx1 > 0 then ;randomly increment a random step increment!
;   krandstep   trandom kclkx1, 0, lenarray(kincs)
;   krandval    =       int(trandom(kclkx1,-5,5))
;   kincs[krandstep] = kincs[krandstep] + krandval
;endif

; run the sequencer
kAS,kpitch[],ktrig[] Taphath kclkx1,knotes,kincs, kQ, giud4

;self-patching trig-outs to noteIndex or to incs
;if kotrig[5] == 1 then
;   knotes[1] = knotes[1]-5 ;can access values of other steps this way.
;                           ;totally not because the += form doesn't work on arrays!
;   kincs[0] = kincs[0] + 1 ;if you want increasing inrements!
;endif

; make some noise
kpres   randi       2, 8, 0.5, 0, 3 ;amp, cps, seed, bit, offset
krat    randi       0.25, 2, 0.5, 0, 0.01
asig    wgbow       0.4, kpitch[kAS], 3, 0.13, 5, 0.004
        out         asig
; run another instrument with the same pitch info
        schedkwhen  kclkx1, 0, 0, 2, 0, 0.4, kpitch[kAS]/2
endin

instr 2
iz      init        0.001
aenv1   expseg      2,0.2,iz
aenv2   expseg      2,0.4,iz
aenv3   expsegr     1,0.9,iz,0.6,iz
aenv4   expsegr     1,0.5,iz,0.5,iz
amod1   oscili      aenv1, p4/2
amod2   oscili      aenv2, p4
acar1   Pmoscili    aenv3, p4*2, amod1+amod2
acar2   Pmoscili    aenv4, p4, amod1+amod2
asig    bqrez       acar1+acar2, p4*4, 1
asig    limit       asig, -0.25, 0.25
        out         asig
endin

instr 4 ;overkill
ktempo      =   137 ;bpm
ktimeunit   =   1/(ktempo/60) ;1 whole note at tempo in seconds

klen[]      fillarray   4,    4,    4,    4,    4,    4,    4,    4
kgain[]     fillarray   0,    0,    0,    0,    0,    0,    0,    0
kminlen[]   fillarray   1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64
kmaxlen[]   fillarray   8,    8,    8,    8,    8,    8,    8,    8
kdivs[]     fillarray   0,    0,    0,    0,    0,    0,    0,    0
kdivgain[]  fillarray   0,    0,    0,    0,    0,    0,    0,    0
kmaxdivs[]  fillarray   256,  256,  256,  256,  256,  256,  256,  256
kQ[]        fillarray   0,    0,    0,    0,    0,    0,    0,    0

kAS, ktrig[], kd[] Basemath ktimeunit, klen, kgain, kminlen, kmaxlen,
        kdivs, kdivgain, kmaxdivs, kQ

schedkwhen  kd[kAS], 0, 0, "hat", 0, 0.0001
endin

instr hat
aenv    expsegr 1,p3,1,0.04,0.001
asig    noise   0.2*aenv, 0
out     asig
endin

instr 6
ktempo      =   137 ;bpm
ktimeunit   =   1/(ktempo/60) ;1 whole note at ktempo (in seconds)

klen[]      fillarray   1,    1,    1,    1,    1,    1,    1,    1
kgain[]     fillarray   0,    0,    0,    1,    0,    0,    0,    0
kminlen[]   fillarray   0,    0,    0,    1,    0,    0,    0,    0
kmaxlen[]   fillarray   4,    4,    4,    4,    4,    4,    4,    4
kdivs[]     fillarray   0,    0,    0,    4,    0,    0,    0,    0
kdivgain[]  fillarray   0,    0,    0,    0,    0,    0,    0,    0
kmaxdivs[]  fillarray   16,   16,   16,   8,    8,    8,    8,    8
kbQ[]       fillarray   0,    0,    0,    0,    0,    0,    0,    0

kbAS, kbtrig[], kd[] Basemath ktimeunit,klen,kgain,kminlen,kmaxlen,
        kdivs,kdivgain,kmaxdivs,kbQ

knotes[]    fillarray   0,    2,    0,    6,    2,    3,    0,    1
knotegain[] fillarray   1,    2,    0,    0,   -4,    0,    0,    3
ktQ[]       fillarray   0,    0,    0,    0,    0,    0,    0,    0

ktAS,kpitch[],kttrig[] Taphath kbtrig[kbAS],knotes,knotegain,ktQ,gicm4

kenv    looptseg    ktempo/8/60, kd[kbAS], 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch[ktAS]*4
        out         limit(asig, -0.2,0.2)
endin

instr 7
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       4
klen[]      init    ilen
kgain[]     init    ilen
kdivs[]     init    ilen
kdivgain[]  init    ilen
kmaxdivs[]  init    ilen
kminlen[]   init    ilen
kmaxlen[]   init    ilen
kbQ[]       init    ilen

knotes[]    init    ilen
knotegain[] init    ilen
ktQ[]       init    ilen

kndx = 0
while kndx < ilen do
    klen[kndx]          =   (kndx%4)/10
    kgain[kndx]         =   0
    kdivs[kndx]         =   0
    kdivgain[kndx]      =   0
    kmaxdivs[kndx]      =   0
    kminlen[kndx]       =   0
    kmaxlen[kndx]       =   1
    kbQ[kndx]           =   0

    knotes[kndx]        =   0
    knotegain[kndx]     =   random(-5, 5)
    ktQ[kndx]           =   0
    kndx += 1
od

kbAS, kbtrig[], kd[] Basemath ktimeunit,klen,kgain,kminlen,kmaxlen,
        kdivs,kdivgain,kmaxdivs,kbQ

ktAS,kpitch[],kttrig[] Taphath kbtrig[kbAS],knotes,knotegain,ktQ,gicm4

kenv    looptseg    ktempo/8/60, kd[kbAS], 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch[ktAS]*4
        out         limit(asig, -0.2,0.2)
endin

instr 8
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       128
klen[]      init    ilen
kgain[]     init    ilen
kdivs[]     init    ilen
kdivgain[]  init    ilen
kmaxdivs[]  init    ilen
kminlen[]   init    ilen
kmaxlen[]   init    ilen
kbQ[]       init    ilen

knotes[]    init    ilen
knotegain[] init    ilen
ktQ[]       init    ilen

kndx = 0
while kndx < ilen do
    klen[kndx]          =   (kndx%1)/10
    kgain[kndx]         =   0
    kdivs[kndx]         =   0
    kdivgain[kndx]      =   0
    kmaxdivs[kndx]      =   0
    kminlen[kndx]       =   0
    kmaxlen[kndx]       =   2
    kbQ[kndx]           =   0

    knotes[kndx]        =   0
    knotegain[kndx]     =   random(-5, 5)
    ktQ[kndx]           =   0
    kndx += 1
od
klen[0] = 8

kbAS, kbtrig[], kd[] Basemath ktimeunit,klen,kgain,kminlen,kmaxlen,
        kdivs,kdivgain,kmaxdivs,kbQ

ktAS,kpitch[],kttrig[] Taphath kbtrig[kbAS],knotes,knotegain,ktQ,gicm4

kenv    looptseg    ktempo/8/60, kd[kbAS], 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch[ktAS]*4
        out         limit(asig, -0.2,0.2)
endin

instr 9
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       128
klen[]      init    ilen
kgain[]     init    ilen
kdivs[]     init    ilen
kdivgain[]  init    ilen
kmaxdivs[]  init    ilen
kminlen[]   init    ilen
kmaxlen[]   init    ilen
kbQ[]       init    ilen

knotes[]    init    ilen
knotegain[] init    ilen
ktQ[]       init    ilen

kndx = 0
while kndx < ilen do
    klen[kndx]          =   mirror(wrap(kndx, -4, 8), 1, 4)/2
    kgain[kndx]         =   0
    kdivs[kndx]         =   wrap(kndx, 0, 9)
    kdivgain[kndx]      =   0
    kmaxdivs[kndx]      =   16
    kminlen[kndx]       =   0
    kmaxlen[kndx]       =   2
    kbQ[kndx]           =   0

    knotes[kndx]        =   random:k(-5,5)
    knotegain[kndx]     =   knotes[kndx]
    ktQ[kndx]           =   0
    kndx += 1
od

kbAS, kbtrig[], kd[] Basemath ktimeunit,klen,kgain,kminlen,kmaxlen,
        kdivs,kdivgain,kmaxdivs,kbQ

ktAS,kpitch[],kttrig[] Taphath kbtrig[kbAS],knotes,knotegain,ktQ,gicm2

kenv    looptseg    ktempo/8/60, kd[kbAS], 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch[ktAS]*2
        out         limit(asig, -0.2,0.2)
endin

instr 10
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       32
klen[]      init    ilen
kgain[]     init    ilen
kdivs[]     init    ilen
kdivgain[]  init    ilen
kmaxdivs[]  init    ilen
kminlen[]   init    ilen
kmaxlen[]   init    ilen
kbQ[]       init    ilen

knotes[]    init    ilen
knotegain[] init    ilen
ktQ[]       init    ilen

kndx = 0
while kndx < ilen do
    klen[kndx]          =   1/2
    kgain[kndx]         =   0
    kdivs[kndx]         =   0
    kdivgain[kndx]      =   random:k(-2,6)
    kmaxdivs[kndx]      =   9
    kminlen[kndx]       =   0
    kmaxlen[kndx]       =   2
    kbQ[kndx]           =   0

    knotes[kndx]        =   0
    knotegain[kndx]     =   random:k(-5,5)
    ktQ[kndx]           =   0
    kndx += 1
od

kbAS, kbtrig[], kd[] Basemath ktimeunit,klen,kgain,kminlen,kmaxlen,
        kdivs,kdivgain,kmaxdivs,kbQ

ktAS,kpitch[],kttrig[] Taphath kbtrig[kbAS],knotes,knotegain,ktQ,gicm4

kenv    looptseg    ktempo/8/60, kd[kbAS], 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch[ktAS]*2
        out         limit(asig, -0.2,0.2)
endin

instr 11
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       64
klen[]      init    ilen
kgain[]     init    ilen
kdivs[]     init    ilen
kdivgain[]  init    ilen
kmaxdivs[]  init    ilen
kminlen[]   init    ilen
kmaxlen[]   init    ilen
kbQ[]       init    ilen

knotes[]    init    ilen
knotegain[] init    ilen
ktQ[]       init    ilen

kndx = 0
while kndx < ilen do
    klen[kndx]          =   1/4
    kgain[kndx]         =   0
    kdivs[kndx]         =   0
    kdivgain[kndx]      =   0
    kmaxdivs[kndx]      =   0
    kminlen[kndx]       =   0
    kmaxlen[kndx]       =   2
    kbQ[kndx]           =   0

    knotes[kndx]       =   (2^kndx)%50 ;play around with this, 'tis dope af!
    ;knotes[kndx]        =   sin((kndx-(ilen/2))/10)*10
    knotegain[kndx]     =   1
    ktQ[kndx]           =   0
    kndx += 1
od

kbAS, kbtrig[], kd[] Basemath ktimeunit,klen,kgain,kminlen,kmaxlen,
        kdivs,kdivgain,kmaxdivs,kbQ

ktAS,kpitch[],kttrig[] Taphath kbtrig[kbAS],knotes,knotegain,ktQ,gicm4

kenv    looptseg    ktempo/8/60, kd[kbAS], 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch[ktAS]
        out         limit(asig, -0.2,0.2)
endin

</CsInstruments>
<CsScore>
;read the manual, amy!
t       0       137 ;score tempo 137bpm
;i1      0       137

i4      0       274
i6      0       274
;i7      0       274
i8      0       274
i9      0       274

;i10        0       64
;i11        0       32
e
</CsScore>
</CsoundSynthesizer>

