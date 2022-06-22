//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//very old array test
<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

instr 1
k1[]    fillarray   0,0,0,0,0
ilen = lenarray(k1)
print ilen

;if k1 > -1 then
;    printk2 k1[0]
;endif

;kval    maxarray    k1
;if kval == 0 then
;    printk2 kval
;endif

;kn = 0
;while kn < lenarray(k1) do
;    k2[kn] = wrap(k1[kn], 0, 2)
;    kn += 1
;od
endin

instr fa
iarr[] fillarray 2, 4, 5
printarray iarr
endin
schedule("fa", 0, 1)

</CsInstruments>
<CsScore>
;i1 0 .1
</CsScore>
</CsoundSynthesizer>
