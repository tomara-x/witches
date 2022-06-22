//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

;write to function tables manually
instr 1
ifn1 ftgenonce 0,0,8,-7, 0,8,8
ifn2 ftgenonce 0,0,8,-2, 0
ii = 0
while ii < 8 do
    tablew(ii, ii, ifn2)
    ii += 1
od
ftprint ifn1
ftprint ifn2
endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
