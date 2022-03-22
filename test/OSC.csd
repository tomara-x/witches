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
ksmps   =   42
nchnls  =   1
0dbfs   =   1

gicharles OSCinit 9000

instr Main
kmessage, kdata[] OSClisten gicharles, "/accelerometer", "fff"
;kmessage, kdata[] OSClisten gicharles, "/magneticfield", "fff"
;kmessage, kdata[] OSClisten gicharles, "/orientation", "fff"
aSig1 = oscili(0.01*tonek(kdata[0], 10), 105)
aSig2 = oscili(0.01*tonek(kdata[1], 10), 138)
aSig3 = oscili(0.01*tonek(kdata[2], 10), 420)
;printks "x=%f, y=%f, z=%f\n", 0.2, kdata[0], kdata[1], kdata[2]
out aSig1+aSig2+aSig3
endin
schedule("Main", 0, 60)

</CsInstruments>
</CsoundSynthesizer>


