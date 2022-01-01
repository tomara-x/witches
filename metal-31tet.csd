trans rights

/*
Copyright © 2021-2022 Amy Universe <nopenullnilvoid00@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
*/

; this one's for you, K

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

instr 1
ktempo      =           256 ;bpm
ktimeunit   =           1/(ktempo/60)
klen[]      fillarray   1,    1,    1,    1
kbAS,kbtrig[] uBasemath ktimeunit, klen

knotes[]    fillarray   0,    9,    0,    4
kincs[]     fillarray   1,    3,    3,    0
kQ[]        fillarray   0,    0,    0,    0
ktAS, kpitch[], kttrig[] Taphath kbtrig[kbAS], knotes, kincs, kQ, gi31tet
kQ[ktAS]     = kQ[ktAS] * 0

schedkwhen  kbtrig[kbAS], 0, 0, "string", 0, .1, kpitch[ktAS]
endin

instr 2
ktempo      =           256 ;bpm
ktimeunit   =           1/(ktempo/60)
klen[]      fillarray   0,    0,    0,    8
kbAS,kbtrig[] uBasemath ktimeunit, klen

knotes[]    fillarray   0,    0,    0,    1
ktAS,kpitch[],kttrig[] uTaphath kbtrig[kbAS], knotes, gi31tet
schedkwhen  kbtrig[kbAS], 0, 0, "string", 0, .1, kpitch[ktAS]
endin

instr string
iplk    =           0.1 ;(0 to 1)
kamp    init        0.15
icps    =           p4
kpick   init        0.9 ;pickup point
krefl   init        0.9 ;rate of decay? ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl

kenv1   linsegr     1,0.4,0,0.5,0
asig    bqrez       asig, kenv1*p4*4, 10
;adist   cmp         asig, ">", 0
;adist   bqrez       adist, 500, 40
asig    limit       asig, -0.4,0.4

kenv2   linsegr     1,p3,1,0.5,0 ;to avoid end click
asig    *=          kenv2

        outs        asig,asig
gaRvbSend += asig*0.1
endin

;instr 5
;ktempo      =   256
;ktimeunit   =   1/(ktempo/60) ;whole note
;
;klen[]      fillarray   1,    1,    1,    1
;klgain[]    fillarray   0,    0,    0,    0
;kminlen[]   fillarray   0,    0,    0,    0
;kmaxlen[]   fillarray   8,    8,    8,    8
;
;kdiv[]      fillarray   0,    0,    0,    1
;kdgain[]    fillarray   0,    0,    0,    0
;kmaxdiv[]   fillarray   8,    8,    8,    8
;
;kQ[]        fillarray   0,    0,    0,    0
;
;kbAS, kbtrig[], kbdiv[] Basemath ktimeunit, klen,klgain,kminlen,kmaxlen, kdiv,kdgain,kmaxdiv, kQ
;schedkwhen  kbtrig[kbAS], 0, 0, "test", 0, .1, 440*(2^3)
;schedkwhen  kbdiv[kbAS], 0, 0, "test", 0, .1, 440*(2^4)
;endin

instr test
asig oscil 0.8, p4
outs asig, asig
endin

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
t       0       256
;1i1      0       128
i2      0       64
e
</CsScore>
</CsoundSynthesizer>

