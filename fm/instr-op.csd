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
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #113#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#

#include "../sequencers.orc"
#include "../utils.orc"

gay, gal, gar init 0

instr Taphy
iScale ftgenonce 0,0,-7*3,-51, 7, 2, cpspch(6), 0,
1,2^(2/12),2^(4/12),2^(5/12),2^(7/12),2^(9/12),2^(11/12) ;omfg! major key!
kTrig    metro $FRQ*4
kNote[]  fillarray 1, 2, 3, 4, 2, 2, 0, 1,  1,1,1,1,1,1,1,1
kTrans[] fillarray 0, 0, 0, 0, 0, 0, 0, 0,  0,0,0,0,0,0,0,0
kQueue[] init 16
kS, kP[], kT[], kI[] Taphath kTrig, kNote, kTrans, kQueue, iScale
endin

gaOps[] init 17 ;index 16 for empty modulation
instr Op
;setksmps 1
aEnv  linseg 0, p4, 1, p5, 1, p6, 0
acar  phasor kfreq
aphs  = gaOps[p7]
asig  tablei acarrier+aphs, -1, 1,0,1
gaOps[p8] += asig
endin

instr Out
kSM = 1
gal limit gal+gay, -kSM, kSM
gar limit gar+gay, -kSM, kSM
outs gal, gar
clear gay, gal, gar
endin
</CsInstruments>
<CsScore>
i"Out"  0 10
e
</CsScore>
</CsoundSynthesizer>


