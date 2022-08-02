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
sr      =   48000
ksmps   =   64
nchnls  =   2
0dbfs   =   1

#define TEMPO #120#
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
iarr[] = fillarray(1, 2, 3, 4)
node_connect_i(0, iarr)             ;connect nodes 1,2,3,4 as branches of 0
iarr[] = fillarray(5, 6, 7, 8)
node_connect_i(1, iarr)             ;connect nodes 5,6,7,8 as branches of 1
iarr[] = fillarray(9, 10, 11)
node_connect_i(2, iarr)             ;repeated twice
node_connect_i(2, iarr)             ;2 will have 9,10,11,9,10,11 as branches
node_connect_i(3, 12)               ;connect node 12 as branch of 3
iarr[] = fillarray(13, 14, 15)
node_connect_i(12, iarr)            ;connect 13,14,15 as branches of 12

iarr[] = fillarray(17, 18, 19, 20)
node_connect_i(16, iarr)
iarr[] = fillarray(21, 22, 23)
node_connect_i(18, iarr)
iarr[] = fillarray(24, 25, 26)
node_connect_i(23, iarr)
iarr[] = fillarray(27, 28)
node_connect_i(24, iarr)
node_connect_i(19, 29)
node_connect_i(20, 30)
node_connect_i(25, 31)


seed(42)
;generate 2 octaves of a scale
iScale ftgenonce 0,0,-2*7,-51, 7,2,110,0,
1,2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(11/12) ;A harmonic minor
icnt = 0
while icnt < 32 do
    ;set first value of each node to random note from the scale
    node_set_value_i(icnt, 0, table(random:i(0,14), iScale))
    icnt += 1
od
endin
schedule("Seed", 0, 0)              ;run instr for i-pass only



instr Water
kS, kR init -1
kTrig = MyMetro($FRQ)
kMul[] fillarray 8, 4,16, 8, 4, 8, 2, 1
kDiv[] fillarray 8, 2, 4, 2, 1, 4, 1, 1
kM[], kD[] Perfuma $FRQ, kMul, kDiv
kS += kTrig
kR += kTrig
kS = wrap(kS, 0, 8)
if kD[kS] != 0 then
    gkN = node_climb(0)
    schedulek("Leaf", 0, $BEAT*kDiv[kS], 1)
elseif kM[kS] != 0 then
    gkN = node_climb(16)
    schedulek("Leaf", 0, $BEAT/kMul[kS], 3)
endif

if kR == 8 && kTrig == 1 then
    kMul /= 2
    kDiv *= 2
elseif kR == 24 && kTrig == 1 then
    kMul *= 2
    kDiv /= 2
elseif kR == 32 && kTrig == 1 then
    kMul /= 4
    kDiv /= 2
endif
endin
schedule("Water", 0, 60)


instr Leaf
gaE1 linseg .5,p3,0
gkE2 linseg .8,p3,0
gaE3 linseg -0.3,p3,0.2
gkE4 linseg -0.5,p3,0
gaE5 linseg 1,p3,0
endin

instr Flower
kFrq = node_get_value_k(gkN, 0)
kFrq *= 2^p5
aSig1 Pmoscilx gaE1^2, kFrq, gaE3 ;env as phase mod
aSig2 Pmoscilx gaE1^2, kFrq, .2
aSig3 Pmoscilx gaE1^2, kFrq, .5-gkE2 ;feedback cute lil tail
aSig4 Pmoscilx gaE1, kFrq, gaE3
aSig5 Pmoscilx gaE5^2, kFrq, aSig4*.9
sbus_mix 0, aSig5
endin
schedule("Flower", 0, 60)


instr Out
aL, aR sbus_out
;hrtf?
aL clip aL, 0, 1
aR clip aR, 0, 1
outs aL, aR
sbus_clear_all
endin
</CsInstruments>
<CsScore>
i"Out" 0 60
e
</CsScore>
</CsoundSynthesizer>

