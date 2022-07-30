//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.



;arbitrary number of clocks running at multiples of frequency
;and divided versions of them

;Syntax:
;kOutMul[], kOutDiv[] Perfuma kFrq, kMul[], kDiv[]

;kOutMul[]: multiplied clocks output
;kOutDiv[]: divided clocks output
;kFrq: main frequency
;kMul[]: clock multipliers
;kDiv[]: divider (counter) for each clock

;don't change array length past initialization

opcode Perfuma, k[]k[], kk[]k[]
kFrq, kMul[], kDiv[] xin

iLen = min(lenarray(kMul), lenarray(kDiv))

kOutMul[] init iLen
kOutDiv[] init iLen

kOutMul = 0
kOutDiv = 0

;multiplied clocks' counters count up to kr
kMCnt[] init iLen
ii = 0
while ii < iLen do
    kMCnt[ii] init kr
    ii += 1
od

ki = 0
while ki < iLen do
    kMCnt[ki] = kMCnt[ki] + kMul[ki]*kFrq
    if kMCnt[ki] >= kr then
        kOutMul[ki] = 1
        kMCnt[ki] = kMCnt[ki] - kr
    endif
    ki += 1
od

;divided frequency of the multiplied clocks (by counting)
kDCnt[] init iLen
ki = 0
while ki < iLen do
    if kOutMul[ki] == 1 then
        kDCnt[ki] = kDCnt[ki] - 1
    endif
    if kDCnt[ki] <= 0 then
        kOutDiv[ki] = 1
        kDCnt[ki] = kDiv[ki]
    endif
    ki += 1
od
xout kOutMul, kOutDiv
endop


;kOutMul[], kOutDiv1[], kOutDiv2[] Perfuma kFrq, kMul[], kDiv1[], kDiv2[] ?
;kM1[], kM2[], kD1[], kD2[] Perfuma kFrq, km1[], km2[], kd1[], kd2[] ?


