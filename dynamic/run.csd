//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//recompile a csd file and rerun its main instr every n seconds.
//allowing me to edit files and hear the reaults as the file is saved

//very messy, it's like hitting a reset (so that's kinda bad) but can be useful
//especially with the Q of basma
//or might figure out a way to trigger it manually so it'd be like a refresh button
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 42
nchnls = 2
0dbfs = 1

instr Main
endin

instr 1
ktrig metro 1/2
if ktrig == 1 then
    reinit compile
    turnoff2(nstrnum("Main"), 0, 0)
    schedulek("Main", 0, -1)
endif
compile:
ires compilecsd "tbase.csd"
endin

</CsInstruments>
<CsScore>
i 1 0 120
e
</CsScore>
</CsoundSynthesizer>
