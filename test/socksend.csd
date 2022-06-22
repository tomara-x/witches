//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//don't know if this is better than osc with letency, i didn't finish
//researching this
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   100
nchnls  =   2
0dbfs   =   1

instr Main
aSig oscili 0.1, 880
socksend aSig, "192.168.1.173", 7777, 200
endin
</CsInstruments>
<CsScore>
i"Main" 0 120
e
</CsScore>
</CsoundSynthesizer>


