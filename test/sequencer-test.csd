//trans rights
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   1
0dbfs   =   1

#include "../sequencers.orc"

instr Taphy
iScale ftgenonce 0,0,-7*4,-51, 7,2,cpspch(6),0,
2^(0/12),2^(1/12),2^(3/12),2^(5/12),2^(7/12),2^(8/12),2^(10/12)
kTrig   metro 1
kNote[] fillarray 2, 3, 4, 4, 3, 4, 7, 8
kGain[] fillarray 0, 0, 1, 0, 0, 3, 1, 0
kQ[]    fillarray 0, 0, 0, 0, 0, 0, 0, 0
kAS, kP[], kT[], kN[] Taphath kTrig, kNote, kGain, kQ, iScale
out poscil(0.05, kP[kAS])
endin

schedule("Taphy", 0, 120)

</CsInstruments>
</CsoundSynthesizer>

