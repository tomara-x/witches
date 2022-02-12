<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

giarr[] init 4 ;number of channels

instr 1
giarr[p4] = p5
endin

instr 2
printarray(giarr)
endin


schedule(1, 0, 1, 0, 42)
schedule(1, 1, 1, 1, 69)
schedule(1, 2, 1, 2, 105)
schedule(1, 3, 1, 3, 420)
schedule(2, 4, 1)

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
