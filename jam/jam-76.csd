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
;16 nodes, 0 values and 4 branches each
tree_init(16, 0, 4)
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
;node_connect_i(8,12)
node_set_root_i(3, 8)

;$NODEFILL(0'2,2,0.2,1,1,1,1)
endin


instr Terrain
kTrig1 = MyMetro($FRQ/5)
kTrig2 = MyMetro($FRQ/8)
kTrig3 = MyMetro($FRQ*3)

;different climbs for different melodies
if kTrig1 == 1 then
    kAN1 = node_climb4(0)
endif
if kTrig2 == 1 then
    kAN2 = node_climb4(0)
endif
if kTrig3 == 1 then
    kAN3 = node_climb4(0)
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

;pitch of every step
kPch1[] = fillarray(7.00, 7.03, 8.01, 8.05, 8.08, 9.01, 6.03, 7.03, 7.04, 8.09, 7.01, 6.06)
kPch2[] = fillarray(7.03, 7.07, 8.05, 8.08, 9.01, 9.05, 6.07, 7.07, 7.08, 6.04, 7.01, 9.02)
kPch3[] = fillarray(7.07, 8.00, 8.08, 9.01, 9.05, 9.08, 6.08, 7.10, 6.09, 7.09, 7.03, 9.03)
;slew them
kCps1 = lineto(cpspch(kPch1[kAN1]), 0.5)
kCps2 = lineto(cpspch(kPch2[kAN2]), 0.7)
kCps3 = lineto(cpspch(kPch3[kAN1]), 0.2)

;superformula parameters of every step
kM1[] = fillarray(+02.00, +16.00, +02.00, +02.00, +02.00, +02.00, +02.00, +02.00,2,2,2,2)
kM2[] = fillarray(+02.00, +16.00, +02.00, +02.00, +02.00, +02.00, +02.00, +02.00,2,2,2,2)
kN1[] = fillarray(+00.20, +00.20, +00.20, +00.20, +04.00, +04.00, +00.20, +00.20,1,1,1,1)
kN2[] = fillarray(+01.00, +01.00, +01.00, +01.00, +01.00, +01.00, +01.00, +01.00,1,1,1,1)
kN3[] = fillarray(+01.00, -04.00, +01.00, +01.00, +01.00, +01.00, +01.00, +01.00,1,1,1,1)
kA[]  = fillarray(+01.00, +01.00, +01.00, +01.00, +01.00, +01.00, +01.00, +01.00,1,1,1,1)
kB[]  = fillarray(+01.00, +01.00, +01.00, +01.00, +01.00, +01.00, +01.00, +01.00,1,1,1,1)

;slew limit them
km1,km2,kn1,kn2,kn3,ka,kb =
lineto(kM1[kAN3], 0.03),
lineto(kM2[kAN3], 0.03),
lineto(kN1[kAN3], 0.03),
lineto(kN2[kAN3], 0.03),
lineto(kN3[kAN2], 0.80),
lineto(kA[kAN3] , 0.03),
lineto(kB[kAN3] , 0.03)

kX, kY, kRX, kRY = 0.5, 0.5, 0.15, rspline(0.05, 0.5, 0.5, 2)

//amp,cps,x,y,rx,ry,rot,tab0,tab1,m1,m2,n1,n2,n3,a,b,period
aSig1 sterrain 0.5, kCps1, kX,kY, kRX,kRY, 0, iSin,iWav, km1,km2,kn1,kn2,kn3,ka,kb,0
aSig2 sterrain 0.5, kCps2, kX,kY, kRX,kRY, 0, iWav,iWav, km1,km2,kn1,kn2,kn3,ka,kb,0
aSig3 sterrain 0.5, kCps3, kX,kY, kRX,kRY, 0, iWav,iWav, km1,km2,kn1,kn2,kn3,ka,kb,0
aSig4 sterrain 0.9, kCps1/4, kX,kY, kRX,kRY, 0, iSin,iWav, km1,km2,kn1,kn2,kn3,ka,kb,0
aSig = (aSig1+aSig2+aSig3+aSig4)/4

;kTrig4 = MyMetro($FRQ*3)
;kEnv = triglinseg(kTrig4, 2, $BEAT/3, 0)
;aSig *= kEnv

aSig dcblock aSig
vincr gaVerbL, aSig*db(-18)
vincr gaVerbR, aSig*db(-18)
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
i"Terrain"  0       [60*4]
e
</CsScore>
</CsoundSynthesizer>

