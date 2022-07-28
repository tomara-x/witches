//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   2^15
ksmps   =   64
nchnls  =   1
0dbfs   =   1

#include "../basma.orc"

#define TEMPO #128#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

;testing general functionality and overloads
instr 1
kTimUnit = $BEAT
kLen[]    fillarray 1, 2, 1, 2
kMin[]    fillarray 0, 0, 0, 0
kMax[]    fillarray 17,17,17,17
kDiv[]    fillarray 1, 1, 2, 3
kMaxDiv[] fillarray 8, 8, 8, 8
kQ[]      fillarray 0, 0, 0, 0
kS, kT[], kD[] Basma kTimUnit, kLen, kMin, kMax, kDiv, kMaxDiv, kQ

;it can be easier to see this on a spectrum analyzer (phone app maybe) than to hear it
schedkwhen(kT[kS],0,0, "beep", 0, 0.05, 440*2^2)
schedkwhen(kD[kS],0,0, "beep", 0, 0.05, 440*2^3)
endin
;schedule(1, 0, 60)

;testing sync
;falls out of sync with sr=44100 and ksmps=42
;stays in sync with sr=2^15 and ksmps=64
instr 2
kTimUnit = $BEAT/2
kLen1[]   fillarray 1, 2, 1, 2
kLen2[]   fillarray 1, 2, 1, 1/3, 1/3, 1/3, 1
kDiv1[]   fillarray 1, 1, 1, 1
kDiv2[]   fillarray 1, 1, 1, 1, 1, 1, 1
kQ1[]     fillarray 0, 0, 0, 0
kQ2[]     fillarray 0, 0, 0, 0, 0, 0, 0
kS1, kT1[], kD1[] Basma kTimUnit, kLen1, 0, 4, kDiv1, 4, kQ1
kS2, kT2[], kD2[] Basma kTimUnit, kLen2, 0, 4, kDiv2, 4, kQ2

schedkwhen(kT1[0],0,0, "beep", 0, 0.05, 440*2^2)
schedkwhen(kT2[0],0,0, "beep", 0, 0.05, 440*2^3)

if kT1[0] + kT2[0] == 2 then
    printks("in sync\n", 0)
elseif kT1[0] == 1 then
    printks("out of sync\n", 0)
endif    
endin
schedule(2, 0, 60)

instr beep
out oscil(0.4, p4)
endin

</CsInstruments>
</CsoundSynthesizer>

