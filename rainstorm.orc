//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;reads an array of indexes from a function table
;and returns the values in an output array (in k-time)

;Syntax:
;kValue[] Rainstorm kIndex[], kFn

;kValue[]: values stored at indexes in the kFn
;kIndex[]: indexes to read from the kFn
;kFn: function table of values

opcode Rainstorm, k[], k[]k
kIndex[], kFn xin
iLen = lenarray(kIndex)
kValue[] init iLen
kn = 0
while kn < iLen do
    kValue[kn] = tablekt(kIndex[kn], kFn)
    kn += 1
od
xout kValue
endop

;error-checking?

