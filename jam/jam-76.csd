//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//thank you, mog
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231 ;-m227
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   32
nchnls  =   2
0dbfs   =   1

#define TEMPO #70#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

;bless me mommy for i intend to sin a whole lot more
#define NODEFILL(n'x)
#itmpmacroarr[] = fillarray($x)
node_set_value_i($n, itmpmacroarr)#

gaVerbL,gaVerbR init 0

#include "mycorrhiza.orc"
#include "utils.orc"
#include "mixer.orc"
#include "perfuma.orc"

seed 105


instr Tree
;16 nodes, 16 values and 4 branches each
tree_init(16, 16, 4)
;connections
node_connect_i(0, 1)
node_connect_i(0, 3)
node_connect_i(0, 2)
node_connect_i(1, 4)
node_connect_i(1, 5)
node_connect_i(2, 6)
node_connect_i(2, 7)
node_connect_i(2, 8)
node_connect_i(6, 9)
node_connect_i(6,10)
node_connect_i(7,11)
node_connect_i(8,12)
node_set_root_i(3, 8)

;         N#  mel1   mel2   mel3   m1      m2      n1      n2      n3      a       b
$NODEFILL(00' 07.00, 07.04, 07.06, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(01' 07.02, 08.04, 07.07, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(02' 08.06, 08.09, 09.11, +04.00, +04.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(03' 08.00, 08.04, 08.09, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(04' 06.11, 07.02, 07.09, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(05' 07.02, 07.04, 07.07, +02.00, +02.00, +08.00, +01.00, +04.00, +01.00, +01.00)
$NODEFILL(06' 08.04, 08.07, 09.00, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(07' 08.00, 07.11, 08.07, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(08' 07.00, 07.03, 07.07, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(09' 07.02, 07.04, 07.09, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(10' 08.04, 08.09, 09.02, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(11' 08.00, 08.06, 08.07, +02.00, +02.00, +08.00, +01.00, +01.00, +01.00, +01.00)
endin


instr Terrain
kS init -1
kTrig = MyMetro($FRQ)
kMul[] fillarray 2, 4, 8, 4, 1, 8, 6, 1
kDiv[] fillarray 2, 1, 2, 2, 1, 3, 3, 1
kM[], kD[] Perfuma $FRQ, kMul, kDiv
kS += kTrig
kS = wrap(kS, 0, 8)

kTrig1 = kM[wrap(kS+0,0,8)]
kTrig2 = kD[wrap(kS+1,0,8)]
kTrig3 = kM[wrap(kS+2,0,8)]
kTrig4 = kD[wrap(kS+3,0,8)]

;different climbs for different melodies
if kTrig1 == 1 then
    kAN1 = node_climb3(0)
endif
if kTrig2 == 1 then
    kAN2 = node_climb3(0)
endif
if kTrig3 == 1 then
    kAN3 = node_climb3(0)
endif
if kTrig4 == 1 then
    kAN4 = node_climb3(0)
endif

;waves
iRamp ftgenonce 0,0,2^14,7, -1,2^14,1
iTanh ftgenonce 0,0,2^14,"tanh", -5, 5, 0
iSaw  ftgenonce 0,0,2^14,7, 0,2^13,1,0,-1,2^13,0
iSqur ftgenonce 0,0,2^14,7, 1,2^13,1,0,-1,2^13,-1
iSin  ftgenonce 0,0,2^14,10, 1
iCos  ftgenonce 0,0,2^14,11, 1
iWav  ftgenonce 0,0,2^18,9, 100,1.000,0, 278,0.500,0, 518,0.250,0,
                            816,0.125,0, 1166,0.062,0, 1564,0.031,0, 1910,0.016,0

kCps1 = portk(cpspch(node_get_value_k(kAN3,0)), 0.00)
kCps2 = portk(cpspch(node_get_value_k(kAN1,1)), 0.00)
kCps3 = portk(cpspch(node_get_value_k(kAN4,2)), 0.00)

km1,km2,kn1,kn2,kn3,ka,kb =
portk(node_get_value_k(kAN2,3), 0.01),
portk(node_get_value_k(kAN2,4), 0.01),
portk(node_get_value_k(kAN2,5), 0.01),
portk(node_get_value_k(kAN2,6), 0.01),
portk(node_get_value_k(kAN2,7), 0.01),
portk(node_get_value_k(kAN2,8), 0.01),
portk(node_get_value_k(kAN2,9), 0.01)

kX, kY, kRX, kRY = 0.5, 0.5, 0.15, 0.15

//amp,cps,x,y,rx,ry,rot,tab0,tab1,m1,m2,n1,n2,n3,a,b,period
aSig1 sterrain 0.5, kCps1, kX,kY, kRX,kRY, 0, iSin,iSin, km1,km2,kn1,kn2,kn3,ka,kb,1
aSig2 sterrain 0.5, kCps2, kX,kY, kRX,kRY, 0, iWav,iSin, km1,km2,kn1,kn2,kn3,ka,kb,1
aSig3 sterrain 0.5, kCps3, kX,kY, kRX,kRY, 0, iWav,iSin, km1,km2,kn1,kn2,kn3,ka,kb,1
aSig4 sterrain 0.9, kCps1/4, kX,kY, kRX,kRY, 0, iSin,iSin, km1,km2,kn1,kn2,kn3,ka,kb,1
aSig = (aSig1+aSig2+aSig3+aSig4)/4
;aSig = aSig3

;kTrig4 = MyMetro($FRQ*4)
;kEnv = triglinseg(kTrig4, 1, $BEAT/4, 0)
;aSig *= kEnv

aSig dcblock aSig
vincr gaVerbL, aSig*db(-12)
vincr gaVerbR, aSig*db(-12)
;aSig butlp aSig, 9000
sbus_mix 1, aSig
endin


instr String
;strum (fract instance 1 ends all other istancea?)
endin


instr Verb
;eq in
gaVerbL dcblock gaVerbL
gaVerbR dcblock gaVerbR
kRoomSize  init  0.80 ; room size (range 0 to 1)
kHFDamp    init  0.80  ; high freq. damping (range 0 to 1)
al,ar freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp, 44100, 1
;eq out
sbus_mix 0, al, ar
;outs al, ar
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


</CsInstruments>
<CsScore>
t           0       140
i"Tree"     0       0
i"Terrain"  0       [140*2]
e
</CsScore>
</CsoundSynthesizer>

