//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
;-odac -Lstdin -m231
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

instr 1
  kA[] fillarray 1, 2, 3, 4
  kB[] = kA * 2   ; the same happends if kB was inited before
  printarray kA
  printarray kB
  turnoff
endin
schedule(1, 0, .1)

</CsInstruments>
;<CsScore>
;</CsScore>
</CsoundSynthesizer>


