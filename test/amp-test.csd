//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

// was testing the amp<->db converters
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

;instr 1
;print(ampdb(-48))
;print(ampdbfs(-48))
;endin

;instr 2
;print(dbamp(.005))
;print(dbfsamp(.005))
;endin

instr Main
ii init -69
while ii < 20 do
    print ii, ampdb(ii)
    ii += 1
od
endin
schedule("Main", 0, 1)

</CsInstruments>
;<CsScore>
;i1  0 .1
;i2 .1 .1
;</CsScore>
</CsoundSynthesizer>
