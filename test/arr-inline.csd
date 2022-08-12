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

instr 1
printarray(fillarray:i(1,2,3,7))
;this is a return type (not rate) modifier for polymorphic opcodes
;so actually it's trying to return an i rate scalar when given :i
;what would be more accurate is fillarray:i[] but that's not a thing (for now at least)
;the error message is so very ambiguous tho:
;"opcode 'fillarray' for expression with arg types cccc not found"
;lol! it ain't inputs you gotta worry about, silly!
endin
schedule(1, 0, 0)

</CsInstruments>
</CsoundSynthesizer>


