trans rights
<CsoundSynthesizer>
<CsOptions>
-odac -L stdin -m 231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   1
0dbfs   =   1

instr 1
ktrig1 metro 4
ktrig2 metro 3
schedkwhen ktrig1, 0,0, "beep", 0, 0.05, 440*2^2
schedkwhen ktrig2, 0,0, "beep", 0, 0.05, 440*2^3
endin

instr beep
out oscil(0.4, p4)
endin

</CsInstruments>
<CsScore>
i1 0 30
e
</CsScore>
</CsoundSynthesizer>

