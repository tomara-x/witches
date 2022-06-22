//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

gay, gal, gar init 0

gaVerbL,gaVerbR init 0
instr Verb
kRoomSize  init  0.99 ; room size (range 0 to 1)
kHFDamp    init  0.9  ; high freq. damping (range 0 to 1)
denorm gaVerbL, gaVerbR
aVerbL,aVerbR freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp
gal += aVerbL
gar += aVerbR
clear gaVerbL,gaVerbR
endin

instr Rawr
if pcount() == 10 then
    aSig bamboo p4, p3, p5, p6, p7, p8, p9, p10
else
    aSig bamboo p4, p3, p5, p6, p7
endif
aSig limit aSig, -.5, .5
gay += aSig*db(-6)
gaVerbL += aSig*db(-24)
gaVerbR += aSig*db(-24)
endin

instr Out
kSM = 1
gal limit gal+gay, -kSM, kSM
gar limit gar+gay, -kSM, kSM
outs gal, gar
clear gay, gal, gar
endin
</CsInstruments>
<CsScore>
i"Out"  0 -1
;i"Verb" 0 -1

;energy back (0-1) ----+
;damp (0-.05) -----+   |
;number -------+   |   |
;              v   v   v  frq1 frq2 frq3
i"Rawr" + 4 .1 20 .05 .00 1407 1048 7090
s
i"Rawr" + 4 .1 80 .01 .01 1407 148  790
i"Rawr" + 4 .1 5  .01 .00 40   168  790
i"Rawr" + 4 .1 50 .01 .00 407  268  790
i"Rawr" + 4 .1 50 .01 .00 1407 268  790
e
</CsScore>
</CsoundSynthesizer>


