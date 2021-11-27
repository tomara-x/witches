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
nchnls  =   1
0dbfs   =   1

#include "function-tables.orc"
#include "opcodes.orc"

; ------------------------------
; instruments

instr 1
ktmpo       init    137 ;bpm
kclkx1      metro   ktmpo/60 ;whole notes
kclkx4      metro   4*ktmpo/60 ;quarter notes
kclkd4      metro   ktmpo/60/4 ;4 whole notes
kclkd8      metro   ktmpo/60/8 ;8 whole notes
kclkd16     metro   ktmpo/60/16 ;16 whole notes
ktrigseq1   seqtime 1/(4*ktmpo/60), 0, 8, 0, gifn2

knotes[]    fillarray   0,0,0,0,0,0,0,0
kincs[]     fillarray   0,-1,2,0,1,0,-3,1

;kreset = kclkd8  ;reset must be 1-k-cycle-long trigger

;if kclkx1 > 0 then ;randomly increment a random step increment!
;   krandstep   trandom kclkx1, 0, lenarray(kincs)
;   krandval    =       int(trandom(kclkx1,-5,5))
;   kincs[krandstep] = kincs[krandstep] + krandval
;endif

; run the sequencer
kpitch,kotrig[],kopitch[] Taphath kclkx1,knotes,kincs,gifn1,0,0,0

;self-patching trig-outs to noteIndex or to incs
;if kotrig[5] == 1 then
;   knotes[1] = knotes[1]-5 ;can access values of other steps this way.
;                           ;totally not because the += form doesn't work on arrays!
;   kincs[0] = kincs[0] + 1 ;if you want increasing inrements!
;endif

; make some noise
kpres   randi       2, 8, 0.5, 0, 3 ;amp, cps, seed, bit, offset
krat    randi       0.25, 2, 0.5, 0, 0.01
asig    wgbow       0.4, kpitch, 3, 0.13, 5, 0.004
        out         asig
; run another instrument with the same pitch info
        schedkwhen  kclkx1, 0, 0, 2, 0, 0.4, kpitch/2
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

instr 4
ktempo      =   137 ;bpm
ktimeunit   =   1/(ktempo/60) ;1 whole note at tempo in seconds

ktimes[]    fillarray   4,    4,    4,    4,    4,    4,    4,    4
kincs[]     fillarray   0,    0,    0,    0,    0,    0,    0,    0
kdivs[]     fillarray   0,    0,    0,    0,    0,    0,    0,    0
kdivincs[]  fillarray   0,    0,    0,    0,    0,    0,    0,    0

kmaxdivs[]  fillarray   256,  256,  256,  256,  256,  256,  256,  256
kminlen[]   fillarray   1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64
kmaxlen[]   fillarray   8,    8,    8,    8,    8,    8,    8,    8

ktrig, ksub, ktrigArr[] Basemath ktimeunit, ktimes, kincs, kdivs, kdivincs,
        kmaxdivs, kminlen, kmaxlen

schedkwhen  ksub, 0, 0, 5, 0, 0.0001
endin

instr 5 ;hat
aenv    expsegr 1,p3,1,0.04,0.001
asig    noise   0.1*aenv, 0
out     asig
endin

instr 6
ktempo      =   137 ;bpm
ktimeunit   =   1/(ktempo/60) ;1 whole note at ktempo (in seconds)

kTimes[]    fillarray   1,    1,    1,    1,    1,    1,    1,    1
kTimeIncs[] fillarray   0,    0,    0,    1,    0,    0,    0,    0
kDivs[]     fillarray   0,    0,    0,    4,    0,    0,    0,    0
kDivIncs[]  fillarray   0,    0,    0,    0,    0,    0,    0,    0

kMaxDivs[]  fillarray   16,   16,   16,   8,    8,    8,    8,    8
kMinLen[]   fillarray   0,    0,    0,    1,    0,    0,    0,    0
kMaxLen[]   fillarray   4,    4,    4,    4,    4,    4,    4,    4

