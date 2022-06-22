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

;amy please comment stuff! please!
;i think it's just a getrow (which is a 1d array) to which we add 2
;(incrementing all elements) then we write the result back into the 2d array (setrow)
instr Arr1
kArr[][] init 4, 8
kArr = setrow(getrow(kArr, 0) + 2, 0)
printarray(kArr)
endin
schedule("Arr1", 0, 0.01)

</CsInstruments>
</CsoundSynthesizer>


