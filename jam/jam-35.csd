//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//score tests
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

;#include "../sequencers.orc"
;#include "../oscillators.orc"

instr Score
Sp1 = "Bass"
ip2, ip3 = 0, .5
ic = 0
while ic < 16 do
    ;event_i "i", Sp1, ip2, ip3, -12, 7.02, 0.4, 0.7, .9
    Sline sprintf "i\"%s\" %f %f -12 7.02 .4 .7 .9", Sp1,ip2,ip3
    scoreline_i Sline
    ip2 += ip3
    ic += 1
od
;p3 = ip2 + ip3 ;extend duration of this instr
event_i "e", 0, ip2+ip3
endin
schedule("Score", 0, -1)

instr Bass
iPlk    =           p6 ;(0 to 1)
kAmp    =           ampdb(p4)
iCps    =           cpspch(p5)
kPick   =           p7 ;pickup point
kRefl   =           p8 ;rate of decay ]0,1[
aSig    wgpluck2    iPlk,kAmp,iCps,kPick,kRefl
aEnv    linseg      1, p3*.9, 1, p3*.1, 0
aSig *= aEnv
;aSig    diode_ladder aSig, cpspch(p4+4), 14, 1, 50
outs aSig, aSig
endin

instr Kick
;p4-p6: freq decay, freq[i], freq[f]
iIFrq   = p5
iEFrq   = p6
aAEnv   expseg 1,p3,ampdb(-280)
aFEnv   expseg iIFrq,p4,iEFrq
aSig    oscili aAEnv, aFEnv
;aSig    += moogladder(aSig, aFEnv*16, 0.8)
aSig    += diode_ladder(aSig, iIFrq, 16, 1, 20)
aSig    += pdhalf(aSig, -.9)*ampdb(-3)
;gSig    diode_ladder aSig, 2000, 0
aSig    limit aSig, -0.5, 0.5
outs aSig, aSig
endin

gaVerbSnd   init 0
instr Verb ;stolen from the floss manual 05E01_freeverb.csd
kRoomSize   init      0.55     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
aL,aR freeverb gaVerbSnd,gaVerbSnd,kRoomSize,kHFDamp
outs aL, aR
clear gaVerbSnd
endin

instr Hsboscil ;originally stolen from floss example 04A13_hsboscil.csd
iWindow ftgenonce 0, 0, 2^10, -19, 1, 0.5, 270, 0.5
iSin    ftgenonce 0, 0, 2^10, 10, 1
iWav    ftgenonce 0, 0, 2^18, 9, 100,1.000,0, 278,0.500,0, 518,0.250,0,
        816,0.125,0, 1166,0.062,0, 1564,0.031,0, 1910,0.016,0
kAmp = .5
kTone rspline -1,1,4,7
;kBrite rspline -3,3,4,8
kBrite rspline -1,1,1,2
iBasFreq = 220
;switch between sin and wav based on p5
if p5 == 0 then
    aSig hsboscil kAmp, p4, kBrite, iBasFreq, iSin, iWindow, 6
elseif p5 == 1 then
    aSig hsboscil kAmp, p4, kBrite, iBasFreq/100, iWav, iWindow, 3
elseif p5 == 2 then
    aSig = hsboscil(kAmp, p4, kBrite, iBasFreq, iSin, iWindow, 3) +
           hsboscil(kAmp, p4, kBrite, 228, iSin, iWindow, 3)
endif
outs aSig, aSig
endin

instr WG
;play with wguide2 and rspline
endin

</CsInstruments>
</CsoundSynthesizer>

