//trans rights 🏳️‍⚧️
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//cleaned up version of jam-29.csd
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m97
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #110#
#include "../sequencers.orc"
#include "../mixer.orc"

instr Kick
;p4-p7: amp decay, freq decay, freq[i], freq[f]
iIFrq   = p6
iEFrq   = p7
aAEnv   expseg 1,p4,0.0001
aFEnv   expseg iIFrq,p5,iEFrq
aSig    oscili aAEnv, aFEnv
gaKickOut = aSig
endin

instr Hsboscil ;originally stolen from floss example 04A13_hsboscil.csd
iSin    ftgenonce 0, 0, 2^10, 10, 1
iWindow ftgenonce 0, 0, 2^10, -19, 1, 0.5, 270, 0.5
iWav    ftgenonce 0, 0, 2^18, 9, 100,1.000,0, 278,0.500,0, 518,0.250,0,
        816,0.125,0, 1166,0.062,0, 1564,0.031,0, 1910,0.016,0
kAmp = 0.5
kTone rspline -1,1,4,7 ;try using pitch info instead
kBrite rspline -3,3,4,8
iBasFreq = p4
;switch between sin and wav based on p5
if p5 == 0 then
    aSig1 hsboscil kAmp, kTone, kBrite, iBasFreq, iSin, iWindow
else
    aSig1 hsboscil kAmp, kTone, kBrite, iBasFreq/100, iWav, iWindow
endif
aEnv linseg 1, p3, 0
gaHsboscilOut = (aSig1)*aEnv
endin

instr Verb ;stolen from the floss manual 05E01_freeverb.csd
gaVerbIn    init 0
kRoomSize   init      0.55     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
gaVerbOutL,gaVerbOutR freeverb gaVerbIn,gaVerbIn,kRoomSize,kHFDamp
endin

instr Main
;the sacred timeline
kBarN       init 0
kBar        metro $TEMPO/4/60 ;click every 4th beat
kBarN += kBar
kCount[]    fillarray 2, 2, 2, 2, 8, 4, 2, 2, 8, 1, 8, 8, 1, 4, 2, 1
kGain[]     fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kQueue[]    fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kV, kTL[]   tBasemath kBar, kCount, kGain, 1, 17, kQueue
kQueue[kV] = 0
;hsboscil------------------------------
if kV == 0 then
    kFrq = $TEMPO/8/60
    kWav = 1
    kDist = -1
elseif kV == 7 then
    kFrq = $TEMPO*4/60
    kWav = 1
    kDist = -0.00
elseif kV > 7 then
    kFrq = $TEMPO*2/60
    kWav = 0
    kDist = -0.99
else
    kFrq = $TEMPO*2/60
    kWav = 0
    kDist = -0.69
endif
if kV == 12 then
    kFrq = $TEMPO*2/60
    kWav = 1
    kDist = -0.69
endif
kTrig2  metro kFrq
iTS2    ftgenonce 0,0,-5,-51, 5,2,cpspch(6),0,
2^(0/12),2^(3/12),2^(17/12),2^(7/12),2^(34/12)
kTN2[]  fillarray 3, 3, 4, 2, 6, 6, 8, 0
kTG2[]  fillarray 0, 0, 2, -1, 0, 1, 1, 1
kTQ2[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0
kTAS2, kTP2[], kTT2[] Taphath kTrig2,kTN2,kTG2,kTQ2, iTS2, 0, 0, 2
schedkwhen(kTrig2,0,0, "Hsboscil",0, 1/kFrq, kTP2[kTAS2], kWav)
gaHsboscilOut moogladder gaHsboscilOut, kTP2[kTAS2]*16, .8
gaHsboscilOut pdhalf gaHsboscilOut, kDist
sbus_write 0, limit(gaHsboscilOut,-0.1,0.1)
sbus_mult  0, ampdb(-6)
if kV == 9 then
    clear gaHsboscilOut
    sbus_mult 0, 0
endif
;kick------------------------------
kTrig3  metro $TEMPO/60
if kV == 3 || kV == 9 then
    schedkwhen(kTrig3, 0,0, "Kick", 0, 4, 0.8, 0.08, 830, 40)
elseif kV >= 4 && kV < 7 then
    schedkwhen(kTrig3, 0,0, "Kick", 0, 4, 0.5, 0.08, 230, 40)
elseif kV > 7 then
    schedkwhen(kTrig3, 0,0, "Kick", 0, 4, 0.7, 0.09, 230, 40)
    gaKickOut pdhalf gaKickOut, -0.8
endif
sbus_write 1, gaKickOut
sbus_mult  1, ampdb(-18)
if kV == 9 then
    sbus_mult 1, 0
endif
;verb------------------------------
schedule("Verb",0,-1)
gaVerbIn = gaKickOut*ampdb(-32)+gaHsboscilOut*ampdb(-64)
sbus_write 15, gaVerbOutL, gaVerbOutR
;out------------------------------
aL, aR sbus_out
iSM = 1
aL limit aL, -iSM, iSM
aR limit aR, -iSM, iSM
kFade linseg 1, p3-10, 1, 10, 0
outs aL*kFade, aR*kFade
endin
</CsInstruments>
<CsScore>
i"Main" 0 [228*(60/110)]
e
</CsScore>
</CsoundSynthesizer>

