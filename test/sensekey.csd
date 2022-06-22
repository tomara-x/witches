//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//not work! why?
//this is actually a mess on pc as well, i don't know if it has something
//to do with the command line frontend or what. it needs testing
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

instr Main
kVal init 0
kKey, kDwn sensekey ;type z (optional out)
if kKey == strchar("+") && kDwn == 1 then
    kVal += 1
endif
printk2 kVal
endin
schedule("Main", 0, 60)

</CsInstruments>
</CsoundSynthesizer>


