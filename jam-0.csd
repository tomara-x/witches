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

instr 1
ktempo      =           113 ;bpm
ktimeunit   =           1/(ktempo/60) ;1 whole note at tempo in seconds
kclkd4      metro       ktempo/60/4
ktimes[]    fillarray   1,    1,    1,    1+4 ; <- think tied note
kmaxlen[]   fillarray   8,    8,    8,    8
;k1[] init 4
;k2[] fillarray 1, 1, 32, 1
;k3[] fillarray 1, 1, 33, 1
;ktrig, ksub, ktrigArrB[] Basemath ktimeunit, ktimes,k1,k2,k1,k3,k1, kmaxlen
ktrig, ktrigArrB[] uBasemath ktimeunit, ktimes, kmaxlen

knotes[]    fillarray   0,    7,    14,   21
kptch, ktrigArrT[], kptchArr[] uTaphath ktrig, knotes, gifn1

schedkwhen  ktrig, 0, 0, 3, 0, 1, kptch
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
i1      0       64
e
</CsScore>
</CsoundSynthesizer>

