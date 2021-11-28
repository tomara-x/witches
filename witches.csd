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