ktrig,ksub,kbasemathtrigs[] Basemath ktimeunit,kTimes,kTimeIncs,kDivs,kDivIncs,
        kMaxDivs,kMinLen,kMaxLen

kNotes[]    fillarray   0,    2,    0,    6,    2,    3,    0,    1
kNoteIncs[] fillarray   1,    2,    0,    0,   -4,    0,    0,    3

kpitch,ktaphtrigs[],ktaphpitches[] Taphath ktrig,kNotes,kNoteIncs,gifn3

kenv    looptseg    ktempo/8/60, ksub, 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch*4
        out         limit(asig, -0.2,0.2)
endin

instr 7 ;Madness demo #0
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       4
kTimes[]    init    ilen
kTimeIncs[] init    ilen
kDivs[]     init    ilen
kDivIncs[]  init    ilen
kMaxDivs[]  init    ilen
kMinLen[]   init    ilen
kMaxLen[]   init    ilen

kNotes[]    init    ilen
kNoteIncs[] init    ilen

kndx = 0
while kndx < ilen do
    kTimes[kndx]        =   (kndx%1)/10 ;leaving this for the idea + I didn't know
    kTimeIncs[kndx]     =   0
    kDivs[kndx]         =   0
    kDivIncs[kndx]      =   0
    kMaxDivs[kndx]      =   0
    kMinLen[kndx]       =   0
    kMaxLen[kndx]       =   1

    kNotes[kndx]        =   0
    kNoteIncs[kndx]     =   random(-5, 5)
    kndx += 1
od

ktrig,ksub,kbasemathtrigs[] Basemath ktimeunit,kTimes,kTimeIncs,kDivs,kDivIncs,
        kMaxDivs,kMinLen,kMaxLen

kpitch,ktaphtrigs[],ktaphpitches[] Taphath ktrig,kNotes,kNoteIncs,gifn3

kenv    looptseg    ktempo/8/60, ksub, 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch*4
        out         limit(asig, -0.2,0.2)
endin

instr 8 ;Madness demo #1
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       128
kTimes[]    init    ilen
kTimeIncs[] init    ilen
kDivs[]     init    ilen
kDivIncs[]  init    ilen
kMaxDivs[]  init    ilen
kMinLen[]   init    ilen
kMaxLen[]   init    ilen

kNotes[]    init    ilen
kNoteIncs[] init    ilen

kndx = 0
while kndx < ilen do
    kTimes[kndx]        =   (kndx%1)/10
    kTimeIncs[kndx]     =   0
    kDivs[kndx]         =   0
    kDivIncs[kndx]      =   0
    kMaxDivs[kndx]      =   0
    kMinLen[kndx]       =   0
    kMaxLen[kndx]       =   2

    kNotes[kndx]        =   0
    kNoteIncs[kndx]     =   random(-5, 5)
    kndx += 1
od

ktrig,ksub,kbasemathtrigs[] Basemath ktimeunit,kTimes,kTimeIncs,kDivs,kDivIncs,
        kMaxDivs,kMinLen,kMaxLen

kpitch,ktaphtrigs[],ktaphpitches[] Taphath ktrig,kNotes,kNoteIncs,gifn3

kenv    looptseg    ktempo/8/60, ksub, 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch*4
        out         limit(asig, -0.2,0.2)
endin

instr 9 ;Madness demo #2
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       128
kTimes[]    init    ilen
kTimeIncs[] init    ilen
kDivs[]     init    ilen
kDivIncs[]  init    ilen
kMaxDivs[]  init    ilen
kMinLen[]   init    ilen
kMaxLen[]   init    ilen

kNotes[]    init    ilen
kNoteIncs[] init    ilen

kndx = 0
while kndx < ilen do
    kTimes[kndx]        =   mirror(wrap(kndx, -4, 8), 1, 4)/2
    kTimeIncs[kndx]     =   0
    kDivs[kndx]         =   wrap(kndx, 0, 9)
    kDivIncs[kndx]      =   0
    kMaxDivs[kndx]      =   16
    kMinLen[kndx]       =   0
    kMaxLen[kndx]       =   2

    kNoteIncs[kndx]     =   random:k(-5,5)
    kNotes[kndx]        =   kNoteIncs[kndx]
    kndx += 1
