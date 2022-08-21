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

#define TEMPO #140#
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
$NODEFILL(00' 07.00, 07.03, 07.07, +02.00, +02.00, +00.20, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(01' 07.03, 07.07, 08.00, +16.00, +16.00, +00.20, +01.00, -04.00, +01.00, +01.00)
$NODEFILL(02' 08.02, 08.05, 08.08, +16.00, +16.00, +00.20, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(03' 08.05, 08.08, 09.01, +02.00, +02.00, +00.20, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(04' 08.08, 09.02, 09.05, +02.00, +02.00, +00.40, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(05' 09.02, 09.05, 09.08, +02.00, +02.00, +00.40, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(06' 06.03, 06.07, 06.08, +02.00, +02.00, +00.20, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(07' 07.03, 07.07, 07.10, +02.00, +02.00, +00.20, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(08' 08.00, 08.00, 08.03, +02.00, +02.00, +01.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(09' 09.10, 08.00, 08.00, +02.00, +02.00, +01.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(10' 08.08, 05.00, 08.00, +02.00, +02.00, +01.00, +01.00, +01.00, +01.00, +01.00)
$NODEFILL(11' 06.00, 08.07, 08.02, +02.00, +02.00, +01.00, +01.00, +01.00, +01.00, +01.00)
endin


instr Terrain
;get perfuma in here
kTrig1 = MyMetro($FRQ)
kTrig2 = MyMetro($FRQ/8)
kTrig3 = MyMetro($FRQ*2)

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

;waves
iRamp ftgenonce 0,0,2^14,7, -1,2^14,1
iTanh ftgenonce 0,0,2^14,"tanh", -5, 5, 0
iSaw  ftgenonce 0,0,2^14,7, 0,2^13,1,0,-1,2^13,0
iSqur ftgenonce 0,0,2^14,7, 1,2^13,1,0,-1,2^13,-1
iSin  ftgenonce 0,0,2^14,10, 1
iCos  ftgenonce 0,0,2^14,11, 1
iWav  ftgenonce 0,0,2^18,9, 100,1.000,0, 278,0.500,0, 518,0.250,0,
                            816,0.125,0, 1166,0.062,0, 1564,0.031,0, 1910,0.016,0

kCps1 = lineto(cpspch(node_get_value_k(kAN1,0)), 0.01)
kCps2 = lineto(cpspch(node_get_value_k(kAN2,1)), 0.7)
kCps3 = lineto(cpspch(node_get_value_k(kAN1,2)), 0.01)

km1,km2,kn1,kn2,kn3,ka,kb =
lineto(node_get_value_k(kAN3,3), 0.03),
lineto(node_get_value_k(kAN3,4), 0.03),
lineto(node_get_value_k(kAN3,5), 0.03),
lineto(node_get_value_k(kAN3,6), 0.03),
lineto(node_get_value_k(kAN2,7), 0.00),
lineto(node_get_value_k(kAN3,8), 0.03),
lineto(node_get_value_k(kAN3,9), 0.03)

kX, kY, kRX, kRY = 0.5, 0.5, 0.15, rspline(0.05, 0.5, 0.5, 2)

//amp,cps,x,y,rx,ry,rot,tab0,tab1,m1,m2,n1,n2,n3,a,b,period
aSig1 sterrain 0.5, kCps1, kX,kY, kRX,kRY, 0, iSin,iWav, km1,km2,kn1,kn2,kn3,ka,kb,0
aSig2 sterrain 0.5, kCps2, kX,kY, kRX,kRY, 0, iWav,iWav, km1,km2,kn1,kn2,kn3,ka,kb,0
aSig3 sterrain 0.5, kCps3, kX,kY, kRX,kRY, 0, iWav,iWav, km1,km2,kn1,kn2,kn3,ka,kb,0
aSig4 sterrain 0.9, kCps1/4, kX,kY, kRX,kRY, 0, iSin,iWav, km1,km2,kn1,kn2,kn3,ka,kb,0
aSig = (aSig1+aSig2+aSig3+aSig4)/4
;aSig = aSig1

;kTrig4 = MyMetro($FRQ*3)
;kEnv = triglinseg(kTrig4, 2, $BEAT/3, 0)
;aSig *= kEnv

aSig dcblock aSig
vincr gaVerbL, aSig*db(-12)
vincr gaVerbR, aSig*db(-12)
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

