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
#define TEMPO #115#
#define S #(60/$TEMPO)*# ; $S 4 = duration of 4 beats in seconds
;have a bad feeling about this

instr Score
ip2, ip3 = 0, .5
ic1 = 0
iarr[] = fillarray(7.02, 7.02, 7, 7.04)
while ic1 < 4*8 do
    schedule "Bass", $S ip2, $S ip3, -12, iarr[ic1%4], .4, .7, .9
    if ic1%3 == 0 then
        iarr[2] = iarr[2] + 0.01 ;the witch
    endif
    ip2 += ip3
    ic1 += 1
od
ic2 = 0
while ic2 < 4*2 do
    schedule "Kick", $S ic2*2, .8, .04, 230, 20
    ic2 += 1
od

event_i "e", 0, ip2+ip3
endin
schedule("Score", 0, -1)

;droning instrument with changing parameters in time
instr S2
ic = 0
iarr[] = fillarray(7.02, 9.02, 7, 7.04)
while ic < 16 do
    if ic == 0 then
        schedule "Hsboscil", ic, 1, cpspch(iarr[ic%4]), 0
    else
        schedule "Hsboscil", ic, 1, cpspch(iarr[ic%4]), 0, 1
    endif
    ic += 1
od
endin
;schedule("S2", 0, -1)

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
aAEnv   expseg 1,p3,ampdb(-128)
aFEnv   expseg iIFrq,p4,iEFrq
aSig    oscili aAEnv, aFEnv
;aSig    += moogladder(aSig, aFEnv*16, 0.8)
aSig    += diode_ladder(aSig, k(aFEnv)*8, 16, 1, 20)
;aSig    += pdhalf(aSig, -.99)*ampdb(-32)
;aSig    diode_ladder aSig, 2000, 1
;aSig    limit aSig, -0.5, 0.5
aEnv    linseg      1, p3*.9, 1, p3*.1, 0
aSig *= aEnv
aSig *= ampdb(-3)
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
;skip init
if p6 == 1 then
    igoto end
endif
kAmp = .5
kTone rspline -1,1,4,7
;kBrite rspline -3,3,4,8
kBrite rspline -1,1,1,2
iBasFreq = 220
;switch between sin and wav based on p5
kcps = p4
kcps tonek kcps, 10 ;¡muy interesante!
if p5 == 0 then
    aSig hsboscil kAmp, kcps, kBrite, iBasFreq, iSin, iWindow, 3
elseif p5 == 1 then
    aSig hsboscil kAmp, kcps, kBrite, iBasFreq/100, iWav, iWindow, 3
elseif p5 == 2 then
    aSig = hsboscil(kAmp, kcps, kBrite, iBasFreq, iSin, iWindow, 3) +
           hsboscil(kAmp, kcps, kBrite, 228, iSin, iWindow, 3)
endif
outs aSig, aSig
end:
endin

instr WG
;play with wguide2 and rspline
endin

</CsInstruments>
</CsoundSynthesizer>

