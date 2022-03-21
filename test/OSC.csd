//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//testing using the app "Sensors2OSC" on android phone to send sensor
//data received here to be used as modulation sources
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

gicharles OSCinit 9000

instr Main
kmessage, kdata[] OSClisten gicharles, "/accelerometer", "fff"
printks "x=%f, y=%f, z=%f\n", 0.1, kdata[0], kdata[1], kdata[2]
endin
schedule("Main", 0, 60)

</CsInstruments>
</CsoundSynthesizer>


