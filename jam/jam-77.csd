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
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#include "mycorrhiza.orc"
#include "utils.orc"
#include "mixer.orc"
#include "perfuma.orc"

gaVerbL,gaVerbR init 0

#define TEMPO #105#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

seed 666

giSin  ftgen 0,0,2^18,10, 1
giWav  ftgen 0,0,2^18,9, 100,1.000,0, 278,0.500,0, 518,0.250,0, 816,0.125,0,
                         1166,0.062,0, 1564,0.031,0, 1910,0.016,0
giScal ftgen 0,0,-7*3,-51, 7,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(4/12),2^(6/12),2^(7/12),2^(9/12),2^(11/12) ;lydian


instr Tree
;64 nodes, 16 values and 4 branches each
tree_init(64, 16, 4)

;connect
node_connect_i(0, 1)
node_connect_i(1, 2)
node_connect_i(1, 3)
node_connect_i(2, 4)
node_connect_i(2, 5)
node_connect_i(3, 6)
node_connect_i(4, 7)

;values
icnt = 0
while icnt < 64 do
    node_set_value_i(icnt, 0, nstrnum("Terrain"))
    node_set_value_i(icnt, 1, 0)
    node_set_value_i(icnt, 2, 0.1)
    node_set_value_i(icnt, 3, 0.1)
    node_set_value_i(icnt, 4, random(0, 7*3))
    ;x, y, rx, ry
    node_set_value_i(icnt, 5, 0.5)
    node_set_value_i(icnt, 6, 0.5)
    node_set_value_i(icnt, 7, 0.5)
    node_set_value_i(icnt, 8, 0.5)
    ;m1, m2, n1, n2, n3, a, b
    iNum = int(random(-8, 8))*2 ;random even integer
    node_set_value_i(icnt, 9, iNum)
    node_set_value_i(icnt, 10, iNum)
    node_set_value_i(icnt, 11, 8)
    node_set_value_i(icnt, 12, 1)
    node_set_value_i(icnt, 13, 1)
    node_set_value_i(icnt, 14, 1)
    node_set_value_i(icnt, 15, 1)
    icnt += 1
od
endin
schedule("Tree", 0, 0)


instr Seq
kS init -1
kTrig = MyMetro($FRQ)
kMul[] fillarray 2, 4, 3, 4, 1, 5, 6, 1
kDiv[] fillarray 2, 1, 2, 2, 1, 2, 3, 1
kM[], kD[] Perfuma $FRQ, kMul, kDiv
kS += kTrig

if kTrig == 1 then
    kN = node_climb3(0)
    karr[] = node_get_value_k(kN)
    schedulek karr
endif
endin
schedule("Seq", 0, 128)


gaTerrain init 0
instr Terrain
iX,iY,iRX,iRY passign 6
iM1,iM2,iN1,iN2,iN3,iA,iB passign 10
iFrq table p5, giScal
//amp,cps,x,y,rx,ry,rot,tab0,tab1,m1,m2,n1,n2,n3,a,b,period
aSig sterrain p4, iFrq, iX,iY, iRX,iRY, 0, giSin,giWav, iM1,iM2,iN1,iN2,iN3,iA,iB,1
aEnv linseg 1, p3, 0
aSig *= aEnv
gaTerrain += aSig
endin
instr TerrainP
aSig = gaTerrain
aSig dcblock aSig
aSig wguide1 aSig, 40, 20000, 0.8
aSig wguide1 aSig, 100, 8000, 0.8
vincr gaVerbL, aSig*db(-12)
vincr gaVerbR, aSig*db(-12)
sbus_mix 1, aSig
clear gaTerrain
endin
schedule("TerrainP", 0, -1)


instr Verb
gaVerbL dcblock gaVerbL
gaVerbR dcblock gaVerbR
kRoomSize  init  0.85 ; room size (range 0 to 1)
kHFDamp    init  0.90  ; high freq. damping (range 0 to 1)
al,ar freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp, 44100, 1
sbus_mix 0, al, ar
clear gaVerbL,gaVerbR
endin
schedule("Verb", 0, -1)


instr Out
aL, aR sbus_out
aL clip aL, 0, db(-6)
aR clip aR, 0, db(-6)
outs aL, aR
sbus_clear_all
endin
schedule("Out", 0, -1)


instr Exit
exitnow
endin
schedule("Exit", $BEAT*128+4, 0)
</CsInstruments>
</CsoundSynthesizer>

