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
ktrig	metro	1
ktime	timeinsts
printf("ktime = %f\n", ktrig, ktime)
;printk2 ktime
endin

</CsInstruments>
<CsScore>
t  0 120
i1 0 10
e
</CsScore>
</CsoundSynthesizer>
