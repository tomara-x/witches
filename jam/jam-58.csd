//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #136#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#
#include "../taphy.orc"
#include "../basma.orc"
#include "../utils.orc"
gay, gal, gar init 0



instr Seq1
kTrig    metro $FRQ*4
kTrig2   metro $FRQ/4
kCount[] fillarray 1, 1, 1, 1, 1, 1, 1, 1
kGain[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0
;p the range and root note
iScale   ftgenonce 0,0,-7*3,-51, 7,2,cpspch(6),0,
1,2^(3/12),2^(4/12),2^(5/12),2^(6/12),2^(7/12),2^(10/12) ;7-tone blues
kNote[]  fillarray 6, 2, 9, 1, 0, 7, 0, 4
kTrans[] fillarray 0, 0, 0, 0, 0, 0, 0, 0
kQueue[] fillarray 0, 0, 0, 0, 0, 0, 0, 0

kBS, kBT[] Basma kTrig, kCount, 1, 3, kQueue
kTS, kTP[], kTT[] Taphy kBT[kBS], kNote, kQueue, iScale

if kBT[kBS] == 1 then
    ;maybe p this and a 2^ option
    kCount[kBS] = kCount[kBS] + kGain[kBS]
endif
if kTT[kTS] == 1 then
    kNote[kTS] = kNote[kTS] + kTrans[kTS]
endif

;p this whole deal?
kTrans[0] = randomh(0, 1, $FRQ/16)
kTrans[1] = randomh(0, 3, $FRQ/16)
kTrans[2] = randomh(0, 2, $FRQ/16)
kTrans[3] = randomh(0, 2, $FRQ/16)
kTrans[4] = randomh(0, 8, $FRQ/16)
kTrans[5] = randomh(0, 3, $FRQ/16)
kTrans[6] = randomh(0, 4, $FRQ/16)
kTrans[7] = randomh(0, 8, $FRQ/16)

kGain[0] = randomh(-4, 4, $FRQ) ;add imode=3 for random init values
kGain[1] = randomh(-4, 4, $FRQ)
kGain[2] = randomh(-4, 4, $FRQ)
kGain[3] = randomh(-4, 4, $FRQ)
kGain[4] = randomh(-4, 4, $FRQ)
kGain[5] = randomh(-4, 4, $FRQ)
kGain[6] = randomh(-4, 4, $FRQ)
kGain[7] = randomh(-4, 4, $FRQ)

;hmm nother p?
if ClkDiv(kBT[0], 8) == 1 then
    kCount = 1
endif

;p's for the parameters of the bleep?
schedkwhen(kBT[kBS],0,0, "Bleep", 0, .4, -6, .5, kTP[kTS])
schedkwhen(kBT[kBS],0,0, "Bleep", 0, .4, -0, .5, kTP[kTS]/2)
;p this ;NO! DRUMS OUTSIDE!
;a seq3 instr for drums
;schedkwhen(kBT[0],0,0, "Drm1", 0, .5, -18, .5)

;it's supposed to be the doll breathing
;it shouldn't sound human, nor should it have a steady rhythm
;maybe a new instr for this sound
schedkwhen(kBT[4],0,0, "Snare", 0, 1, 2, 1, 1)

schedkwhen(kTrig2,0,0, "Drm1", 0, .5, -18, .5)
schedkwhen(kTrig2,0,0, "Snare", $BEAT*2, .8, 2, 2)
endin



instr Seq2 ;this'll need its own bleep
;LAYER THIS WITH AN UNMODULATED BASMA!
kTrig    metro $FRQ*16
kTrig2   metro $FRQ/4
kCount[] fillarray 2, 3, 3, 4, 4, 2, 1, 2
kGain[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0
;p the range and root note
iScale   ftgenonce 0,0,-7*3,-51, 7,2,cpspch(7),0,
1,2^(3/12),2^(4/12),2^(5/12),2^(6/12),2^(7/12),2^(10/12) ;7-tone blues
kNote[]  fillarray 6, 2, 9, 1, 0, 7, 0, 4
kTrans[] fillarray 0, 0, 0, 0, 0, 0, 0, 0
kQueue[] fillarray 0, 0, 0, 0, 0, 0, 0, 0

kBS, kBT[] Basma kTrig, kCount, 1, 16, kQueue
kTS, kTP[], kTT[] Taphy kBT[kBS], kNote, kQueue, iScale

if kBT[kBS] == 1 then
    ;maybe p this and a 2^ option
    kCount[kBS] = kCount[kBS] + kGain[kBS]
endif
if kTT[kTS] == 1 then
    kNote[kTS] = kNote[kTS] + kTrans[kTS]
endif

;p this whole deal?
kTrans[0] = randomh(0, 1, $FRQ/16)
kTrans[1] = randomh(0, 3, $FRQ/16)
kTrans[2] = randomh(0, 2, $FRQ/16)
kTrans[3] = randomh(0, 2, $FRQ/16)
kTrans[4] = randomh(0, 8, $FRQ/16)
kTrans[5] = randomh(0, 3, $FRQ/16)
kTrans[6] = randomh(0, 4, $FRQ/16)
kTrans[7] = randomh(0, 8, $FRQ/16)

kGain[0] = randomh(-4, 4, $FRQ)
kGain[1] = randomh(-4, 4, $FRQ)
kGain[2] = randomh(-4, 4, $FRQ)
kGain[3] = randomh(-4, 4, $FRQ)
kGain[4] = randomh(-4, 4, $FRQ)
kGain[5] = randomh(-4, 4, $FRQ)
kGain[6] = randomh(-4, 4, $FRQ)
kGain[7] = randomh(-4, 4, $FRQ)

;hmm nother p?
if ClkDiv(kBT[0], 8) == 1 then
;    kCount = 1
endif

;p's for the parameters of the bleep?
schedkwhen(kBT[kBS],0,0, "Bleep", 0, .4, -6, .5, kTP[kTS])
;schedkwhen(kBT[kBS],0,0, "Bleep", 0, .4, -0, .5, kTP[kTS]/2)
;p this
schedkwhen(kTrig2,0,0, "Drm1", 0, .5, -18, .5)
schedkwhen(kTrig2,0,0, "Snare", $BEAT*2, .2, 2, 2)
endin



instr Bleep
aEnv linseg 1, p3, 0
aS1  vco2 1, 1*p6+(1-k(aEnv))*cpspch(lfo(0.005, 3)), 2, 0.5
aS2  vco2 1, 2*p6+(1-k(aEnv))*cpspch(lfo(0.005, 3)), 2, 0.5
aSig = (aS1+aS2)/2
;i wanna add more of these babies!
aF1 diode_ladder aSig, limit(p6*32*aEnv^4, 0, sr/2), 12*aEnv^32, 1, 20 ;last edit:feedback env
aF2 diode_ladder aSig, limit(p6*16*aEnv^8, 0, sr/2), 16*aEnv^32, 1, 80
aF2 pdhalf aF2, -0.99
aF2 *= .2 ;2 skip dis
aF2 limit aF2, -0.5, 0.5
aSig = (aF1+aF2)/2
aSig *= aEnv
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-12)
gaVerbR += ar*db(-12)
endin



instr Drm1
iTanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
iIFrq   = 230
iEFrq   = 20
aAEnv   linseg 1,p3,0
aSig1   oscili aAEnv^2, expseg:k(iIFrq,p3/4,iEFrq)
aSig2   oscili aAEnv^2, expseg:k(iIFrq,p3/4,iEFrq)
aSig3   oscili aAEnv^2, expseg:k(iIFrq,p3/2,iEFrq*2^7)
aSig = (aSig1*2+aSig2+aSig3*.5)/3
aSig    distort aSig*2, 0.6, iTanh
;aSig    limit aSig, -0.5,0.5
aSig    += moogladder(aSig, iIFrq*2, .3)
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-12)
gaVerbR += ar*db(-12)
endin



