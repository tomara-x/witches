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

instr Tree
;16 nodes, 1 value and 4 branches each
tree_init(16, 1, 4)

;connect
node_connect_i(0, 1)
node_connect_i(1, 2)
node_connect_i(1, 3)
node_connect_i(2, 4)
node_connect_i(2, 5)
node_connect_i(3, 6)
node_connect_i(4, 7)

node_connect_i(8, 9)
node_connect_i(9, 10)
node_connect_i(9, 11)
node_connect_i(10,12)
node_connect_i(11,13)
node_connect_i(11,14)
node_connect_i(12,15)

;values
iPch[] fillarray 6.00, 6.02, 6.04, 6.06, 6.07, 6.09, 6.11, 7.00,
                 9.00, 9.02, 9.04, 9.06, 9.07, 9.09, 9.11, 10.00
icnt = 0
while icnt < 16 do
    node_set_value_i(icnt, 0, iPch[icnt])
    icnt += 1
od
endin
schedule("Tree", 0, 0)

instr PrintTree
    printarray gk_Tree
endin
schedule("PrintTree", 0, 1/kr)


instr Call
kCnt init 0
kTrig MyMetro $FRQ*1
if kTrig == 1 then
    kN = node_climb(0)
    kcps = cpspch(node_get_value_k(kN, 0))
    schedulek "Terrain", 0, .1, .1, kcps, .5,.5,.5,.5, 2,2,8,4,1,1,1
    kCnt += 1
endif
if kCnt == 4 then
    schedulek "Response", 2*$BEAT, -1
    turnoff
endif
endin

instr Response
kCnt init 0
kTrig MyMetro $FRQ*1
if kTrig == 1 then
    kN = node_climb(8)
    kcps = cpspch(node_get_value_k(kN, 0))
    schedulek "Terrain", 0, .1, .1, kcps, .5,.5,.5,.5, 8,8,8,1,1,1,1
    kCnt += 1
endif
if kCnt == 4 then
    schedulek "Call", 2*$BEAT, -1
    turnoff
endif
endin
schedule("Call", 0, -1)



gaTerrain init 0
instr Terrain
iX,iY,iRX,iRY passign 6
iM1,iM2,iN1,iN2,iN3,iA,iB passign 10
//amp,cps,x,y,rx,ry,rot,tab0,tab1,m1,m2,n1,n2,n3,a,b,period
aSig sterrain p4, p5, iX,iY, iRX,iRY, 0, giSin,giWav, iM1,iM2,iN1,iN2,iN3,iA,iB,1
aEnv linseg 1, p3, 0
;aSig *= aEnv
gaTerrain += aSig
endin
instr TerrainP
aSig = gaTerrain
aSig dcblock aSig
;aSig pdhalf aSig, -0.9
;aSig limit aSig, -0.1, 0.1
aSig wguide1 aSig, 40, 8000, 0.8
aSig wguide1 aSig, 3, 10000, 0.82
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

