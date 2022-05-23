//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//BASS!
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #96#
#include "../sequencers.orc"
#include "../oscillators.orc"
#include "../utils.orc"
;taphy
#define ROW #4# ;global array rows (number of simultanious instances)
#define COL #8# ;global array columns (length)
gkTaphyAS[]     init $ROW
gkTaphyP[][]    init $ROW, $COL
gkTaphyT[][]    init $ROW, $COL
gkTaphyTrig[]   init $ROW
gkTaphyNote[][] init $ROW, $COL
gkTaphyGain[][] init $ROW, $COL
gkTaphyQ[][]    init $ROW, $COL
gkTaphyMin[][]  init $ROW, $COL
gkTaphyMax[][]  init $ROW, $COL
;pluck
gaPluckOut[]    init $ROW

instr Taphy
iScale ftgenonce 0,0,-7*10,-51, 7,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
kAS, kP[], kT[] Taphath gkTaphyTrig[p4],getrow(gkTaphyNote,p4),
                getrow(gkTaphyGain, p4),getrow(gkTaphyQ, p4),
                getrow(gkTaphyMin, p4), getrow(gkTaphyMax, p4), iScale
gkTaphyAS[p4] = kAS
gkTaphyP setrow kP, p4
gkTaphyT setrow kT, p4
endin

instr Pluck
iplk    =           p6 ;(0 to 1)
kamp    init        0.1
icps    =           p5
kpick   init        0.7 ;pickup point
krefl   init        p7 ;rate of decay ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl
;asig    rbjeq       asig, 200, 2, 0, 8, 10
kenv    linseg      1, p3, 0 ;declick
gaPluckOut[p4] = asig*kenv
endin

instr Main
kTrig0      metro $TEMPO/60
kC0[]       fillarray 2, 4, 2, 8, 8, 4, 1, 2, 1, 2, 4, 2, 2, 6, 8, 8
kG0[]       fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kMin[]      fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kMax[]      fillarray 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
kQ[]        fillarray 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
kAS0, kT0[] tBasemath kTrig0, kC0, kG0, kMin, kMax, kQ
kTrig4      metro $TEMPO*2/60

;Taphy
gkTaphyTrig[0] = kTrig4
gkTaphyNote = setrow(fillarray(3, 20, 4, 3, 6, 7, 8, 0), 0)
gkTaphyGain = setrow(fillarray(5, 1, 0, 2, 0, 1, 0, 0), 0)
kc2 init 0
while kc2 < $COL do
    gkTaphyMin[0][kc2] = 0
    gkTaphyMax[0][kc2] = 14+1
    kc2 += 1
od
schedule("Taphy", 0, p3, 0)

;pluck                                              ;pr   dr   rl
schedkwhen(kTrig4,0,0,"Pluck",0,1/($TEMPO*2/60), 0, gkTaphyP[0][gkTaphyAS[0]]/2,.1,.8)

;mix 🎚️🎚️🎚️🎚️🎛️ (db scale, amy)
aOutL = gaPluckOut[0]*0.5
aOutR = gaPluckOut[0]*0.5
outs aOutL, aOutR
endin
schedule("Main", 0, 120*($TEMPO/60)) ;120 beats
</CsInstruments>
</CsoundSynthesizer>

