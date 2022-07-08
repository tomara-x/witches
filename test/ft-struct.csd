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

;children ----------------------+
;mother node -----------------+ |
;values --------------+-+-+-+ | |
;size ---------+      | | | | | |
;Node # --+    |      | | | | | |
;         |    |      | | | | | |
;         N    S      v v v v m c ...
iN1 ftgen 1,0,-16,-2, 0,0,0,0,0,0,0
iN2 ftgen 2,0,-16,-2, 0,0,0,0,1,0,0
iN3 ftgen 3,0,-16,-2, 0,0,0,0,1,0,0
iN4 ftgen 4,0,-16,-2, 0,0,0,0,1,0,0
iN5 ftgen 5,0,-16,-2, 0,0,0,0,1,0,0
iN6 ftgen 6,0,-16,-2, 0,0,0,0,1,0,0
iN7 ftgen 7,0,-16,-2, 0,0,0,0,1,0,0
iN8 ftgen 8,0,-16,-2, 0,0,0,0,1,0,0

;a create-node udo (we can track the numbers globally and ignore names)
;a connect-nodes udo (tab write input to empty child/mother indices)
;(maybe assign more than one node to same mother)
;a disconnect udo
;a set-values udo
;a clear-children udo
;a clear-mother udo?
;a walk udo (keeps track of the progress internally) (reset-node/all trig inputs)
;hbout the walk just outputs node number, and have a get-node-values udo?

;no:
;a set-counter udo (not if walk tracks counts)
;a reset all counters udo? (reset node counter?)

;variable number of values per step? make them 8?
;indexes 0 to 3 are node values (frequency, intensity, whatever)
;ooo maybe even node repetition? reset node counter for n-times?
;mother at 4 and then children at 5+

;this can self-modify
;when at node x, make new connection, modify values, teleport to new node,...

;test create at timek/s



;hbout a 2d array though? can be local or global, we can have mutiple ones,
;no fussing about the tab numbers nonsense...
;any downsides? lmao, we copy the whole thing in and out every cycle.. lol lmao

;mkay, hbout a global one that's not passed as input?
;it has to be one though, and a fixed name

;3d arrays? x is node, y is values, z is mother and children?
;woudln't that just complicate it further?

;with arrays it's a fixed max number of nodes tho, can't just define an extra node
;with ft's it's possible to create and connect a growing number of nodes


gkA1[] init 4

opcode test, 0, k
kn xin
gkA1[kn] = gkA1[kn]+1
endop


instr 1
printarray(gkA1)
test(0)
endin
</CsInstruments>
<CsScore>
i1 0 0.1
e
</CsScore>
</CsoundSynthesizer>


