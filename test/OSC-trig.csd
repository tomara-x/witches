//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
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

gicharles OSCinit 9000

instr beep
out oscil(0.4, p4)
endin

instr Main
ktrig init 0
kmes OSClisten gicharles, "/oscControl/gridToggle1", "i", ktrig
printk2 ktrig
endin
schedule("Main", 0, 60)

</CsInstruments>
</CsoundSynthesizer>


