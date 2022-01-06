<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

gifn1 ftgen 0,0,-9,-2, 0,1,2,3,4,5,6,7,8

instr 1
print(ftlen(gifn1))
ftprint gifn1
endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
