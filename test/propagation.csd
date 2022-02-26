//trans rights
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

instr Sine
out poscil(p4, p5)
endin

instr Main
kTrig metro 2
schedkwhen(kTrig, 0,0, "Sine", 0, .1, 1, 440*2^int(randomi:k(0,5,2)))
endin
schedule("Main", 0, 120)

</CsInstruments>
</CsoundSynthesizer>
