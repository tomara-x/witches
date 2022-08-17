//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231 ;-m227
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   32
nchnls  =   2
0dbfs   =   1

#define TEMPO #60#
#define FRQ   #($TEMPO/60)#
#define BEAT  #(60/$TEMPO)# ;1/$FRQ

gaVerbL,gaVerbR init 0

#include "utils.orc"
#include "mixer.orc"
#include "drums.orc"


;somewhere on the kick/gun spectrum
;schedkwhen(kT,0,0, "Kick",  0,    .5, 230, 20, .3, 1, .1)

;metamorphic mages
;schedkwhen(kT,0,0, "Kick",  0,    .5, 130, 20, .3, .994, .7)
;schedkwhen(kT,0,0, "Kick",  0,    .5, 100, 20, .3, 1, .7)

;plucky
;schedkwhen(kT,0,0, "Kick",  0,    .9, 80, 80, .01, 1, .1)

;schedkwhen(kT,0,0, "Kick",  0,    .5, 230, 20, .1, 0, .1)
;schedkwhen(kT,0,0, "HatO2", 0.5,   .9, .1, -0.9, 8323, 9783, 0.0)
;schedkwhen(kT,0,0, "HatC2", 0.75,  .1, .1, -0.9, 8323, 9783, 0.0)
;schedkwhen(kT,0,0, "HatC2", 0.25,-.1, .1, -0.9, 9000, 8000, 0.5)

instr Drums
kT = MyMetro($FRQ/2)
kfrq linseg 230, 4,130,  4,230
kdst linseg .1, 8,1
kvrb linseg .1,  4,.7,   4,.1
schedkwhen(kT,0,0, "Kick",  0,    .7, kfrq, 20, .3, kdst, kvrb)
;schedkwhen(kT,0,0, "HatC2", 0,   -.1, .02,  0.9, 9000, 1000, 0.5)
;schedkwhen(kT,0,0, "HatC2", 0.5,  .1, .1, -0.9, 9000, 1000, 0.5)
endin



instr Verb
gaVerbL dcblock gaVerbL
gaVerbR dcblock gaVerbR
kRoomSize  init  0.65 ; room size (range 0 to 1)
kHFDamp    init  0.8  ; high freq. damping (range 0 to 1)
al,ar freeverb gaVerbL,gaVerbR,kRoomSize,kHFDamp, 44100, 1
sbus_mix 0, al, ar
;outs al, ar
clear gaVerbL,gaVerbR
endin
schedule("Verb", 0, -1)



instr Out
aL, aR sbus_out
aL clip aL, 0, db(-6)
aR clip aR, 0, db(-6)
outs aL, aR
sbus_clear_all
endin
schedule("Out", 0, -1)


</CsInstruments>
<CsScore>
i"Drums"    0   30
e
</CsScore>
</CsoundSynthesizer>

