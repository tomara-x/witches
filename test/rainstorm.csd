//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
;-odac -Lstdin -m227 ;-m231
-n -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

#include "../rainstorm.orc"

instr rain
iFn ftgenonce 0,0,-12,-51,3,2,440,0, 1,2^(3/12),2^(7/12)
kNdx[] fillarray 2, 4, 1, 3
kVal[] Rainstorm kNdx, iFn
printarray kVal
endin
schedule("rain", 0, 0.1)

</CsInstruments>
</CsoundSynthesizer>


