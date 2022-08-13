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

#define TEMPO #120#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

gaVerbL,gaVerbR init 0

#include "mycorrhiza.orc"
#include "perfuma.orc"
#include "utils.orc"
#include "mixer.orc"
#include "drums.orc"

seed 105



instr Tree
;32 nodes, 4 values and 16 branches each
tree_init(32, 4, 16)
;connections
iarr[] = fillarray(1,2,3,4,5,6,7)
node_connect_i(0, iarr)
;set values
ival[] = fillarray(7.02, 5.02, 8.03, 6.05, 8.02, 5.00, 6.02, 7.00)
icnt = 0
while icnt < 8 do
    node_set_value_i(icnt, 0, ival[icnt])
    icnt += 1
od
endin



instr Terrain
kTrig = MyMetro($FRQ*4)

if kTrig == 1 then
    kN = node_climb(0)
endif

iRamp ftgenonce 0,0,2^14,7, -1,2^14,1
iTanh ftgenonce 0,0,2^14,"tanh", -5, 5, 0
iSaw  ftgenonce 0,0,2^14,7, 0,2^13,1,0,-1,2^13,0
iSqur ftgenonce 0,0,2^14,7, 1,2^13,1,0,-1,2^13,-1
iSin  ftgenonce 0,0,2^14,10, 1
iCos  ftgenonce 0,0,2^14,11, 1

kCps = cpspch(node_get_value_k(kN, 0))
kCps = lineto(kCps, .02)

kM1, kM2, kN1, kN2, kN3, kA, kB =
rspline(-3.0, 2, 0.05, 0.25),
rspline(-3.0, 3, 0.01, 0.05),
rspline(-3.0, 5, 0.80, 2.00),
rspline(-3.0, 8, 0.01, 0.05),
rspline(-3.0, 4, 0.01, 0.05),
rspline(-3.0, 2, 0.01, 0.05),
rspline(-3.0, 1, 0.01, 0.05)

//amp,cps,x,y,rx,ry,rot,tab0,tab1,m1,m2,n1,n2,n3,a,b,period
aSig sterrain 0.1, kCps, .9,.5, .8,.8, 0, iSin, iSaw,
              kM1,kM2,kN1,kN2,kN3,kA,kB, 1
aSig dcblock aSig
sbus_mix 1, aSig
endin



instr Drums
kT = MyMetro($FRQ)
schedkwhen(kT,0,0, "Kick",  0,    .5, 230, 20, .1, 0, .1)
;schedkwhen(kT,0,0, "HatC2", 0.5,  0.1,  .2, -0.9, 0.5)
;schedkwhen(kT,0,0, "HatO2", 4.25, 0.35, .1, -0.8, 0.5)
;schedkwhen(kT,0,0, "HatC2", 4.75, 0.15, .06, -0.8, 0.5)
schedkwhen(kT,0,0, "HatO2", 0,    .1, .1,  0.9, 4700, 6800, 0.5)
schedkwhen(kT,0,0, "HatO2", 0.5,  .1, .1,  0.9, 4700, 6800, 0.5)
schedkwhen(kT,0,0, "HatC2", 0.25, .1, .1, -0.9, 9000, 8000, 0.5)
;schedkwhen(kT,0,0, "HatC2", 0,   -.1, .1,  0.9, 9000, 1000, 0.5)
;schedkwhen(kT,0,0, "HatC2", 0.25, .1, .1, -0.9, 9000, 8000, 0.5)
endin



instr Verb
gaVerbL dcblock gaVerbL
gaVerbR dcblock gaVerbR
kRoomSize  init  0.65 ; room size (range 0 to 1)
kHFDamp    init  0.8  ; high freq. damping (range 0 to 1)
aVerbL,aVerbR freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp, 44100, 1
sbus_mix 0, aVerbL, aVerbR
clear gaVerbL,gaVerbR
endin
schedule("Verb", 0, -1)



instr Out
aL, aR sbus_out
aL clip aL, 0, 1
aR clip aR, 0, 1
outs aL, aR
sbus_clear_all
endin
schedule("Out", 0, -1)



</CsInstruments>
<CsScore>
t           0       120
i"Tree"     0       0
i"Drums"    16      [3*60]
i"Terrain"  0       [4*60]
e
</CsScore>
</CsoundSynthesizer>

