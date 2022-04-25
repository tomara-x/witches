//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//divisions
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #80#
#define B #(60/$TEMPO)#

instr Score
schedule "s1", $B*00*4, -1, 1, 4
schedule "s1", $B*01*4, -1, 2, 4
schedule "s1", $B*02*4, -1, 3, 4
schedule "s1", $B*03*4, -1, 4, 4
schedule "s1", $B*04*4, -1, 5, 4
schedule "s1", $B*05*4, -1, 6, 4
schedule "s1", $B*06*4, -1, 7, 4
schedule "s1", $B*07*4, -1, 8, 4
schedule "s1", $B*08*4, -1, 9, 4

schedule "s2", $B*09*4, -1, 8, 4
schedule "s2", $B*10*4, -1, 7, 4
schedule "s2", $B*11*4, -1, 6, 4
schedule "s2", $B*12*4, -1, 5, 4
schedule "s2", $B*13*4, -1, 4, 4
schedule "s2", $B*14*4, -1, 3, 4
schedule "s2", $B*15*4, -1, 2, 4
schedule "s2", $B*16*4, -1, 1, 4
endin
schedule("Score", 0, -1)

instr s1
idur = $B/p4
ipch[] = fillarray(6.02, 6.02, 6, 6.06, 6.02, 6, 6.04, 6.04, 6.07)
iplk[] = fillarray(.2, .3, .7, .2, .7, .3, .05, .9, .1)
icnt = 0
while icnt < p4 do
    schedule "Bass", icnt*idur, idur, -3, ipch[icnt], iplk[icnt], .9, .9
    icnt += 1
od
if p5 > 1 then
    schedule "s1", $B, -1, p4, p5-1
endif
turnoff
endin
instr s2
idur = $B/p4
ipch[] = fillarray(6.07, 6.04, 6.04, 6, 6.02, 6.06, 6, 6.02, 6.02)
iplk[] = fillarray(.1, .9, .05, .3, .7, .2, .7, .3, .2)
icnt = 0
while icnt < p4 do
    schedule "Bass", icnt*idur, idur, -3, ipch[icnt], iplk[icnt], .9, .9
    icnt += 1
od
if p5 > 1 then
    schedule "s2", $B, -1, p4, p5-1
endif
turnoff
endin

instr Bass
iPlk    =           p6 ;(0 to 1)
kAmp    =           ampdb(p4)
iCps    =           cpspch(p5)
kPick   =           p7 ;pickup point
kRefl   =           p8 ;rate of decay ]0,1[
aSig    wgpluck2    iPlk,kAmp,iCps,kPick,kRefl
aEnv    linseg      0, p3*.005, 1, p3*.895, 1, p3*.1, 0
aSig *= aEnv
aSig    diode_ladder aSig, cpspch(p4+2), 1, 1, 10
outs aSig, aSig
endin
</CsInstruments>
</CsoundSynthesizer>

