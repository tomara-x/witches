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
sr = 48000 ;same behaviour on 48000 and 44100
ksmps = 480 ;same even at ksmps = 1

instr 1
;in sync
;kt1 = metro(.5)
;kt2 = metro(1)

;outa sync after first cycle
kt1 = metro(4)
kt2 = metro(8)

if kt1+kt2 == 2 then
    printks("in sync at: %f\n", 0, timeinsts())
elseif kt1 == 1 then ;second trig is usually one cycle off
    printks("out of sync at: %f\n", 0, timeinsts())
endif
endin
;schedule(1, 0, 120)



instr 2
;in sync
kt1 = metro(.5)
kt2 = metro(1)

;outa sync after first cycle
;kt1 = metro(4)
;kt2 = metro(8)

if kt1+kt2 == 2 then
    printks("both at: %f\n", 0, timeinsts())
else
    if kt1 == 1 then
        printks("#one at: %f\n", 0, timeinsts())
    endif
    if kt2 == 1 then
        printks("#two at: %f\n", 0, timeinsts())
    endif
endif
endin
schedule(2, 0, 120)



//messy example
instr 3
kfrq = 4 ;bad but 0.5 works
karr[]=fillarray(2,1)

;switch frequency of kt2
ks init 0
kt3 = metro(kfrq/4)
if kt3 == 1 then
    ks = (ks+1)%2
endif

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
;schedule(3, 0, 120)



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


