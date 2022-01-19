<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

gifn1 ftgen 0,0,8,-2, 0,1,2,3,4,5,6,7
gifn2 ftgen 0,0,8,-2, 10,11,12,13,14,15,16,17

instr 1
kfn init gifn1
printk2(tablekt(0, kfn))
kfn = gifn2
endin

</CsInstruments>
<CsScore>
i1 0 1
</CsScore>
</CsoundSynthesizer>
