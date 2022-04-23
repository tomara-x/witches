//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//shhh
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #90#
#define B #(60/$TEMPO)#

instr Score
schedule "s1", $B*0,  -1, 3*4
schedule "s2", $B*3,  -1, 3
schedule "s3", $B*12, -1, 3*4*2
schedule "s4", $B*36, -1, 3*4*2
schedule "Bass", $B*60, 1, -12, 6.00, .99, .9, .95
schedule "Bass", $B*60.3, .6, -12, 6.03, .99, .9, .95
schedule "Bass", $B*60.6, .3, -12, 6.07, .99, .9, .95
schedule "s3", $B*61, -1, 3*4*2
endin
schedule("Score", 0, -1)

instr s1
idur = $B/3
schedule "Bass", 0*idur, idur, -12, 6.02, .2, .9, .9
schedule "Bass", 1*idur, idur, -12, 6.02, .7, .9, .9
schedule "Bass", 2*idur, idur, -12, 6.00, .3, .9, .9
if p4 > 1 then
    schedule "s1", 3*idur, -1, p4-1
endif
turnoff
endin
instr s3
idur = $B/6
schedule "Bass", 0*idur, idur, -12, 6.02, .2, .9, .9
schedule "Bass", 1*idur, idur, -12, 6.02, .7, .9, .9
schedule "Bass", 2*idur, idur, -12, 6.00, .3, .9, .9
schedule "Bass", 3*idur, idur, -12, 6.02, .2, .9, .9
schedule "Bass", 4*idur, idur, -12, 6.02, .7, .9, .9
schedule "Bass", 5*idur, idur, -12, 6.00, .3, .9, .9
if p4 > 1 then
    schedule "s3", 6*idur, -1, p4-1
endif
turnoff
endin
instr s4
idur = $B/6
schedule "Bass", 0*idur, idur, -12, 6.02, .2, .9, .9
schedule "Bass", 1*idur, idur, -12, 6.02, .7, .9, .9
schedule "Bass", 2*idur, idur, -12, 6.00, .3, .9, .9
schedule "Bass", 3*idur, idur, -12, 6.00, .2, .9, .9
schedule "Bass", 4*idur, idur, -12, 6.04, .7, .9, .9
schedule "Bass", 5*idur, idur, -12, 6.04, .3, .9, .9
if p4 > 1 then
    schedule "s4", 6*idur, -1, p4-1
endif
turnoff
endin
instr s2
schedule "Kick", $B*0, .8, -12, .04, 230, 20
if p4 > 1 then
    schedule "s2", $B*3, -1, p4-1
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
aEnv    linseg      0, p3*.001, 1, p3*.899, 1, p3*.1, 0
aSig *= aEnv
;aSig    diode_ladder aSig, cpspch(p4+4), 14, 1, 50
outs aSig, aSig
endin

instr Kick
;p4-p7: amp, freq decay, freq[i], freq[f]
iIFrq   = p6
iEFrq   = p7
aAEnv   expseg 1,p3,ampdb(-128)
aFEnv   expseg iIFrq,p5,iEFrq
aSig    oscili aAEnv, aFEnv
;aSig    += moogladder(aSig, aFEnv*16, 0.8)
aSig    += diode_ladder(aSig, k(aFEnv)*8, 16, 1, 20)
;aSig    += pdhalf(aSig, -.99)*ampdb(-32)
;aSig    diode_ladder aSig, 2000, 1
;aSig    limit aSig, -0.5, 0.5
aEnv    linseg      1, p3*.9, 1, p3*.1, 0
aSig *= aEnv
aSig *= ampdb(p4)
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

