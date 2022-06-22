//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//time loop
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
icnt init 1
top:
timout 0, 1, end
reinit top
print icnt
icnt += 1
end:
endin
schedule(1, 0, 10)
</CsInstruments>
</CsoundSynthesizer>


