//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//thank you, mog
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   128
nchnls  =   2
0dbfs   =   1

#define TEMPO #60#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

#include "mycorrhiza.orc"
#include "perfuma.orc"
#include "rainstorm.orc"
#include "oscillators.orc"
#include "utils.orc"
#include "mixer.orc"


instr Seed
tree_init(32, 8, 16)                ;32 nodes, 8 values and 16 branches each
iarr[] = fillarray(1, 2)
node_connect_i(0, iarr)             ;connect nodes 1,2 as branches of 0
iarr[] = fillarray(3, 4, 5)
node_connect_i(1, iarr)             ;connect nodes 3, 4, 5 as branches of 1
node_connect_i(3, 6)                ;connect node 6 as branch of 3
iarr[] = fillarray(7, 8, 9)
node_connect_i(2, iarr)             ;connect 7, 8, 9 as branches of 2

iarr[] = fillarray(17, 18)
node_connect_i(16, iarr)
iarr[] = fillarray(19, 20, 21)
node_connect_i(17, iarr)
iarr[] = fillarray(22, 23)
node_connect_i(18, iarr)
node_connect_i(19, 24)
node_connect_i(23, 25)


seed(42)
iScale ftgenonce 0,0,-32,-51, 5,2,cpspch(6.05),0,
1,2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(11/12) ;F harmonic minor
icnt = 0
while icnt < 32 do
    ;set first value of each node to each note from the scale
    node_set_value_i(icnt, 0, table(icnt, iScale))
    icnt += 1
od
endin
schedule("Seed", 0, 0)              ;run instr for i-pass only



instr Water
kS, kR init -1
kTrig = MyMetro($FRQ)
kMul[] fillarray 2, 4, 8, 4, 1, 8, 6, 1
kDiv[] fillarray 2, 1, 2, 2, 1, 3, 3, 1
kM[], kD[] Perfuma $FRQ, kMul, kDiv
kS += kTrig
kR += kTrig
kS = wrap(kS, 0, 8)
if kD[kS] != 0 then
    kN = node_climb2(0)
    schedulek(nstrnum("FM2")+0.1, 0, -1, $BEAT*kDiv[kS]/kMul[kS], kN, .1, 0)
endif
if kM[kS] != 0 then
    kN = node_climb2(16)
    schedulek(nstrnum("FM2")+0.2, 0, -1, $BEAT/kMul[kS], kN, .01, 4)
endif
endin
schedule("Water", 0, 120)


instr FM2
kFrq = node_get_value_k(p5, 0)
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07,
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoi p6, kFrq*2^00, aOp01+aOp04+2*aOp05+aOp06+aOp09, p7*.01
aOp01   Pmoi p6, kFrq*2^00, aOp05+aOp06,                     p7*.01
aOp02   Pmoi p6, kFrq*2^00, aOp05+aOp06,                     p7*.01
aOp03   Pmoi p6, kFrq*2^00, aOp02+aOp07+2*aOp06+aOp05+aOp10, p7*.01
aOp04   Pmoi p6, kFrq*2^00, aOp05+aOp09,                     p7*.01
aOp05   Pmoi p6, kFrq*2^00,                                  p7*.01
aOp06   Pmoi p6, kFrq*2^00,                                  p7*.01
aOp07   Pmoi p6, kFrq*2^00, aOp06+aOp10,                     p7*.01
aOp08   Pmoi p6, kFrq*2^00, aOp05+aOp09,                     p7*.01
aOp09   Pmoi p6, kFrq*2^00,                                  p7*.01
aOp10   Pmoi p6, kFrq*2^00,                                  p7*.01
aOp11   Pmoi p6, kFrq*2^00, aOp06+aOp10,                     p7*.01
aOp12   Pmoi p6, kFrq*2^00, aOp08+aOp13+2*aOp09+aOp05+aOp10, p7*.01
aOp13   Pmoi p6, kFrq*2^00, aOp09+aOp10,                     p7*.01
aOp14   Pmoi p6, kFrq*2^00, aOp09+aOp10,                     p7*.01
aOp15   Pmoi p6, kFrq*2^00, aOp11+aOp14+2*aOp10+aOp06+aOp09, p7*.01
aSig = aOp00 + aOp03 + aOp12 + aOp15
sbus_mix 0, aSig
endin


instr Out
aL, aR sbus_out
aL clip aL, 0, 1
aR clip aR, 0, 1
outs aL, aR
sbus_clear_all
endin
</CsInstruments>
<CsScore>
i"Out" 0 122
e
</CsScore>
</CsoundSynthesizer>

