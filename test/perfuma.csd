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
ksmps   =   42
nchnls  =   1
0dbfs   =   1

#include "../perfuma.orc"

instr perfuma
/*
km[] init 4
kd[] init 4

km[0] rspline 0, 8, 1, 2
km[1] = km[0] * 2
km[2] = km[0] * 4
km[3] = km[0] * 3

kd[0] rspline 0, 4, 1, 2
kd[1] rspline 0, 4, 1, 2
kd[2] rspline 0, 4, 1, 2
kd[3] rspline 0, 4, 1, 2

kM[], kD[] Perfuma 2, km, kd
*/

kM[] init 4
kF rspline 0, 18, 1, 8
kF *= 2
kM[0] metro kF
kM[1] metro kF * 2
kM[2] metro kF * 4
kM[3] metro kF * 3

schedkwhen(kM[0],0,0, "beep", 0, 0.05, 440*2^3)
;schedkwhen(kM[1],0,0, "beep", 0, 0.05, 440*2^1)
;schedkwhen(kM[2],0,0, "beep", 0, 0.05, 440*2^2)
;schedkwhen(kM[3],0,0, "beep", 0, 0.05, 440*2^3)

;schedkwhen(kD[0],0,0, "beep", 0, 0.05, 440*2^4)
;schedkwhen(kD[1],0,0, "beep", 0, 0.05, 440*2^5)
;schedkwhen(kD[2],0,0, "beep", 0, 0.05, 440*2^6)
;schedkwhen(kD[3],0,0, "beep", 0, 0.05, 440*2^7)

if sumarray(kM) == 4 then
    printks("in sync\n", 0)
elseif kM[0] == 1 then
    printks("out of sync\n", 0)
endif    

endin
schedule("perfuma", 0, 60)

instr beep
out oscil(0.2, p4)
endin

</CsInstruments>
</CsoundSynthesizer>


