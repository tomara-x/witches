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

;;children ----------------------+
;;mother node -----------------+ |
;;values --------------+-+-+-+ | |
;;size ---------+      | | | | | |
;;Node # --+    |      | | | | | |
;;         |    |      | | | | | |
;;         N    S      v v v v m c ...
;iN1 ftgen 1,0,-16,-2, 0,0,0,0,0,0,0
;iN2 ftgen 2,0,-16,-2, 0,0,0,0,1,0,0
;iN3 ftgen 3,0,-16,-2, 0,0,0,0,1,0,0
;iN4 ftgen 4,0,-16,-2, 0,0,0,0,1,0,0
;iN5 ftgen 5,0,-16,-2, 0,0,0,0,1,0,0
;iN6 ftgen 6,0,-16,-2, 0,0,0,0,1,0,0
;iN7 ftgen 7,0,-16,-2, 0,0,0,0,1,0,0
;iN8 ftgen 8,0,-16,-2, 0,0,0,0,1,0,0

;a connect-nodes udo (tab write input to empty child/mother indices)
;(maybe assign more than one node to same mother)
;a disconnect udo
;a set-values udo
;a clear-children udo
;a clear-mother udo?
;a walk udo (keeps track of the progress internally) (reset-node/all trig inputs)
;hbout the walk just outputs node number, and have a get-node-values udo?
;copy node udo? (man i'm overdoing it with this planning biz)
;ftfree delete node?

;variable number of values per step? make them 8?
;indexes 0 to 3 are node values (frequency, intensity, whatever)
;ooo maybe even node repetition? reset node counter for n-times?
;mother at 4 and then children at 5+

;this can self-modify
;when at node x, make new connection, modify values, teleport to new node,...

;IMPORTANTE: segment your work into smaller udo's (goto-child-n, goto-mother, etc)
gk_num_values = 8
;default node size?

;create a single empty node.
;syntax: iNodeNum node_create iSize
;iSize: number of node feilds (values+mother+children)
opcode node_create, i, i
isize xin
xout(ftgen(0,0,-abs(isize), -2, 0))
endop

instr 1
inode node_create 16
endin

</CsInstruments>
<CsScore>
i1 0 0.1
e
</CsScore>
</CsoundSynthesizer>

