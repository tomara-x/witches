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
                 8.00, 9.02, 9.04, 9.06, 9.07, 9.09, 9.11, 10.00
icnt = 0
while icnt < 16 do
    node_set_value_i(icnt, 0, iPch[icnt])
    icnt += 1
od
endin
schedule("Tree", 0, 0)



instr Call
kCnt init 0
kTrig MyMetro $FRQ*1
if kTrig == 1 then
    kN = node_climb3(0)
    kcps = cpspch(node_get_value_k(kN, 0))
    schedulek "String",0,$BEAT, 0.1, kcps, 0.2, 0.8, 0.9
    kCnt += 1
endif
if kCnt == 16 then
    schedulek "Response", $BEAT, -1
    turnoff
endif
endin

instr Response
kCnt init 0
kTrig MyMetro $FRQ*1
if kTrig == 1 then
    kN = node_climb3(8)
    kcps = cpspch(node_get_value_k(kN, 0))
    schedulek "String",0,$BEAT, 0.1, kcps, 0.2, 0.5, 0.2
    kCnt += 1
endif
if kCnt == 4 then
    schedulek "Call", $BEAT, -1
    turnoff
endif
endin
schedule("Call", 0, -1)



gaString init 0
instr String
iPlk  =        p6 ;(0 to 1)
iAmp  =        p4
iCps  =        p5
kPick init     p7 ;pickup point
kRefl init     p8 ;rate of decay ]0,1[
aSig  wgpluck2 iPlk,iAmp,iCps,kPick,kRefl
aEnv  linsegr  0,0.005,1,p3-0.01,1,0.005,0 ;declick
gaString += aSig*aEnv
endin
instr StringP
aSig = gaString
;aSig pdhalf aSig, -0.9
;aSig clip aSig, 1, 0.1
;aSig rbjeq aSig, 200, 2, 0, 8, 10
aSig wguide2 aSig, 40, 60, 8000, 10000, 0.23, 0.2
aSig wguide2 aSig, 37, 23, 9400, 12000, 0.13, 0.3
vincr gaVerbL, aSig*db(-12)
vincr gaVerbR, aSig*db(-12)
sbus_mix 1, aSig
clear gaString
endin
schedule("StringP", 0, -1)


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

