//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

opcode ClkDiv, k, kk
/*
Clock divider. Outputs 1 on the nth time the in-signal is non-zero.
This opcode is quite handy with the ladies!
Syntax: kout ClkDiv ksig, kn
*/
ksig, kn xin
kcount init 0
kout = 0
if ksig != 0 then
    kcount += 1
endif
if kcount >= abs(kn) then
    kout = 1
    kcount = 0
endif
xout kout
endop

// this can be improved. also steven has audio-rate clock dividers
opcode ClkDivp, k, kko
/*
Clock divider with phase input.
Syntax: kout ClkDiv ksig, kn [, iphase] (0 <= iphase < kn)
*/
ksig, kn, iphs xin
kcount init iphs
kout = 0
if ksig != 0 then
    kcount += 1
endif
if kcount >= abs(kn) then
    kout = 1
    kcount = 0
endif
xout kout
endop


;array operations (those work at k-time)
;set row to scalar
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
kcnt = 0
while kcnt < irowlen do
    kArr[kndx][kcnt] = kv[kcnt]
    kcnt += 1
od
xout kArr
endop
;set column to scalar
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
;set 2d array to scalar
opcode ScalarSet, k[], k[]k
kArr[], kn xin
icols = lenarray(getrow(kArr,0))
irows = lenarray(getcol(kArr,0))
krow = 0
while krow < irows do
    kcol = 0
    while kcol < icols do
        kArr[krow][kcol] = kn
        kcol += 1
    od
    krow += 1
od
xout kArr
endop


