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
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

instr 1
if1 = cpspch(8.09)
if2 = cpspch(8.10) ;why 466.177? why not 466.164?
print(if1, if2)
icpsint = if1 - if2
ioctint = octcps(if1) - octcps(if2)
print(icpsint, ioctint)
print(pchoct(ioctint))
endin

instr 2
;this a intonation thing, ain't it?
;^nope...
ii = 0
while ii <= 12 do
    icps = cpspch(8)*2^(ii/12)
    print(icps, cpspch(8 + ii/100))
    ii += 1
od
endin

instr 3
;okay so cpspch internally converts to oct first then to cps
;yep, it's stil the same behaviour here
;boss! it's this same anomaly from 9 years ago.. i mean from the taphy ft interpolation!
ii = 0
while ii <= 12 do
    icps = cpspch(8)*2^(ii/12)
    print(icps, cpsoct(8 + ii/12))
    ii += 1
od
endin
</CsInstruments>
<CsScore>
;i1 0 0.1
i2 0 0.1
i3 0 0.1
e
</CsScore>
</CsoundSynthesizer>


