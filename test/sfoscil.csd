//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   1
0dbfs   =   1

#include "oscillators.orc"

instr 1
km1, km2, kn1, kn2, kn3, ka, kb = 4,6,3, 1,1,1,1
aSig SuperFormula 440, km1, km2, kn1, kn2, kn3, ka, kb
aSig limit aSig, -1, 1
out aSig
endin
schedule(1, 0, 10)

</CsInstruments>
</CsoundSynthesizer>


