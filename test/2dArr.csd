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

instr Arr8
kv init 0
kv += 1
if kv < 4 then
    karr[] = fillarray(1,1,1,kv,1,1,1,1)
endif
printarray(karr)
endin
schedule("Arr8", 0, .1)

</CsInstruments>
</CsoundSynthesizer>
