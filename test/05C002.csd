<CsoundSynthesizer>
<CsOptions>
-odac -L stdin
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 42
nchnls = 1
0dbfs = 1

instr 1
asig1	vco2	0.03, 220
klfo1	lfo		1, 4
klfo2	lfo		1, 6
asig	bqrez	asig1, 440, (klfo2+2)*30, 0
		out		asig
endin

</CsInstruments>
<CsScore>
i1 0 10
</CsScore>
</CsoundSynthesizer>
