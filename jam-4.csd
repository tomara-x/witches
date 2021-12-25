trans rights
/*
Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
*/
<CsoundSynthesizer>
<CsOptions>
; Real-time / render
-odac -L stdin -m 231
; -o rose.wav
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   2
0dbfs   =   1

#define TEMPO #128#
#include "opcodes.orc"
#include "function-tables.orc"
gaRvbSend init 0
alwayson "verb"
gaDstSend init 0
alwayson "dist"

instr 1
ktrig   metro 128*4/60
knote[] fillarray p4,p5,p6,p7
kincs[] fillarray 0, 8, 4, 2
kQ[]    fillarray 0, 0, 0, 0
kAS, kp[], kt[] Taphath ktrig, knote, kincs, kQ, giud
kcps    = kp[kAS]
aop1    poscil .1, kcps
aop2    poscil .1, kcps/2
aop3    Pmoscili 0.2, kcps/1, aop1+aop2
aop4    Pmoscili 0.2, kcps/2, aop1+aop2
aop5    Pmoscili 0.2, kcps/1, aop1+aop2
aop6    Pmoscili 0.5, kcps/1, aop3
aop7    Pmoscili 0.5, kcps/2, aop4
aop8    Pmoscili 0.5, kcps/2, aop5
aout    = aop6 + aop7 + aop8
aout    = aout * 0.1
;aout    limit aout, -0.4, 0.4
outs    aout, aout
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
t       0       128
i1      0       16       4 32 12 14
i1      +       16       4 12 21 7
i1      +       16       0 16 8  9
i1      +       16       7 21 0  14
i1      +       16       8 9  10 12
e
</CsScore>
</CsoundSynthesizer>

