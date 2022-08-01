//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;just testing amp levels, hot girl shit
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

gay init 0

instr Pmo
aSig init 0
aSig = Pmoscilx(db(-6), 220, .6, 1, -1)
gay = aSig
endin
;schedule("Pmo", 0, 20)

instr 1
aS1 = Pmoscilx(db(-6), 220,     .2)
aS2 = Pmoscilx(db(-6), 440, aS1*linseg(0.3, p3, 6), .4)
;^ lol finally! aliasing! i have no regrets, my life is complete

gay = aS2
endin
schedule(1, 0, 20)

instr Out
;gay clip gay, 0, 1
out gay
endin
schedule("Out", 0, 20)

</CsInstruments>
</CsoundSynthesizer>