instr Drm2
iTanh ftgenonce 0,0,1024,"tanh", -5, 5, 0
iIFrq   = 420
iEFrq   = 230
aAEnv   linseg 1,p3,0
aSig1   oscili aAEnv^2, expseg:k(iIFrq,p3/4,iEFrq)
aSig2   oscili aAEnv^2, expseg:k(iIFrq,p3/4,iEFrq)
aSig3   oscili aAEnv^2, expseg:k(iIFrq,p3/2,iEFrq*2^7)
aSig4   noise  aAEnv^2, expseg:k(-0.9, p3/4, -0.1)
aSig = (aSig1*2+aSig2+aSig3*.5+aSig4)/4
aSig    distort aSig*2, 0.6, iTanh
;aSig    limit aSig, -0.5,0.5
aSig    += moogladder(aSig, iIFrq*2, .3)
aSig    pdhalf aSig, -0.8
al, ar pan2 aSig*db(p4), p5
gal += al
gar += ar
gaVerbL += al*db(-12)
gaVerbR += ar*db(-12)
endin



;edited version of a dseq instr [csoundjournal.com/issue8/dseq.html]
;AIM! STUDY THIS!
instr Snare
iFt1 ftgenonce 0,0,2^16+1, 10, 1
iFt2 ftgenonce 0,0,2^13, -7, -1,2^12,1,2^12,-1
idur   = p3
ivalue = p4 / 15
iamp   = p5 * 0.5 * ivalue

atri         oscil3 1, 111 + ivalue * 5, iFt2
areal, aimag hilbert atri

