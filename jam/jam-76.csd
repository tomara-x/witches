//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//thank you, mog

;always feel like my stuff isn't worth writing a dedication but fuck that!
;i can't name all of you, sometimes it's only an indirect, fleeting interaction.
;but i'm very grateful for you all. it's an honor and a joy to know you <3
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231 ;-m227
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

#define TEMPO #70#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

;bless me mommy for i intend to sin a whole lot more
#define NODEFILL(n'x)
#itmpmacroarr[] = fillarray($x)
node_set_value_i($n, itmpmacroarr)#



instr Tree
;16 nodes, 8 values and 4 branches each
tree_init(16, 8, 4)
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

;         N#  mel1   mel2   mel3   m1   m2    
$NODEFILL(00' 07.00, 07.04, 07.06, +02, +02)
$NODEFILL(01' 07.02, 08.04, 07.07, +02, +02)
$NODEFILL(02' 08.06, 08.09, 09.11, +02, +04)
$NODEFILL(03' 08.00, 08.04, 08.09, +02, +02)
$NODEFILL(04' 06.11, 07.02, 07.09, +02, +02)
$NODEFILL(05' 07.02, 07.04, 07.07, +02, +02)
$NODEFILL(06' 08.04, 08.07, 09.00, +02, +02)
$NODEFILL(07' 08.00, 07.11, 08.07, +02, +02)
$NODEFILL(08' 07.00, 07.03, 07.07, +02, +02)
$NODEFILL(09' 07.02, 07.04, 07.09, +02, +02)
$NODEFILL(10' 08.04, 08.09, 09.02, +02, +02)
$NODEFILL(11' 08.00, 08.06, 08.07, +02, +02)
endin
schedule("Tree", 0, 0)


instr Terrain
kS init -1
kTrig = MyMetro($FRQ)
kMul[] fillarray 2, 4, 3, 4, 1, 5, 6, 1
kDiv[] fillarray 2, 1, 2, 2, 1, 2, 3, 1
kM[], kD[] Perfuma $FRQ, kMul, kDiv
kS += kTrig

kTrig1 = kM[wrap(kS+2,0,8)]
kTrig2 = kM[wrap(kS+0,0,8)]
kTrig3 = kD[wrap(kS+3,0,8)]

if kTrig1 == 1 then
    kAN1 = node_climb3(0)
endif
if kTrig2 == 1 then
    kAN2 = node_climb3(0)
endif
if kTrig3 == 1 then
    kAN3 = node_climb3(0)
endif

iSin  ftgenonce 0,0,2^14,10, 1
iWav  ftgenonce 0,0,2^18,9, 100,1.000,0, 278,0.500,0, 518,0.250,0,
                            816,0.125,0, 1166,0.062,0, 1564,0.031,0, 1910,0.016,0

kCps1 = cpspch(node_get_value_k(kAN1,0))
kCps2 = cpspch(node_get_value_k(kAN2,1))
kCps3 = cpspch(node_get_value_k(kAN3,2))

km1,km2,kn1,kn2,kn3,ka,kb = node_get_value_k(kAN2,3),
                            node_get_value_k(kAN2,4), 8,1,1,1,1

kX, kY, kRX, kRY = 0.5, 0.5, 0.15, 0.15

//amp,cps,x,y,rx,ry,rot,tab0,tab1,m1,m2,n1,n2,n3,a,b,period
aSig1 sterrain 0.5, kCps1, kX,kY, kRX,kRY, 0, iSin,iWav, km1,km2,kn1,kn2,kn3,ka,kb,1
aSig2 sterrain 0.5, kCps2, kX,kY, kRX,kRY, 0, iWav,iSin, km1,km2,kn1,kn2,kn3,ka,kb,1
aSig3 sterrain 0.5, kCps3, kX,kY, kRX,kRY, 0, iWav,iSin, km1,km2,kn1,kn2,kn3,ka,kb,1
aSig4 sterrain 0.9, kCps1, kX,kY, kRX,kRY, 0, iSin,iWav, km1,km2,kn1,kn2,kn3,ka,kb,4
aSig = (aSig1+aSig2+aSig3+aSig4)/4

;aSig dcblock aSig ;comment this for evil stuff
aSig butlp aSig, 6000
aSig flanger aSig, a(.04), 0.8
vincr gaVerbL, aSig*db(-12)
vincr gaVerbR, aSig*db(-12)
sbus_mix 1, aSig
endin
schedule("Terrain", 0, $BEAT*128)


instr String
;strum (fract instance 1 ends all other istancea?)
endin


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
schedule("Exit", $BEAT*128+2, 0)
</CsInstruments>
</CsoundSynthesizer>

