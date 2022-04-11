<CsoundSynthesizer>
<CsInstruments>

instr 101
atrig	=	upsamp(metro(5))
asig	moogladder atrig, 3000, .6
asig	limit	asig, -.5, .5
out asig
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
