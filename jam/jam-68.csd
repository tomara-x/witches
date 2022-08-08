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

#define TEMPO #60#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

#include "mycorrhiza.orc"
#include "perfuma.orc"
#include "utils.orc"
#include "mixer.orc"
#include "drums.orc"

seed 42

giScale ftgenonce 0,0,-32,-51, 5,2,cpspch(5.02),0,
1,2^(2/12),2^(4/12),2^(5/12),2^(7/12),2^(9/12),2^(11/12) ;D major


instr Soil
tree_init(32, 8, 16)                ;32 nodes, 8 values and 16 branches each

iarr[] = fillarray(1, 2)
node_connect_i(0, iarr)             ;connect nodes 1,2 as branches of 0
iarr[] = fillarray(3, 4, 5)
node_connect_i(1, iarr)             ;connect nodes 3, 4, 5 as branches of 1
node_connect_i(3, 6)                ;connect node 6 as branch of 3
node_connect_i(2, 7)                ;connect node 7 as branch of 2

;nother bush
iarr[] = fillarray(17, 18, 19, 20, 21, 22, 23)
node_connect_i(16, iarr)

icnt = 0
while icnt < 32 do
    node_set_value_i(icnt, 0, table(random:i(0,32), giScale))
    icnt += 1
od
endin
schedule("Soil", 0, 0)              ;run instr for i-pass only


instr 1
kS init -1
kTrig = MyMetro($FRQ)
kS += kTrig
kS = wrap(kS, 0, 4)

if kTrig != 0 then
    kN = node_climb(16)
endif

;aSig *= db(linsegr(-24,4,-128))
;sbus_mix 0, aSig
endin


instr 3
kT = MyMetro($FRQ)
;schedkwhen(kT,0,0, "Kick", 0, -1, .5, 230, 20, 1, 0)
schedkwhen(kT,0,0, "HatO", 0, 0.8, .1, -.9)

;schedkwhen(kT,0,0, "HatC", 0,    0.1,  .3, -0.9)
schedkwhen(kT,0,0, "HatC", 0.5,  0.1,  .2, -0.9)
schedkwhen(kT,0,0, "HatC", 4.25, 0.25, .1, -0.8)
schedkwhen(kT,0,0, "HatC", 4.75, 0.25, .06, -0.8)
endin


instr Out
aL, aR sbus_out
aL clip aL, 0, 1
aR clip aR, 0, 1
outs aL, aR
sbus_clear_all
endin
</CsInstruments>
<CsScore>
i"Out" 0 60
;i1     0 8
i3 0 60
e
</CsScore>
</CsoundSynthesizer>

