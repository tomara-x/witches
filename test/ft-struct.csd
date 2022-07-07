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

;children ------------------------+
;mother node -------------------+ |
;counter ---------------------+ | |
;values --------------+-+-+-+ | | |
;size ---------+      | | | | | | |
;Node # --+    |      | | | | | | |
;         |    |      | | | | | | |
;         N    S      v v v v c m c ...
iN1 ftgen 1,0,-16,-2, 0,0,0,0,0,0,0,0
iN2 ftgen 2,0,-16,-2, 0,0,0,0,0,1,0,0
iN3 ftgen 3,0,-16,-2, 0,0,0,0,0,1,0,0
iN4 ftgen 4,0,-16,-2, 0,0,0,0,0,1,0,0
iN5 ftgen 5,0,-16,-2, 0,0,0,0,0,1,0,0
iN6 ftgen 6,0,-16,-2, 0,0,0,0,0,1,0,0
iN7 ftgen 7,0,-16,-2, 0,0,0,0,0,1,0,0
iN8 ftgen 8,0,-16,-2, 0,0,0,0,0,1,0,0

;the index after which we have the mother node and children, make that a variable?
;so it'd be a vatiable number of values per step? who needs more than 4 tho?
;indexes 0 to 3 are node values (frequency, intensity, whatever)
;index 4 is node counter
;mother at 5 and then children at 6+
;(use 2 tables per node? i don't like it, i want it simple lol)

;this can self-modify
;when at node x, make new connection, modify values, teleport to new node,...

;a create-node udo (we can track the numbers globally and ignore names)
;a connect-nodes udo (tab write input to empty child/mother indices)
;a disconnect udo
;a set-values udo
;a set-counter udo
;a clear-children udo
;a clear-mother udo?
;a reset all counters udo?
;a walk udo (hbout this udo keeps track of the counts?)
;hbout the walk just outputs node number, and have a get-node-values udo?


instr 1
ftprint 1
endin
</CsInstruments>
<CsScore>
i1 0 0.1
e
</CsScore>
</CsoundSynthesizer>


