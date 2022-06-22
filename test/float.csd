//trans rights

<CsoundSynthesizer>
<CsOptions>
-n -Lstdin
</CsOptions>
<CsInstruments>

sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

instr 1
print 1/(128/60) ;duration in seconds of one beat at 128bpm
print 20^88
;print 30^800 ;yep, i broke it (seg fault)
print 367476337173/25474823337353 ;pretty sure that's not negative (overflow?)
endin

</CsInstruments>
<CsScore>
i1      0       1
e
</CsScore>
</CsoundSynthesizer>

