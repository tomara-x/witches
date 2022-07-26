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
ksmps = 441

instr 1
kfrq = 4
karr[]=fillarray(2,1)
ks init 0

;here they're probimatic
;kt1 = metro(kfrq)
;kt2 = metro(kfrq*karr[ks])

;switch frequency of kt2
kt3 = metro(kfrq/4)
if kt3 == 1 then
    ks = (ks+1)%2
endif

;here they're less so?
kt1 = metro(kfrq)
kt2 = metro(kfrq*karr[ks])

if kt1 + kt2 == 1 then ;only one trigger is high
    if kt1 == 1 then
        printks("#one at: %f\n", 0, timeinsts())
    else
        printks("#two at: %f\n", 0, timeinsts())
    endif
elseif kt1 + kt2 == 2 then ;both high
    printks("both at: %f\n", 0, timeinsts())
endif
endin
schedule(1, 0, 120)



/*
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
;schedule(2, 0, 120)
*/



</CsInstruments>
</CsoundSynthesizer>


