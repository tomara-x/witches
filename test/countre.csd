//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//clock divider opcode test
<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

opcode clkdiv, k, kk
/*
Clock divider. Outputs 1 on the nth time the in-signal is non-zero.
Syntax: kout clkdiv ksig, kn
*/
ksig, kn xin
kcount init 0
kout = 0
if ksig != 0 then
	kcount += 1
endif
if kcount >= abs(kn) then
	kout = 1
	kcount = 0
endif
xout kout
endop

instr 1
ktrig		metro		10
kdiv		clkdiv		ktrig, 4

printf("metro = %f, divb = %f\n", ktrig, ktrig, kdiv)
endin

</CsInstruments>
<CsScore>
i1 0 1
</CsScore>
</CsoundSynthesizer>
