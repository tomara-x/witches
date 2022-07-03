//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

instr 1
kA1[] init 3, 3
kA1 = 2 ;only 6 elements assigned
printarray kA1
endin
schedule(1, 0, 0.01)

instr 2
kA1[] init 4, 6
kA1 = 2 ;only 10 assigned
printarray kA1
endin
schedule(2, 0, 0.01)

;I'M TOO LAZY TO WRITE A LOOP AND TEST MORE DIMENTIONS
</CsInstruments>
</CsoundSynthesizer>

