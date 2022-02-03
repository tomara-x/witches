<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

instr 1
ifn1 ftgenonce 0,0,8,-7, 0,8,8
ifn2 ftgenonce 0,0,8,-2, 0
ii = 0
while ii < 8 do
    tablew(ii, ii, ifn2)
    ii += 1
od
ftprint ifn1
ftprint ifn2
endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
