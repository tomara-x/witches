//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//fm
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #96#
#include "../opcodes.orc"

gkFM10Amp[][] init 1, 16
gkFM10Cps[][] init 1, 16
gkFM10Rat[][] init 1, 16
gaFM10Out[]   init 1

instr FM10
kAmp[]  getrow gkFM10Amp, p4
kCps[]  getrow gkFM10Cps, p4
kRat[]  getrow gkFM10Rat, p4
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
gaFM10Out[p4] = aOp02+aOp06+aOp07
endin

instr Granny ;use partikkel

endin

instr Verb ;stolen from the floss manual 05E01_freeverb.csd
gaVerbIn    init 0
kRoomSize   init      0.55     ; room size (range 0 to 1)
kHFDamp     init      0.9      ; high freq. damping (range 0 to 1)
gaVerbOutL,gaVerbOutR freeverb gaVerbIn,gaVerbIn,kRoomSize,kHFDamp
endin

instr Main
kTrig0      metro $TEMPO/60
kC0[]       fillarray 2, 4, 2, 8, 8, 4, 1, 2, 1, 2, 4, 2, 2, 6, 8, 8
kG0[]       fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kMin[]      fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kMax[]      fillarray 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
kQ[]        fillarray 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
kAS0, kT0[] tBasemath kTrig0, kC0, kG0, kMin, kMax, kQ

;FM
gkFM10Amp[0][15] = randomi(0, .5, 2)
gkFM10Amp[0][10] = randomi(0, .4, 5)
gkFM10Amp[0][11] = randomi(0, .4, 5)
gkFM10Amp[0][14] = randomi(0, .4, 5)
gkFM10Amp[0][12] = randomi(0, .3, 2)
gkFM10Amp[0][08] = randomi(0, .2, 5)
gkFM10Amp[0][09] = randomi(0, .2, 5)
gkFM10Amp[0][13] = randomi(0, .2, 5)
gkFM10Amp[0][00] = randomi(0, .5, 2)
gkFM10Amp[0][01] = randomi(0, .3, 5)
gkFM10Amp[0][04] = randomi(0, .3, 5)
gkFM10Amp[0][05] = randomi(0, .3, 5)
gkFM10Amp[0][03] = randomi(0, .5, 5)
gkFM10Amp[0][2], gkFM10Amp[0][6], gkFM10Amp[0][7] = 0.01
ktmp1[] = fillarray(1/4,1/2,1,1,1,1,1/2,1,1/4,1/2,1,2,1,1/8,1/2,1)
gkFM10Rat = setrow(ktmp1, 0)
kc1 = 0
while kc1 < 16 do
    gkFM10Cps[0][kc1] = randomi(220, 430, 1)
    kc1 += 1
od
schedule("FM10", 0, p3, 0)

;effects
;verb
schedule("Verb",0,-1)
gaVerbIn = gaFM10Out[0]*0.2

;mix
aOutL = gaVerbOutL
aOutR = gaVerbOutR

aOutL += gaFM10Out[0]*0.5
aOutR += gaFM10Out[0]*0.5

outs aOutL, aOutR
endin
schedule("Main", 0, 120)
</CsInstruments>
</CsoundSynthesizer>

