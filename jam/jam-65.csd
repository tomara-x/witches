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

seed 42

instr Soil
tree_init(32, 16, 16)               ;32 nodes, 16 values and 16 branches each
iarr[] = fillarray(1, 2)
node_connect_i(0, iarr)             ;connect nodes 1,2 as branches of 0
iarr[] = fillarray(3, 4, 5)
node_connect_i(1, iarr)             ;connect nodes 3, 4, 5 as branches of 1
node_connect_i(3, 6)                ;connect node 6 as branch of 3
iarr[] = fillarray(7, 8, 9)
node_connect_i(2, iarr)             ;connect 7, 8, 9 as branches of 2

icnt = 0
while icnt < 32 do
    node_set_value_i(icnt, 0, random:i(110, 1760))
    node_set_value_i(icnt, 1, random:i(0, 10))
    node_set_value_i(icnt, 2, random:i(0.01, 1))
    icnt += 1
od
endin
schedule("Soil", 0, 0)              ;run instr for i-pass only


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
    kN = node_climb(0)
endif

kGFrq = node_get_value_k(kN, 0)/2
kGPhs = 0
kFMD = node_get_value_k(kN, 1)
kPMD = .0
kGDur = node_get_value_k(kN, 2)
kGDens = 20
iMaxOvr = 20
iWav ftgenonce 0,0,2^14,9, 1,1,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,kGPhs, kFMD,kPMD, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, 42, 16
aSig flanger aSig, a(.9), 0.5
sbus_mix 0, aSig*db(-12)
endin
schedule("Water", 0, 120)


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

