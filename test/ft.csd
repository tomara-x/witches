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

giftmp1  ftgen 0,0,64, 10, 1
giampfn  ftgen 0,0,64,-24, giftmp1, 0, 0.05 ;rescale

instr 1
print(ftlen(giampfn))
ftprint giampfn
endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
