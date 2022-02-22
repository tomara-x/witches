//trans rights
//Copyright © 2022 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231 ;-t128
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

#define TEMPO #69#
#include "../opcodes.orc"

instr Taphy
iScale ftgenonce 0,0,-7*10,-51, 7,2,cpspch(p6),0,
2^(0/12),2^(2/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
gkTaphyTrig init 0
gkTaphyNote[]   fillarray 00, 05, 11, 11, 00, 00, 05, 05
gkTaphyGain[]   fillarray 04, 02, 00, 00, 01, 04, -1, 00
gkTaphyQ[]      fillarray 00, 00, 00, 00, 00, 00, 00, 00
gkTaphyMin[]    fillarray 21, 21, 21, 21, 21, 21, 21, 21
gkTaphyMax[]    fillarray 48, 48, 48, 48, 48, 48, 48, 48
gkTaphyAS, gkTaphyP[], kT[] Taphath gkTaphyTrig, gkTaphyNote, gkTaphyGain, 
        gkTaphyQ, gkTaphyMin, gkTaphyMax, iScale, p4, 0, p5
endin

gkFmAmp[] init 8
gkFmCps[] init 8
instr Fm
aOp1    Pmoscili gkFmAmp[0], gkFmCps[0]
aOp2    Pmoscili gkFmAmp[1], gkFmCps[1],  aOp1
aOp3    Pmoscili gkFmAmp[2], gkFmCps[2],  aOp1
aOp4    Pmoscili gkFmAmp[3], gkFmCps[3],  aOp1
aOp5    Pmoscili gkFmAmp[4], gkFmCps[4],  aOp2+aOp3+aOp4
aOp6    Pmoscili gkFmAmp[5], gkFmCps[5],  aOp5
aOp7    Pmoscili gkFmAmp[6], gkFmCps[6],  aOp5
aOp8    Pmoscili gkFmAmp[7], gkFmCps[7],  aOp5
gaFmOut = (aOp6 + aOp7 + aOp8)
endin

instr Kick
iTanh   ftgenonce 0,0,1024,"tanh", -5, 5, 0
iIFrq   = 230
iEFrq   = 40
aAEnv   expsegr 1,1.1,0.0001
aFEnv   expsegr iIFrq,p3,iIFrq,0.06,iEFrq
aSig    oscili aAEnv*.6, aFEnv
aSig    distort aSig, k(aAEnv)*0.2, iTanh
aSig    limit aSig, -0.5,0.5
aSig    += moogladder(aSig, iIFrq*2, .3)
gaKickOut = aSig*0.5
endin

instr Drum
aEnv1 expsegr 1, p4, 0.0001
aEnv2 expsegr 1, p5, 0.0001
aEnv3 expsegr 1, p6, 0.0001
aOp1  Pmoscili aEnv1, p7
aOp2  Pmoscili aEnv1, p8
aOp3  Pmoscili aEnv1, p9, aOp1+aOp2
gaDrumOut = aOp3*0.1
endin

instr Granny ;use partikkel

endin

instr Verb ;stolen from the floss manual 05E01_freeverb.csd
gaVerbIn    init 0
kRoomSize   init      0.85     ; room size (range 0 to 1)
kHFDamp     init      0.5      ; high freq. damping (range 0 to 1)
gaVerbOutL,gaVerbOutR freeverb gaVerbIn,gaVerbIn,kRoomSize,kHFDamp
endin

instr Main
kTrig1      metro $TEMPO/60
kC1[]       fillarray 08, 04, 01, 01, 01, 01, 02, 02
kAS1, kT1[] utBasemath kTrig1, kC1
kTrig2      metro $TEMPO*8/60
kC2[]       fillarray 03, 01, 03, 01, 02, 02, 02, 02
kAS2, kT2[] utBasemath kTrig2, kC2

if kAS1 > 3 then
    schedkwhen(kT2[0]+kT2[4], 0,0, "Kick", 0, 0.0001)
    kDrmTrg = kT2[kAS2]-(kT2[2]+kT2[4]+kT2[7])
    schedkwhen(kDrmTrg,0,0,"Drum",0,0.0001,.3,.1,2,440,55,220)
else
    schedkwhen(kT2[0]+kT2[5], 0,0, "Kick", 0, 0.0001)
endif
if kAS1 >= 0 && kAS1 < 5 then
    gkTaphyP[] init 9
    schedkwhen(kT1[0], 0,0, "Taphy", 0, -1, 0, 0, 4)
    schedkwhen(kT1[0], 0,0, "Fm",0, -1)
    gkTaphyTrig = kT2[kAS2]
    gkFmCps = gkTaphyP
    gkFmAmp = 0.02
endif
if kT1[5] == 1 then
    schedulek(-nstrnum("Taphy"), 0, 1)
    schedulek(-nstrnum("Fm"), 0, 1)
    clear(gaFmOut)
endif

schedule("Verb",0,-1)
gaVerbIn = gaKickOut*0.1 + gaFmOut*0.3

;mix
aOutL = gaKickOut+gaVerbOutL
aOutR = gaKickOut+gaVerbOutR

aOutL += gaDrumOut
aOutR += gaDrumOut

aOutL += gaFmOut
aOutR += gaFmOut

outs aOutL, aOutR
endin
schedule("Main", 0, -1)
schedule(-nstrnum("Main"), 120, 1)
</CsInstruments>
</CsoundSynthesizer>

