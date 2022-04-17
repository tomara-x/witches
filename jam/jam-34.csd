//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//i miss the score!
//hold on! i'll see blue, then i'll come back to this
//↑ lol! did not know what i was getting into!
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m227 ;-m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#include "../sequencers.orc"
#include "../oscillators.orc"
#include "../utils.orc"

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
gaFM10Out += (aOp02+aOp06+aOp07)
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
gaKickOut += aSig
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
    aSig = sum(hsboscil(kAmp, p4, kBrite, iBasFreq, iSin, iWindow, 3),
               hsboscil(kAmp, p4, kBrite, 228, iSin, iWindow, 3))
endif
gaHsboscilOut += aSig
endin

instr Graint
;grain3
endin

instr Env
gaEnvOut[p4] = adsr(p5,p6,p7,p8)
endin

;wave guide instrument
instr WG
;play with wguide2 and rspline
asig1 wguide1 gaWGIn, gkWGFrq, gkWGCo+1000, gkWGFb+0.1
asig2 wguide1 gaWGIn, gkWGFrq*2, gkWGCo-1000, gkWGFb
asig3 wguide1 gaWGIn, gkWGFrq*4, gkWGCo, gkWGFb
gaWGOut += (asig1+asig2+asig3)/3
endin

gaPluckOut init 0
instr Pluck ;BASS
iplk    =           p6 ;(0 to 1)
kamp    =           p4
icps    =           p5
kpick   =           p7 ;pickup point
krefl   =           p8 ;rate of decay ]0,1[
asig    wgpluck2    iplk,kamp,icps,kpick,krefl
gaPluckOut += asig
endin

instr Verb ;stolen from the floss manual 05E01_freeverb.csd
gaVerbIn    init 0
kRoomSize   init      0.55     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
gaVerbOutL,gaVerbOutR freeverb gaVerbIn,gaVerbIn,kRoomSize,kHFDamp
endin

instr Main
;kick------------------------------
kFrq = kTempo*4/60
kTrig  metro kFrq
schedkwhen(kTrig, 0,0, "Kick", 0, 1/kFrq, 0.10, cpspch(6), 20)
gaKickOut += pdhalf(gaKickOut, -.9)*ampdb(-3)
gaKickOut diode_ladder gaKickOut, 2000, 0
;gaKickOut moogladder gaKickOut, 2000, 0
gaKickOut = limit(gaKickOut, -0.5, 0.5)
sbus_write 1, gaKickOut
sbus_mult  1, ampdb(-6)
;BASS------------------------------
;do the green thing, reuse variable <- umm.. not always
kFrq = kTempo*4/60
kTrig  metro kFrq
kBC[]  fillarray 8, 8, 4, 4, 1, 1, 1, 2, 3, 8, 5, 1, 1, 1
kBAS, kBT[] utBasemath kTrig, kBC
if kBT[kBAS] == 1 then
    kEnvDur = kBC[kBAS]/kFrq ;duration of the current step
    schedulek("Env", 0, kEnvDur, 0, kEnvDur*0.01, kEnvDur*0.99, 0, 0)
    schedulek("Pluck", 0, kEnvDur, 1, cpspch(6), 0.9, 0.7, 0.9)
endif
gaPluckOut *= gaEnvOut[0]
gaPluckOut moogladder gaPluckOut, cpspch(11), 0.0
sbus_write 2, gaPluckOut
sbus_mult  2, ampdb(-3)
;WG------------------------------
kFrq = kTempo/60
kTrig   metro kFrq
iTS     ftgenonce 0,0,-5*3,-51, 5,2,cpspch(6),0,
2^(0/12),2^(2/12),2^(5/12),2^(8/12),2^(10/12)
kTN[]   fillarray 2, 1, 1, 0, 2, 1, 1, 0
kTG[]   fillarray 0, 1, 0, 0, 0, 0, 1, 0
kTQ[]   fillarray 0, 0, 0, 0, 0, 0, 0, 0
kTAS, kTP[], kTT[] Taphath kTrig,kTN,kTG,kTQ, iTS
kcps = kTP[kTAS]
gkWGFrq, gkWGCo, gkWGFb = kcps, 3000, 0.9
schedule("WG", 0, -1)
if kTrig == 1 then
;   you can do this and pass them as p-fields
;   schedulek(-nstrnum("WG"), 0, 1)
;   schedulek("WG", 0, -1)
    kEnvDur = 0.04
    schedulek("Env", 0, kEnvDur, 1, kEnvDur/20, kEnvDur/2, 0, 0) ;das cool! clicky no more!
endif
gaWGIn = noise(0.3,0.9)*gaEnvOut[1] ;<diane> mic input as source
;gaWGOut pdhalf gaWGOut, -1
;gaWGOut moogladder gaWGOut, kTP[kTAS]*8, .4
;gaWGOut limit gaWGOut, -0.01, 0.01
;sbus_write 3, gaWGOut
sbus_mult  3, ampdb(-3)
;hsboscil------------------------------
kFrq = kTempo*2/60
kWav = 0
kDist = -.99
kTrig  metro kFrq
kBC1[]  fillarray 2, 2, 1, 2, 2, 1, 2, 2, 1, 2, 2, 1
kBAS, kBT[] utBasemath kTrig, kBC1
iTS    ftgenonce 0,0,-3*11,-51, 11,2,cpspch(7),
2^(0/12),2^(1/12),2^(2/12),2^(3/12),2^(4/12),2^(5/12),
2^(6/12),2^(7/12),2^(8/12),2^(9/12),2^(10/12),2^(11/12)
kTN[]  fillarray 2, 11,6, 2, 11,6, 2, 11,6, 4, 7, 6
kTG[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kTQ[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kTAS, kTP[], kTT[] Taphath kBT[kBAS],kTN,kTG,kTQ, iTS, 0, 0, 2
if kBT[kBAS] == 1 then
    kEnvDur = kBC1[kBAS]/kFrq
    kED = kEnvDur
    schedulek("Hsboscil",0, kED, kTP[kTAS], kWav)
    schedulek("Env",0, kED, 2, kED*.5, kED*.5, 0, 0)
endif
gaHsboscilOut *= gaEnvOut[2]*0.5
gaHsboscilOut pdhalf gaHsboscilOut, kDist
gaHsboscilOut diode_ladder gaHsboscilOut, kTP[kTAS]*8, 1;6.9, 1, 99
;sbus_write 4, gaHsboscilOut
sbus_mult  4, ampdb(-24)
endin
</CsInstruments>
<CsScore>
e
</CsScore>
</CsoundSynthesizer>

