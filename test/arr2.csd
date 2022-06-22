//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
;fillarray length at i time
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

/*
instr Main
karr[] fillarray 2, 4, 5, 3, 2
print(lenarray(karr))
printarray karr
endin
*/
instr Main
kv init 0
kv += 1
karr[] fillarray 2, 4, 5, 3, kv
print(lenarray(karr))
printarray karr
endin
schedule("Main", 0, .05)

</CsInstruments>
</CsoundSynthesizer>
