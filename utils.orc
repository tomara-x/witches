//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
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


;array operations
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


