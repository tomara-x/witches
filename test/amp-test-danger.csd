//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

// DO NOT RUN THIS! YOU CAN FUCK UP YOUR EARS AND YOUR EQUIPMENT!
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
0dbfs  = 1
instr Main
;out oscil(db(100), 440)
endin
schedule("Main", 0, 10)
</CsInstruments>
</CsoundSynthesizer>
