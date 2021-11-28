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

#include "function-tables.orc"
#include "opcodes.orc"

<<<<<<< HEAD
gaRvbSend    init      0 ; global audio variable initialized to zero

=======
>>>>>>> main
instr 1
ktempo      =   113 ;bpm
ktimeunit   =   1/(ktempo/60) ;1 whole note at tempo in seconds
ktimes[]    fillarray   1/4,  1/4,  4,    1/4,  1/4,  4,    1/4,  1/4
kmaxlen[]   fillarray   8,    8,    8,    8,    8,    8,    8,    8

ktrig, ktrigArr[] uBasemath ktimeunit, ktimes, kmaxlen


schedkwhen  ktrig, 0, 0, 2, 0, 0.0001
endin

instr 2 ;hat
aenv    expsegr 1,p3,1,0.04,0.001
asig    noise   0.1*aenv, 0
outs    asig, asig
gaRvbSend += asig*0.8
endin

; stolen from the floss manual (05E01_freeverb.csd) 
instr 99 ; reverb - always on
kroomsize    init      0.85         ; room size (range 0 to 1)
kHFDamp      init      0.5          ; high freq. damping (range 0 to 1)

aRvbL,aRvbR  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aRvbL, aRvbR ; send audio to outputs
             clear     gaRvbSend    ; clear global audio variable
endin

<<<<<<< HEAD
=======
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

>>>>>>> main
</CsInstruments>
; ==============================================
<CsScore>
;read the manual, amy!
t       0       113
i1      0       64
i99     0       64
e
</CsScore>
</CsoundSynthesizer>

