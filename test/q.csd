//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

#define TEMPO #256#
#define FRQ #($TEMPO/60)#

instr Seq1
;kTrig    metro $FRQ

kQ[] init 3, 3 ;4 steps, 8-step long q each
kQ = 2
printarray kQ

;kS = 0 ;step tracker variable (can have muliple)
;if kTrig == 1 then
;    kS = kQ[kS][0] ;jump to first step in the q of current step
;endif
endin
</CsInstruments>
<CsScore>
i"Seq1" 0 .1
</CsScore>
</CsoundSynthesizer>

