trans rights

<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
; ==============================================
<CsInstruments>

sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

instr 1
print 1/(128/60)
endin

</CsInstruments>
; ==============================================
<CsScore>
i1      0       1
e
</CsScore>
</CsoundSynthesizer>

