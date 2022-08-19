//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   1
0dbfs   =   1

#include "utils.orc"

instr 1
aSig1 = vco2(1, 440, 10)
aSig2 = SubOct(aSig1, 8, 0, 0)
aSig2 -= 0.5
aSig2 *= 2
aSig2 butlp aSig2, 1000
out (aSig1+aSig2)*.05
endin
schedule(1, 0, 2)

</CsInstruments>
</CsoundSynthesizer>


