//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
;-n -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

#include "../perfuma.orc"

instr perfuma
km[] fillarray 2, 4, 1, 3
kd[] fillarray 5, 2, 1, 2
kM[], kD[] Perfuma 2, km, kd

schedkwhen(kM[0],0,0, "beep", 0, 0.05, 440*2^3)
;schedkwhen(kM[1],0,0, "beep", 0, 0.05, 440*2^1)
;schedkwhen(kM[2],0,0, "beep", 0, 0.05, 440*2^2)
;schedkwhen(kM[3],0,0, "beep", 0, 0.05, 440*2^3)

schedkwhen(kD[0],0,0, "beep", 0, 0.05, 440*2^4)
;schedkwhen(kD[1],0,0, "beep", 0, 0.05, 440*2^5)
;schedkwhen(kD[2],0,0, "beep", 0, 0.05, 440*2^6)
;schedkwhen(kD[3],0,0, "beep", 0, 0.05, 440*2^7)

/*
if sumarray(kM) == 4 then
    printks("in sync\n", 0)
elseif kM[2] == 1 then
    printks("out of sync\n", 0)
endif    
*/

endin
schedule("perfuma", 0, 60)

instr beep
out oscil(0.2, p4)
endin

</CsInstruments>
</CsoundSynthesizer>


