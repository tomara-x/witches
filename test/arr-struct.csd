//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

gi_NumOfNodes = 8
gi_ValuesPerNode = 4 ;roots index
gi_NodeLength = 8
gk_Tree[][] init gi_NumOfNodes, gi_NodeLength

;branches -----------------------+-+-+
;root node --------------------+ | | |
;values -------+-+-+-+-+-+-+-+ | | | |
;              | | | | | | | | | | | |
;              v v v v v v v v m c c ...   
;N#0-----------0,0,0,0,0,0,0,0,N,1,2,3               +--0--+
;N#1-----------0,0,0,0,0,0,0,0,0,4,5,N               |  |  |
;N#2-----------0,0,0,0,0,0,0,0,0,6,N,N            +--1  2  3
;N#3-----------0,0,0,0,0,0,0,0,0,N,N,N     ->     |  |  |
;N#4-----------0,0,0,0,0,0,0,0,1,N,N,N            4  5  6
;N#5-----------0,0,0,0,0,0,0,0,1,N,N,N                  |
;N#6-----------0,0,0,0,0,0,0,0,2,7,N,N                  7
;N#7-----------0,0,0,0,0,0,0,0,6,N,N,N   

;connect-nodes udo (take root and 1 branch) (use loops outside)
;set-values (array input / single index value) 
;get-values (array slice / single index value)
;clear-branches
;clear-root (maybe)
;disconnect (isolate node) (clear branches and root)
;copy-node
;walk (keeps track of the progress internally) (reset-node/all trig inputs)

instr 1
gk_Tree[0][4] = 420
printarray getrow(gk_Tree, 0)
endin

</CsInstruments>
<CsScore>
i1 0 0.1
e
</CsScore>
</CsoundSynthesizer>

