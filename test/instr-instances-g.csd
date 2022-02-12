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
gktest = p4
endin

instr 2
printk2 gktest
endin

schedule(1.1, 0, 4, 1)
schedule(1.2, 1, 1, 2)
schedule(1.3, 2, 1, 3)
schedule(2,0,-1)

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
