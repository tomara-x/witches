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
ktempo      =           265 ;bpm
ktimeunit   =           1/(ktempo/60)
klen[]      fillarray   1,    1,    1,    1,    1,    1/2,  1,    1
kbAS,kbtrig[] uBasemath ktimeunit, klen

knotes[]    fillarray   0,    0,    0,    0,    0,    0,    0,    0
kincs[]     fillarray  .1,   .3,    0,    0,   .2,   .2,   .5,    0
kQ[]        fillarray   0,    0,    0,    0,    0,    0,    0,    0
ktAS, kpitch[], kttrig[] Taphath kbtrig[kbAS], knotes, kincs, kQ, gi31tet
kQ[ktAS]     = kQ[ktAS] * 0

schedkwhen  kbtrig[kbAS], 0, 0, "string", 0, .1, kpitch[ktAS]
endin

instr 2
ktempo      =           265 ;bpm
ktimeunit   =           1/(ktempo/60)
klen[]      fillarray   8,    1,     1,    0
kbAS,kbtrig[] uBasemath ktimeunit, klen, 0,1

schedkwhen  kbtrig[kbAS], 0, 0, "hat", 0, .00001
endin

instr string
iplk    =           0.1 ;(0 to 1)
kamp    init        0.15
icps    =           p4
kpick   init        0.9 ;pickup point
krefl   init        0.9 ;rate of decay? ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl

;adist   cmp         asig, ">", 0
;adist   *=          0.1
;asig    +=          adist
;asig    bqrez       asig, icps*8, 30
asig    limit       asig, -0.4,0.4

kenv    linsegr     1,p3,1,0.5,0 ;to avoid end click
asig    *=          kenv

        outs        asig,asig
gaRvbSend += asig*0.8
endin

/*
instr 2
ktempo      =   113
ktimeunit   =   1/(ktempo/60) ;whole note

klen[]      fillarray   1,    1,    1,    1
klgain[]    fillarray   0,    0,    0,    0
kminlen[]   fillarray   0,    0,    0,    0
kmaxlen[]   fillarray   8,    8,    8,    8

kdiv[]      fillarray   2,    0,    0,    0
kdgain[]    fillarray   0,    0,    0,    0
kmaxdiv[]   fillarray   8,    8,    8,    8

kQ[]        fillarray   0,    0,    0,    0

kbAS, kbtrig[], kbdiv[] Basemath ktimeunit, klen,klgain,kminlen,kmaxlen, kdiv,kdgain,kmaxdiv, kQ
schedkwhen  kbtrig[kbAS], 0, 0, "test", 0, .1, 440*(2^3)
schedkwhen  kbdiv[kbAS], 0, 0, "test", 0, .1, 440*(2^4)
endin
*/

instr hat
aenv    expsegr 1,p3,1,0.08,0.001
asig    noise   0.1*aenv, 0
outs    asig, asig
gaRvbSend += asig*0.8
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
t       0       265
;i1      0       64
i2      0       64
e
</CsScore>
</CsoundSynthesizer>

