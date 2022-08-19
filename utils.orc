//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


;clock divider. outputs 1 on the nth time the in-signal is non-zero
;this opcode is quite handy with the ladies!
;syntax: kout ClkDiv ksig, kn
opcode ClkDiv, k, kk
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

;clock divider with phase input (counter offset)
;syntax: kout ClkDivp ksig, kn [, iphase] (0 <= iphase < kn)
opcode ClkDivp, k, kko
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


;clock divider but for audio-rate waves
;outputs 1 every Nth time aIN is < kLo and goes higher than kHi
;(out is unipolar)
;syntax: aOut SubOct aIn, kN, kHi, kLo
opcode SubOct, a, akkk
aIn, kN, kHi, kLo xin
kGate,kLast init 0
aOut init 0
kCnt init 0
kn = 0
while kn < ksmps do
    ;threshold gate
    if aIn[kn] > kHi then
        kGate = 1
    elseif aIn[kn] < kLo then
        kGate = 0
    endif
    ;sense change and increment counter
    if kLast == 0 && kGate == 1 then
        kLast = 1
        kCnt = (kCnt + 1) % kN
    elseif kLast == 1 && kGate == 0 then
        kLast = 0
    endif
    ;output Nth wave
    if kCnt == 0 then
        aOut[kn] = kGate
    endif
    kn += 1
od
xout aOut
endop
;thanks for the inspiration girl <3



;FIX: use lenarray with dimension option. and maybe i-pass versions
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
;i-pass one?



;array shift register right
;shifts all elements to the right and insert input at index 0 when triggered
;syntax: kRes[] ShftR kTrig, kInput, kArr[]
opcode ShiftR, k[], kkk[]
kTrig, kIn, kArr[] xin
iLen = lenarray(kArr)
if kTrig != 0 then
    kndx = iLen-1
    while kndx > 0 do
        kArr[kndx] = kArr[kndx-1]
        kndx -= 1
    od
    kArr[0] = kIn
endif
xout kArr
endop
;array shift register left
;shifts all elements to the left and insert input at last index when triggered
;syntax: kRes[] ShftL kTrig, kInput, kArr[]
opcode ShiftL, k[], kkk[]
kTrig, kIn, kArr[] xin
iLen = lenarray(kArr)
if kTrig != 0 then
    kndx = 0
    while kndx < iLen-1 do
        kArr[kndx] = kArr[kndx+1]
        kndx += 1
    od
    kArr[iLen-1] = kIn
endif
xout kArr
endop



;metro that avoids division. it increments by cps
;every k-cycle and checks if counter is higher than kr
opcode MyMetro, k, k
kcps xin
kcnt init kr
kflag = 0
kcnt += kcps
if kcnt >= kr then
    kflag = 1
    kcnt -= kr
endif
xout kflag
endop


