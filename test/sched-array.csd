trans rights
<CsoundSynthesizer>
<CsOptions>
-odac -L stdin -m 231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=100
nchnls  =   1
0dbfs   =   1

instr 1
karr[]   fillarray 2, 00, .5, 440*(2^1), \
                   2, .5, .5, 440*(2^2), \
                   2, 01, .5, 440*(2^3)
;reshapearray karr, 4, 3
;printarray(karr[0]) ;nope
schedulek karr
endin

instr 2
out oscil(0.4, p4)
endin

</CsInstruments>
<CsScore>
i1 0 .5
e
</CsScore>
</CsoundSynthesizer>

