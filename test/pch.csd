//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
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

instr Main
ii init 10
while ii > -4 do
    print ii, cpspch(ii);+0.09)
    ii -= 1
od
endin
</CsInstruments>
<CsScore>
i"Main" 0 1
e
</CsScore>
</CsoundSynthesizer>


