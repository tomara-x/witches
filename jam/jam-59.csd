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

#define TEMPO #128#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

#include "../mycorrhiza.orc"
#include "../oscillators.orc"
#include "../utils.orc"
#include "../mixer.orc"



instr Seed
tree_init(32, 8, 16)                ;32 nodes, 8 values and 16 branches each
iarr[] = fillarray(1, 2, 3, 4)
node_connect_i(0, iarr)             ;connect nodes 1,2,3,4 as branches of 0
iarr[] = fillarray(5, 6, 7, 8)
node_connect_i(1, iarr)             ;connect nodes 5,6,7,8 as branches of 1
iarr[] = fillarray(9, 10, 11)
node_connect_i(2, iarr)             ;repeated twice
node_connect_i(2, iarr)             ;2 will have 9,10,11,9,10,11 as branches
iarr[] = fillarray(9, 10, 11)
node_connect_i(3, 12)               ;connect node 12 as branch of 3)
iarr[] = fillarray(13, 14, 15)
node_connect_i(12, iarr)            ;connect 13,14,15 as branches of 12
endin
schedule("Seed", 0, 0)              ;run instr for i-pass only



instr Soil
;generate 32 notes of a scale
iScale ftgenonce 0,0,-32,-51, 7,2,cpspch(6),0,
1,2^(3/12),2^(4/12),2^(5/12),2^(6/12),2^(7/12),2^(10/12) ;7-tone blues
icnt = 0
while icnt < 32 do
    ;set first value of each node to frequency of each note in the scale
    node_set_value_i(icnt, 0, table(icnt, iScale))
    icnt += 1
od
endin
schedule("Soil", 0, 0)



instr Water
kTrig metro $FRQ*4
if kTrig == 1 then
    kN = node_climb(0)
    schedulek("Flower", 0, $BEAT/4, kN)  ;pass current node to instrument as p4
endif
endin
schedule("Water", 0, 60)



instr Flower
aEnv = linseg(0,p3*.03,1, p3*.6,0)
kFrq = node_get_value_k(p4, 0)    ;get value stored at index 0 of node p4
aSig = oscili(1, kFrq)
aSig = mirror(aSig*8, -1, 1)
aSig *= aEnv
aSig *= db(-12)
aSig = diode_ladder(aSig, kFrq*8, 16, 1, 180)
sbus_mix(0, aSig) 
endin


instr Out
aL, aR sbus_out
kSM = 1
aL limit aL, -kSM, kSM
aR limit aR, -kSM, kSM
outs aL, aR
sbus_clear_all
endin
</CsInstruments>
<CsScore>
i"Out" 0 60
e
</CsScore>
</CsoundSynthesizer>


