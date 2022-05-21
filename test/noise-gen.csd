//trans rights
//Copyright © 2021 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#include "../mixer.orc"

instr Nois
aSig noise 0.1, 0
kMod randomi 1, 8, 1
kFrq randomi 200, 1200, 1/kMod
kRes randomi 1, 5, 1/kMod
aSig bqrez aSig, kFrq, kRes
gaNoisSig = aSig
endin

instr Verb2 ;bigger reverb
gaVerb2In   init    0
kRoomSize   init    1       ; room size (range 0 to 1)
kHFDamp     init    0.9     ; high freq. damping (range 0 to 1)
gaVerb2OutL,gaVerb2OutR freeverb gaVerb2In,gaVerb2In,kRoomSize,kHFDamp
endin

instr Main
schedule("Nois",0,p3)
schedule("Verb2",0,p3)
gaVerb2In = gaNoisSig*ampdb(-12)
sbus_write 0, gaNoisSig
sbus_write 1, gaVerb2OutL, gaVerb2OutR
aL, aR sbus_out
outs aL,aR
endin
</CsInstruments>
<CsScore>
i"Main" 0 [60*10]
e
</CsScore>
</CsoundSynthesizer>


