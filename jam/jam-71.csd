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
endin



instr Terrain
kTrig = MyMetro($FRQ*4)

if kTrig == 1 then
    kN = node_climb4(0)
endif

iRamp ftgenonce 0,0,2^14,7, -1,2^14,1
iTanh ftgenonce 0,0,2^14,"tanh", -5, 5, 0
iSaw  ftgenonce 0,0,2^14,7, 0,2^13,1,0,-1,2^13,0
iSqur ftgenonce 0,0,2^14,7, 1,2^13,1,0,-1,2^13,-1
iSin  ftgenonce 0,0,2^14,10, 1
iCos  ftgenonce 0,0,2^14,11, 1
iWav  ftgenonce 0,0,2^18,9, 100,1.000,0, 278,0.500,0, 518,0.250,0,
                            816,0.125,0, 1166,0.062,0, 1564,0.031,0, 1910,0.016,0

kval[] = fillarray(7.03, 5.03, 8.04, 6.05, 8.03, 5.00, 6.03, 7.00)
kCps = cpspch(kval[kN])
;kCps = lineto(kCps, .02)

if ClkDiv(kTrig, 64) == 1 then
    kval += int(random:k(-1,8))
    if kval[0] > 8 then
        kval -= 4
    endif
endif

kM1, kM2, kN1, kN2, kN3, kA, kB =
rspline(+00.00, +04.00, 01.00, 02.00),
rspline(+01.00, +04.00, 01.00, 02.00),
rspline(+01.00, +01.00, 01.00, 03.00),1,1,1,1
;rspline(-01.00, +01.00, 11.70, 14.00),
;rspline(-01.00, +01.00, 13.00, 24.00),
;rspline(-03.00, +02.00, 10.01, 30.05),
;rspline(-01.00, +01.00, 12.01, 50.05)

kX, kY, kRX, kRY = 0.5, 0.5, 0.8, 0.8

//amp,cps,x,y,rx,ry,rot,tab0,tab1,m1,m2,n1,n2,n3,a,b,period
aSig sterrain 1, kCps, kX,kY, kRX,kRY, 0, iSin,iSaw, kM1,kM2,kN1,kN2,kN3,kA,kB, 0
aSig clip aSig, 0, db(-24)
;aSig dcblock aSig

;amplitude tracking and "compression" gone wild
aKick = ga_sbus[15][0]
kAmp rms aKick
if kAmp > db(-24) then
    aSig *= db(-96)
endif

sbus_mix 1, aSig
endin



instr Drums
kT = MyMetro($FRQ/2)
;somewhere on the kick/gun spectrum
;schedkwhen(kT,0,0, "Kick",  0,    .5, 230, 20, .3, 1, .1)

;metamorphic mages
;schedkwhen(kT,0,0, "Kick",  0,    .5, 130, 20, .3, .994, .7)
;schedkwhen(kT,0,0, "Kick",  0,    .5, 100, 20, .3, 1, .7)

;plucky
;schedkwhen(kT,0,0, "Kick",  0,    .9, 80, 80, .01, 1, .1)

schedkwhen(kT,0,0, "Kick",  0,    .5, 230, 20, .1, 0, .1)
;schedkwhen(kT,0,0, "HatO2", 0.5,   .9, .1, -0.9, 8323, 9783, 0.0)
;schedkwhen(kT,0,0, "HatC2", 0.75,  .1, .1, -0.9, 8323, 9783, 0.0)
schedkwhen(kT,0,0, "HatC2", 0,   -.1, .02,  0.9, 9000, 1000, 0.5)
;schedkwhen(kT,0,0, "HatC2", 0.25,-.1, .1, -0.9, 9000, 8000, 0.5)
schedkwhen(kT,0,0, "HatC2", 0.5,  .1, .1, -0.9, 9000, 1000, 0.5)
endin



instr Verb
gaVerbL dcblock gaVerbL
gaVerbR dcblock gaVerbR
kRoomSize  init  0.65 ; room size (range 0 to 1)
kHFDamp    init  0.8  ; high freq. damping (range 0 to 1)
al,ar freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp, 44100, 1
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
t           0       120
i"Tree"     0       0
i"Drums"    16      [3*60]
i"Terrain"  0       [4*60]
e
</CsScore>
</CsoundSynthesizer>

