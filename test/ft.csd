<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

giftmp1  ftgen 0,0,64, 10, 1
giampfn  ftgen 0,0,64,-24, giftmp1, 0, 0.05 ;rescale

instr 1
print(ftlen(giampfn))
ftprint giampfn
endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
