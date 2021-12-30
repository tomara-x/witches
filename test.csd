trans rights
<CsoundSynthesizer>
<CsOptions>
; Real-time / render
-odac -L stdin -m 231
; -o rose.wav
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   1
0dbfs   =   1
#include "opcodes.orc"

instr 1
ktrig1  metro 2
kcnt[]  fillarray 2, 1, 4, -4
kgain[] fillarray 0, 0, 0, 0
kmin[]  fillarray 0, 0, 0, 0
kmax[]  fillarray 9, 9, 9, 9
kQ[]    fillarray 0, 0, 0, 0
kAS, kt[] tBasemath ktrig1, kcnt, kgain, kmin, kmax, kQ

schedkwhen ktrig1, 0,0, "beep", 0, 0.05, 440*2^3
schedkwhen kt[kAS], 0,0, "beep", 0, 0.05, 440*2^4
endin

instr 2
ktrig1 metro 2
ktrig2 ClkDivp ktrig1, 2, -1
schedkwhen ktrig1, 0,0, "beep", 0, 0.05, 440*2^3
schedkwhen ktrig2, 0,0, "beep", 0, 0.05, 440*2^4
endin

instr beep
out oscil(0.8, p4)
endin

</CsInstruments>
<CsScore>
t       0       120
i1      0       120
e
</CsScore>
</CsoundSynthesizer>

