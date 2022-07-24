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

iarr[] = fillarray(17, 18, 19, 20)
node_connect_i(16, iarr)
iarr[] = fillarray(21, 22, 23)
node_connect_i(18, iarr)
iarr[] = fillarray(24, 25, 26)
node_connect_i(23, iarr)
iarr[] = fillarray(27, 28)
node_connect_i(24, iarr)
node_connect_i(19, 29)
node_connect_i(20, 30)
node_connect_i(25, 31)
endin
schedule("Seed", 0, 0)              ;run instr for i-pass only



instr Soil
seed(420)
;generate 32 notes of a scale
iScale ftgenonce 0,0,-32,-51, 7,2,cpspch(6),0,
1,2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12) ;natural minor
icnt = 0
while icnt < 32 do
    ;set first value of each node to frequency of each note in the scale
    node_set_value_i(icnt, 0, table(random:i(0,32), iScale))
    icnt += 1
od
endin
schedule("Soil", 0, 0)



instr Water
kN init 0
kSwitch init 0

kT1 metro $FRQ*1
kT2 metro $FRQ*4
kT3 metro $FRQ*2

if kN == 1 then
    kSwitch = 1
elseif kN == 2 then
    kSwitch = 2
elseif kN == 3 then
    kSwitch = 0
endif

kTrig = kT1
if kSwitch == 1 then
    kTrig = kT2
elseif kSwitch == 2 then
    kTrig = kT3
endif

if kT3 != 0 then
    kN = node_climb(16)
    schedulek("Leaf", 0, $BEAT/4, kN, 2)
endif

if kTrig != 0 then
    kN = node_climb(0)
    schedulek("Leaf", 0, $BEAT/4, kN, 1)
endif
endin
schedule("Water", 0, 60)



instr Leaf
aEnv  = linseg(1,p3,0)
kFrq  = node_get_value_k(p4, 0)    ;get value stored at index 0 of node p4
kFrq  *= 2^p5
aSig  = vco2(1, kFrq/2, 10)
aSig  += vco2(1, kFrq/4, 10)
aSig  = chebyshevpoly(aSig, 3,2,9,0,3,8,4,4)
aNois = random:a(0, 2)
aSig  *= aNois
aSig  *= aEnv^4
aSig  = powershape(aSig, 17)
aSig  *= db(-3)
aEnv  = aEnv^4
aSig  = diode_ladder(aSig, limit(kFrq*32*aEnv, 0, sr/2), 17*aEnv, 1, 40)
sbus_mix(0, aSig) 
endin



instr Flower
aEnv = linseg(0,p3*.03,1, p3*.6,0)
kFrq = node_get_value_k(p4, 0)
aSig = vco2(1, kFrq*8, 10)
aSig *= aEnv^2
aSig *= db(-12)
aSig = diode_ladder(aSig, limit(kFrq*16, 0, sr/2), 16, 1, 180)
sbus_mix(1, aSig) 
endin


/*
instr Grain
seed 113
kGFrq = kP[kS]
kGPhs = 0
kFMD = randomi(0, 1, $FRQ/4)
kPMD = 0
kGDur = randomi($BEAT/p12, $BEAT/p13, $FRQ*p14)
kGDens = randomi($FRQ*p15, $FRQ*p16, $FRQ*p17)
iMaxOvr = 32
iWav ftgenonce 0,0,2^14,9, 1,1,0, 2,.2,0, 3,.2,0
iWin ftgenonce 0,0,2^14,20, 2, 1
kFRPow, kPRPow = 1, 1
aSig grain3 kGFrq,kGPhs, kFMD,kPMD, kGDur,kGDens, iMaxOvr,
            iWav, iWin, kFRPow,kPRPow, getseed(), 16
al, ar pan2 aSig*db(p4), p5
endin
*/


instr Pdhalf
;p4 = mixer channel to pdhalf
;p5 = distortion amount
ga_sbus[p4][0] pdhalf ga_sbus[p4][0], p5
ga_sbus[p4][1] pdhalf ga_sbus[p4][1], p5
endin



instr Distort
;p4 = mixer channel to distort
;p5 = distortion amount
iTanh ftgenonce 0,0,2^10+1,"tanh", -5, 5, 0
ga_sbus[p4][0] distort ga_sbus[p4][0], p5, iTanh
ga_sbus[p4][1] distort ga_sbus[p4][1], p5, iTanh
endin



instr Diode
;p4 = mixer channel to filter
;p5 = cutoff frequency
;p6 = feedback
;p7 = saturation
ga_sbus[p4][0] diode_ladder ga_sbus[p4][0], limit(p5, 0, sr/2), p6, 1, p7
ga_sbus[p4][1] diode_ladder ga_sbus[p4][1], limit(p5, 0, sr/2), p6, 1, p7
endin



;pluck env instr



instr Out
aL, aR sbus_out
kSM = 1
;hrtf?
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

