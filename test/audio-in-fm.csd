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
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #60#
#include "../utils.orc"
#include "../oscillators.orc"
#include "../mixer.orc"

instr Main
aSig soundin "../28.11.21.wav"
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili aSig, randomi:k(100,1000,0.01), aOp08+aOp09+aOp13
aOp01   Pmoscili aSig, randomi:k(100,1000,0.01), aOp00
aOp02   Pmoscili aSig, randomi:k(100,1000,0.03), aOp03
aOp03   Pmoscili aSig, randomi:k(100,1000,0.01), aOp01+aOp04+aOp05
aOp04   Pmoscili aSig, randomi:k(100,1000,0.01), aOp00
aOp05   Pmoscili aSig, randomi:k(100,1000,0.04), aOp00
aOp06   Pmoscili aSig, randomi:k(100,1000,0.02), aOp03
aOp07   Pmoscili aSig, randomi:k(100,1000,0.01), aOp03
aOp08   Pmoscili aSig, randomi:k(100,1000,0.02), aOp12
aOp09   Pmoscili aSig, randomi:k(100,1000,0.01), aOp12
aOp10   Pmoscili aSig, randomi:k(100,1000,0.07), aOp15
aOp11   Pmoscili aSig, randomi:k(100,1000,0.01), aOp15
aOp12   Pmoscili aSig, randomi:k(100,1000,0.05), aOp10+aOp11+aOp14
aOp13   Pmoscili aSig, randomi:k(100,1000,0.08), aOp12
aOp14   Pmoscili aSig, randomi:k(100,1000,0.02), aOp15
aOp15   Pmoscili aSig, randomi:k(100,1000,0.03), aSig
aFM10Out = aOp02+aOp06+aOp07

sbus_write 0, aFM10Out

;out
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM

outs aL, aR

endin
schedule("Main", 0, 120)

</CsInstruments>
</CsoundSynthesizer>