od

ktrig,ksub,kbasemathtrigs[] Basemath ktimeunit,kTimes,kTimeIncs,kDivs,kDivIncs,
        kMaxDivs,kMinLen,kMaxLen

kpitch,ktaphtrigs[],ktaphpitches[] Taphath ktrig,kNotes,kNoteIncs,gifn4

kenv    looptseg    ktempo/8/60, ksub, 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch*2
        out         limit(asig, -0.2,0.2)
endin

instr 10 ;fun
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       32
kTimes[]    init    ilen
kTimeIncs[] init    ilen
kDivs[]     init    ilen
kDivIncs[]  init    ilen
kMaxDivs[]  init    ilen
kMinLen[]   init    ilen
kMaxLen[]   init    ilen

kNotes[]    init    ilen
kNoteIncs[] init    ilen

kndx = 0
while kndx < ilen do
    kTimes[kndx]        =   1/2
    kTimeIncs[kndx]     =   0
    kDivs[kndx]         =   0
    kDivIncs[kndx]      =   random:k(-2,6)
    kMaxDivs[kndx]      =   9
    kMinLen[kndx]       =   0
    kMaxLen[kndx]       =   2

    kNotes[kndx]        =   0
    kNoteIncs[kndx]     =   random:k(-5,5)
    kndx += 1
od

ktrig,ksub,kbasemathtrigs[] Basemath ktimeunit,kTimes,kTimeIncs,kDivs,kDivIncs,
        kMaxDivs,kMinLen,kMaxLen

kpitch,ktaphtrigs[],ktaphpitches[] Taphath ktrig,kNotes,kNoteIncs,gifn3

kenv    looptseg    ktempo/8/60, ksub, 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch*2
        out         limit(asig, -0.2,0.2)
endin

instr 11
ktempo      =   137
ktimeunit   =   1/(ktempo/60)

ilen        =       64
kTimes[]    init    ilen
kTimeIncs[] init    ilen
kDivs[]     init    ilen
kDivIncs[]  init    ilen
kMaxDivs[]  init    ilen
kMinLen[]   init    ilen
kMaxLen[]   init    ilen

kNotes[]    init    ilen
kNoteIncs[] init    ilen

kndx = 0
while kndx < ilen do
    kTimes[kndx]        =   1/4
    kTimeIncs[kndx]     =   0
    kDivs[kndx]         =   0
    kDivIncs[kndx]      =   0
    kMaxDivs[kndx]      =   0
    kMinLen[kndx]       =   0
    kMaxLen[kndx]       =   2

    ;kNotes[kndx]       =   (2^kndx)%50 ;play around with this, 'tis dope af!
    kNotes[kndx]        =   sin((kndx-(ilen/2))/10)*10
    kNoteIncs[kndx]     =   1
    kndx += 1
od

ktrig,ksub,kbasemathtrigs[] Basemath ktimeunit,kTimes,kTimeIncs,kDivs,kDivIncs,
        kMaxDivs,kMinLen,kMaxLen

kpitch,ktaphtrigs[],ktaphpitches[] Taphath ktrig,kNotes,kNoteIncs,gifn3

kenv    looptseg    ktempo/8/60, ksub, 0, 1,-40,1, 0,0,0
asig    oscili      kenv, kpitch
        out         limit(asig, -0.2,0.2)
endin

; ------------------------------

</CsInstruments>
; ==============================================
<CsScore>
;read the manual, amy! there's better ways to mix and arrange!
t       0       137 ;score tempo 137bpm
;i1     0       64

i4      0       274
i6      0       274
i7      0       274
i8      0       274
i9      0       274

;i10        0       64
;i11        0       32
e
</CsScore>
</CsoundSynthesizer>

