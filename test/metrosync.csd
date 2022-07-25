//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//testing the sync of varying frequency metros
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
ksmps   =   441

instr 1
karr1[]=fillarray(1,2)
karr2[]=fillarray(2,1)
ks init 0

kt2 = metro(karr1[ks])
kt3 = metro(karr2[ks])
if kt2 != 0 && kt3 != 0 then
    printk(0, 1)
    ks += 1
    ks = ks % 2
endif
endin
;schedule(1, 0, 120)

instr 2
kfrq = 113/60
karr1[]=fillarray(1,2)
karr2[]=fillarray(2,1)
ks init 0

kt2 = metro(kfrq*karr1[ks])
kt3 = metro(kfrq*karr2[ks])
if kt2 != 0 && kt3 != 0 then
    printk(0, 1)
    ks += 1
    ks = ks % 2
endif
endin
schedule(2, 0, 120)

</CsInstruments>
</CsoundSynthesizer>


