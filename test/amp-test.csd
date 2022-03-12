<CsoundSynthesizer>
<CsOptions>
-n -Lstdin
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

instr 1
print(ampdb(-48))
print(ampdbfs(-48))
endin

instr 2
print(dbamp(.005))
print(dbfsamp(.005))
endin

</CsInstruments>
<CsScore>
i1  0 .1
i2 .1 .1
</CsScore>
</CsoundSynthesizer>
