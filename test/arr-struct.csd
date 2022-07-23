//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;this is an effort to try replicating some of the functionality of the
;network sequencer by Mog [https://github.com/JustMog/Mog-VCV]
;thank you so much!


;opcode definitions moved to mycorrhiza.orc

;                      branches ---------------+-+-+
;                      root node ------------+ | | |
;                      values -------+-+-+-+ | | | |
;                                    | | | | | | | |
;                                    V + + + R B B B
;tree_init(8, 4, 3)    N#0-----------0,0,0,0,N,1,2,3       +--0--+
;node_connect(0, 1)    N#1-----------0,0,0,0,0,4,5,N       |  |  |
;node_connect(0, 2)    N#2-----------0,0,0,0,0,6,N,N    +--1  2  3
;node_connect(0, 3) -> N#3-----------0,0,0,0,0,N,N,N -> |  |  |
;node_connect(1, 4)    N#4-----------0,0,0,0,1,N,N,N    4  5  6
;node_connect(1, 5)    N#5-----------0,0,0,0,1,N,N,N          |
;node_connect(2, 6)    N#6-----------0,0,0,0,2,7,N,N          7
;node_connect(6, 7)    N#7-----------0,0,0,0,6,N,N,N

;jam irresponsibly
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

#include "mycorrhiza.orc"

instr 1
tree_init(8, 8, 8)
node_connect_i(0, 1)
node_connect_i(0, 2)
node_connect_i(0, 3)
node_connect_i(1, 4)
node_connect_i(1, 5)
node_connect_i(2, 6)
node_connect_i(6, 7)
endin

instr 2
kn = node_climb(0)
printk 0, kn
;printarray gk_Tree
endin

</CsInstruments>
<CsScore>
i1 0 0.0
i2 1 0.3
e
</CsScore>
</CsoundSynthesizer>

;you know what this needs? an additive voice with a bunch of inharmonic
;partials. you know that sound? kinda like a handpan.. ooo mama! have mercy!

