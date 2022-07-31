//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   1
nchnls  =   1
0dbfs   =   1

;#include "oscillators.orc"

opcode Pmoscili, a, kkaj
kamp, kfreq, aphs, ifn xin
acar phasor kfreq
asig tablei acar+aphs, ifn, 1,0,1
xout asig*kamp
endop

opcode Pmoscili2, a, kkaOj
kamp, kfreq, aphs, kfb, ifn xin
asig init 0
acar phasor kfreq
klastsamp init 0
ki = 0
while ki < ksmps do
    if ki == 0 then
        aphs[ki] = aphs[ki] + klastsamp*kfb
    else
        aphs[ki] = aphs[ki] + asig[ki-1]*kfb
    endif
    asig[ki] tablei acar[ki]+aphs[ki], ifn, 1,0,1
    ki += 1
od
klastsamp = asig[ksmps-1]
xout asig*kamp
endop


gay init 0

instr Pmo
aSig init 0
;same as `aSig = Pmoscili(.1, 440, aSig*5)` on ksmps = 1
aSig = Pmoscili2(.1, 440, a(0), .5)
gay = aSig
endin
schedule("Pmo", 0, 20)

instr Out
gay clip gay, 0, 1
out gay
endin
schedule("Out", 0, 20)

</CsInstruments>
</CsoundSynthesizer>


