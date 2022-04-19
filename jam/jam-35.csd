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
#include "../oscillators.orc"

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

instr FM10
kAmp[] init 16
kCps[] init 16
kRat[] init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp08+aOp09+aOp13
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp00
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp03
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp01+aOp04+aOp05
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp00
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp00
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp03
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp03
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp12
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp12
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp15
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp15
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp10+aOp11+aOp14
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp12
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp15
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
aSig    = (aOp02+aOp06+aOp07)
outs aSig, aSig
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
<CsScore>
t 0 115
i"Bass" 0 4 -12 7.02 0.4 0.7 .4
s
r 4
t 0 115
i"Bass" 0 0.5 -12 7.02 0.4 0.7 .9
i"Bass" +
i"Bass" + .   .   7.00
i"Bass" + .   .   7.04
s
t 0 115
i"Bass" 0 .5 -12 7.02 0.4 0.7 .4
i"Bass" + 4 -12 7.02 0.4 0.7 .4
e
</CsScore>
</CsoundSynthesizer>

