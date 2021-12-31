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
ktrig1  metro 30*15/60
kcnt[]  fillarray 1, 1/3, 1/3, 1/3, 1, 1/5, 1/5, 1/5, 1/5, 1/5
kn init 0
if kn == 0 then
    kcnt *= 15
    kn = 1
endif
kgain[] fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kmin[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kmax[]  fillarray 19, 19, 19, 19, 19, 19, 19, 19, 19, 19
kQ[]    fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
kAS, kt[] tBasemath ktrig1, kcnt, kgain, kmin, kmax, kQ

;schedkwhen ktrig1, 0,0, "beep", 0, 0.05, 440*2^2
schedkwhen kt[kAS], 0,0, "beep", 0, 0.05, 440*2^4

kcnt2[]  fillarray 4*15
kmax2[]  fillarray 64
kAS2, kt2[] tBasemath ktrig1, kcnt2, kgain, kmin, kmax2, kQ
schedkwhen kt2[kAS2], 0,0, "beep", 0, 0.05, 440*2^3
endin

instr 2
ktrig1 metro 2
ktrig2 metro 2.05
schedkwhen ktrig1, 0,0, "beep", 0, 0.05, 440*2^2
schedkwhen ktrig2, 0,0, "beep", 0, 0.05, 440*2^3
endin

instr beep
out oscil(0.4, p4)
endin

</CsInstruments>
<CsScore>
t       0       120
i2      0       240
e
</CsScore>
</CsoundSynthesizer>

