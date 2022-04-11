<CsoundSynthesizer>
<CsOptions>
-L stdin -odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 42
nchnls = 1
0dbfs = 1

instr 1	
atrig	=	upsamp(metro(5))
kenvf	expseg	.1,5,5000, 0, .1,5,5000
kenvr	linseg	0,5,1, 0, 0,5,1
asig	moogladder atrig, kenvf, kenvr
asig	limit	asig, -.5, .5
out	asig
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
