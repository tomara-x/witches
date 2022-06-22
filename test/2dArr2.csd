//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//some comments here are lol
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

;set row to constant
opcode SetRow, k[], k[]kk
kArr[], knum, kndx xin
irowlen = lenarray(getrow(kArr,0))
kcnt = 0
while kcnt < irowlen do
    kArr[kndx][kcnt] = knum
    kcnt += 1
od
xout kArr
endop
;set row to 1d array
opcode SetRow, k[], k[]k[]k
kArr[], kv[], kndx xin
irowlen = lenarray(getrow(kArr,0))
;irowlen = lenarray(kv)
// ^ doesn't work unless fillarray is on initialized array
//I think fillarray doean't work at i-time and this is what happens with
//the original setrow/setcol with uninitialized arrays
//so I might use the other way and keep these? 
//I wanna take another look at the source though
kcnt = 0
while kcnt < irowlen do
    kArr[kndx][kcnt] = kv[kcnt]
    kcnt += 1
od
xout kArr
endop

;set column to constant
opcode SetCol, k[], k[]kk
kArr[], knum, kndx xin
icollen = lenarray(getcol(kArr,0))
kcnt = 0
while kcnt < icollen do
    kArr[kcnt][kndx] = knum
    kcnt += 1
od
xout kArr
endop
;set column to 1d array
opcode SetCol, k[], k[]k[]k
kArr[], kv[], kndx xin
irowlen = lenarray(getcol(kArr,0))
kcnt = 0
while kcnt < irowlen do
    kArr[kcnt][kndx] = kv[kcnt]
    kcnt += 1
od
xout kArr
endop

instr Arr7 ;no segmentation faults here
karr[][]    init 4, 8
;krow[]      init 8
kv          init 1
kv += 1
krow[] = fillarray(1,1,1,kv,1,1,1,1)
karr = SetRow(karr, krow, 2)
kcol[] = fillarray(6,9,6,9)
karr = SetCol(karr, kcol, 7)
printarray(karr)
endin
schedule("Arr7", 0, .1)

</CsInstruments>
</CsoundSynthesizer>
