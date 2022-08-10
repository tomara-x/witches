//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231 ;-m227
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #60#
#define FRQ   #($TEMPO/60)#

#include "mycorrhiza.orc"
#include "utils.orc"

instr Tree
tree_init(32, 8, 16)
iarr[] = fillarray(1,2,3,4,5,6,7)
node_connect_i(0, iarr)
endin
schedule("Tree", 0, 0)


instr Terrain
kTrig = MyMetro($FRQ)

if kTrig == 1 then
    kN = node_climb(0)
    printk 0, kN
endif
endin

</CsInstruments>
<CsScore>
i"Terrain"  0       60
e
</CsScore>
</CsoundSynthesizer>


