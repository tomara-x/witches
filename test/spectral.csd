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

#define TEMPO #113#
#define FRQ #($TEMPO/60)#
#define BEAT #(1/$FRQ)#

#include "../sequencers.orc"
#include "../utils.orc"

gay, gal, gar init 0

gifftsize = 1024
gioverlap = gifftsize/4
giwinsize = gifftsize
giwinshape = 1 ;von-Hann window

; wasn't there somethin about how you don't have the same f-sig be both the in and
;the out of an opcode call?
instr Spect
pvsinit
fftin   pvsanal ain, gifftsize, gioverlap, giwinsize, giwinshape
fftscal pvscale fftin, 1/2
aSig    pvsynth fftscal
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
i"Out"  0 10
e
</CsScore>
</CsoundSynthesizer>


