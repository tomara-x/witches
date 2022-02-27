//trans rights!
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

instr Arr1
iarr[][] init 4, 8 ;4 rows, 8 colomns
printarray(iarr)
endin
;schedule("Arr1", 0, 1)

instr Arr2
iarr[][] init 4, 8
iarr[1][2] = 105
printarray(iarr)
endin
;schedule("Arr2", 0, 1)

instr Arr3
iarr[][] init 4, 8
irow[] = fillarray(105,105,105,105,105,105,105,105)
iarr setrow irow, 1
printarray(getrow(iarr, 1))
endin
;schedule("Arr3", 0, 1)

instr Arr4
iarr[] init 32
;iarr = 105 ;works for krate, but not here
iarr += 105
reshapearray(iarr, 4,8)
printarray(iarr)
endin
;schedule("Arr4", 0, 1)

instr Arr5
karr[][]    init 4, 8
ktrig       metro 1
;karr[1][0] += 2 ;oh yeah, this workn't
karr = setrow(fillarray(1,1,1,1,1,1,1,1), 2) ;functional syntax be epic
            printarray(karr, ktrig)
endin
;schedule("Arr5", 0, 1)

instr Arr6
karr[][]    init 4, 8
ktrig       metro 1
kswitch     init 1
if kswitch == 1 then
    krow[] = fillarray(1,1,1,1,1,1,1,1)
    kswitch = 0
endif
karr = setrow(krow, 2)
            printarray(karr, ktrig)
endin
;schedule("Arr6", 0, 4)

instr Arr7 ;seg fault
karr[][]    init 4, 8
ktrig       metro 1
kv          init 1
kv += ktrig
krow[] = fillarray(1,1,1,kv,1,1,1,1)
karr = setrow(krow, 2)
            printarray(karr, ktrig)
endin
;schedule("Arr7", 0, 4)

instr Arr8 ;works! cutest language ever!
kv init 0
kv += 1
if kv < 4 then
    karr[] = fillarray(1,1,1,kv,1,1,1,1)
endif
printarray(karr)
endin
;schedule("Arr8", 0, .1)

instr Arr9 ;seg fault (WHY?!) (is it like a re-declaration thing?)
karr[][]    init 4, 8
kv          init 0
kv += 1
krow[] = fillarray(1,1,1,kv,1,1,1,1)
karr = setrow(krow, 2) ;yep something's up here!
printarray(karr)
endin
;schedule("Arr9", 0, .1)

instr Arr10 ;hmm works! you gotta init before fillarraying here? (unlike Arr8)
karr[][]    init 4, 8
krow[]      init 8
kv          init 0
kv += 1
krow = fillarray(1,1,1,kv,1,1,1,1)
karr = setrow(krow, 2)
printarray(karr)
endin
;schedule("Arr10", 0, .1)

instr Arr11 ;interesting! another seg fault!
karr[][]    init 4, 8
kv          init 0
kv += 1
karr = setrow(fillarray(1,1,1,kv,1,1,1,1), 2)
printarray(karr)
endin
;schedule("Arr11", 0, .1)

instr Arr12 ;works
kv init 0
kv += 1
karr[] = fillarray(1,1,1,kv,1,1,1,1)
printarray(karr)
endin
;schedule("Arr12", 0, .1)

instr Arr13 ;works
kv init 0
kv += 1
printarray(fillarray(1,1,1,kv,1,1,1,1))
endin
;schedule("Arr13", 0, .1)

instr Arr14 ;something's off here
karr[][]    init 4, 8
kcol[]      init 4
kcol = fillarray(1,2,3,4) ;will seg fault too if using array with k-values (without init)
karr = setcol(kcol, 0)
printarray(karr)
endin
;schedule("Arr14", 0, .01)

instr Arr15 ;okay getcol works as expected, unlike setcol
karr[][]    init 3,8
karr = fillarray(1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0)
printarray(karr)
printarray(getcol(karr,0))
endin
;schedule("Arr15", 0, .1)

instr Arr16
karr[][]    init 3,5 ;it's counting by column length+1 instead of row length
kcol[]      init 4
kcol = fillarray(1,1,1)
karr = setcol(kcol, 0)
printarray(karr)
endin
schedule("Arr16", 0, .01)

</CsInstruments>
</CsoundSynthesizer>
