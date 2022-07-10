//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;switching the overload order fixes the ambiguous call
;thank you, ThinkError
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

opcode test, 0, ii
iin1, iin2 xin
print iin1, iin2
endop

opcode test, 0, i
iin xin
print iin
endop

test 42
test 0, 42

</CsInstruments>
</CsoundSynthesizer>


