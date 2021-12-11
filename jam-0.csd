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

gaRvbSend init 0
alwayson "verb"

gifftsize = 1024
gioverlap = gifftsize/4
giwinsize = gifftsize
giwinshape = 1 ;von-Hann window

instr 1
ktempo      =           113 ;bpm
ktrig       metro       113/2/60

knotes[]    fillarray   0,    7,    14,   21
kincs[]     fillarray   0,    0,    0,    4
kQ[]        fillarray   0,    0,    0,    0
kAS, kpitches[], ktrigs[] Taphath ktrig, knotes, kincs, kQ, gifn1, 0
kQ[kAS]     = kQ[kAS] * 0

;kAS, kpitches[], ktrigs[] uTaphath ktrig, knotes, gifn1, 0
;if ktrig == 1 then
;    printarray     kpitches
;    printarray     ktrigs
;endif

schedkwhen  ktrig, 0, 0, 3, 0, 1, kpitches[kAS]
endin

instr 2 ;hat
aenv    expsegr 1,p3,1,0.04,0.001
asig    noise   0.1*aenv, 0
outs    asig, asig
gaRvbSend += asig*0.8
endin

instr 3
iplk    =           0.1 ;(0 to 1)
kamp    init        0.15
icps    =           p4
kpick   init        0.9 ;pickup point
krefl   init        0.8 ;rate of decay? ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl

kenv    linsegr     1,p3,1,0.5,0 ;to avoid end click
asig    *=          kenv

asig    bqrez       asig, icps*8, 30
asig    limit       asig, -0.4,0.4

        outs        asig,asig
gaRvbSend += asig*0.8
endin

instr 4
ktempo      =   113
ktimeunit   =   1/(ktempo/60) ;whole note

klen[]      fillarray   1,    1,    1,    1
klgain[]    fillarray   0,    0,    0,    0
kminlen[]   fillarray   0,    0,    0,    0
kmaxlen[]   fillarray   8,    8,    8,    8

kdiv[]      fillarray   0,    0,    0,    4
kdgain[]    fillarray   0,    0,    0,    0
kmaxdiv[]   fillarray   4,    4,    4,    8

kQ[]        fillarray   0,    0,    0,    0

kbAS, kbtrig[], kdiv[] Basemath ktimeunit, klen,klgain,kminlen,kmaxlen,
    kdiv,kdgain,kmaxdiv, kQ
schedkwhen  kbtrig[kbAS], 0, 0, "test", 0, .1, 440*(2^3)
schedkwhen  kdiv[kbAS], 0, 0, "test", 0, .1, 440*(2^4)

;iif kbtrig[kbAS] == 1 then
;    printarray(kbtrig)
;endif
;knotes[]    fillarray   0,    7,    14,   21
;ktAS, kpitch[], kttrig[] uTaphath kbtrig[kbAS], knotes, gifn1
endin

instr test
asig oscil 0.8, p4
outs asig, asig
endin

/*
instr 5 ;octave down
ain     soundin "foreheadkisses.wav"
fftin   pvsanal ain, gifftsize, gioverlap, giwinsize, giwinshape
fftscal pvscale fftin, 1/2
aout    pvsynth fftscal
;aout    = (aout+ain)/2
        outs    aout, aout
endin
*/
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
t       0       113
i4      0       64
e
</CsScore>
</CsoundSynthesizer>