ifshift =      175
asin    oscil3 1, ifshift, iFt1
acos    oscil3 1, ifshift, iFt1, .25
amod1   =      areal * acos
amod2   =      aimag * asin
ashift1 =      ( amod1 + amod2 ) * 0.7

ifshift2 =      224
asin     oscil3 1, ifshift2, iFt1
acos     oscil3 1, ifshift2, iFt1, .25
amod1    =      areal * acos
amod2    =      aimag * asin
ashift2  =      ( amod1 + amod2 ) * 0.7

kenv1     line 1, 0.15, 0
ashiftmix =    ( ashift1 + ashift2 ) * kenv1

aosc1   oscil3 1, 180, iFt1
aosc2   oscil3 1, 330, iFt1
kenv2   linseg 1, 0.08, 0, idur - 0.08, 0
aoscmix =      ( aosc1 + aosc2 ) * kenv2

anoise gauss    1
anoise butterhp anoise, 2000
anoise butterlp anoise, 3000 + ivalue * 3000
anoise butterbr anoise, 4000, 200
kenv3  expon    2, 0.15, 1
anoise =        anoise * ( kenv3 - 1 )

amix = aoscmix + ashiftmix + anoise * 4
amix = amix * iamp
gay += amix
endin



instr Scream
kTrig    metro $FRQ*8
kCount[] fillarray 1, 1, 1, 1, 1, 1, 1, 1
kGain[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0
iScale ftgenonce 0,0,-31*2,-51, 31,2,cpspch(8),0,
2^(00/31),2^(01/31),2^(02/31),2^(03/31),
2^(04/31),2^(05/31),2^(06/31),2^(07/31),
2^(08/31),2^(09/31),2^(10/31),2^(11/31),
2^(12/31),2^(13/31),2^(14/31),2^(15/31),
2^(16/31),2^(17/31),2^(18/31),2^(19/31),
2^(20/31),2^(21/31),2^(22/31),2^(23/31),
2^(24/31),2^(25/31),2^(26/31),2^(27/31),
2^(28/31),2^(29/31),2^(30/31)
kNote[]  fillarray 6, 2, 9, 1, 0, 7, 0, 4
kTrans[] fillarray 0, 0, 0, 0, 0, 0, 0, 0
kQueue[] fillarray 0, 0, 0, 0, 0, 0, 0, 0

kBS, kBT[] Basma kTrig, kCount, 1, 16, kQueue
kTS, kTP[], kTT[] Taphy kBT[kBS], kNote, kQueue, iScale

if kBT[kBS] == 1 then
    kCount[kBS] = kCount[kBS] + ((2^kGain[kBS]))
endif
if kTT[kTS] == 1 then
    kNote[kTS] = kNote[kTS] + kTrans[kTS]
endif

kTrans[0] = randomh(0, 18, $FRQ/16)
kTrans[1] = randomh(0, 08, $FRQ/16)
kTrans[2] = randomh(0, 09, $FRQ/16)
kTrans[3] = randomh(0, 24, $FRQ/16)
kTrans[4] = randomh(0, 05, $FRQ/16)
kTrans[5] = randomh(0, 27, $FRQ/16)
kTrans[6] = randomh(0, 16, $FRQ/16)
kTrans[7] = randomh(0, 02, $FRQ/16)

kGain[0] = randomh(-4, 4, $FRQ)
kGain[1] = randomh(-4, 4, $FRQ)
kGain[2] = randomh(-4, 4, $FRQ)
kGain[3] = randomh(-4, 4, $FRQ)
kGain[4] = randomh(-4, 4, $FRQ)
kGain[5] = randomh(-4, 4, $FRQ)
kGain[6] = randomh(-4, 4, $FRQ)
kGain[7] = randomh(-4, 4, $FRQ)

;fof2
;fofilter
;polymelody?

;gay += aSig
;gaVerbL += al*db(-12)
;gaVerbR += ar*db(-12)
endin



gaVerbL,gaVerbR init 0
instr Verb
kRoomSize  init  0.85 ; room size (range 0 to 1)
kHFDamp    init  0.9  ; high freq. damping (range 0 to 1)
denorm gaVerbL, gaVerbR
aVerbL,aVerbR freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp
gal += aVerbL
gar += aVerbR
clear gaVerbL,gaVerbR
endin



instr Out
kSM = 1
gal limit gal+gay, -kSM, kSM
gar limit gar+gay, -kSM, kSM
outs gal, gar
clear gay, gal, gar
endin
</CsInstruments>
<CsScore>
i"Verb"   0 -1
t 0 136
i"Out"    0 [8*64]
;i"Seq1"   0 [2*64]
;i"Seq2"   0 [2*64]
i"Scream" 0 [2*64]
</CsScore>
</CsoundSynthesizer>

