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
k1[]    fillarray   1, 1, 1, 1
k2[]    init        4
k1[0] = k1[0] + .25
k1[2] = k1[2] - .25
        printarray  k1
kn = 0
while kn < lenarray(k1) do
    k2[kn] = wrap(k1[kn], 0, 2)
    kn += 1
od
        printarray  k2
endin

instr 2
k1[]    fillarray   1, 1, 1, 1
k2[]    init        4
k1[0] = k1[0] + .25
k1[2] = k1[2] - .25
        printarray  k1
kn = 0
while kn < lenarray(k1) do
    k2[kn] = wrap(k1[kn], 0, 2.00001)
    kn += 1
od
        printarray  k2
endin

</CsInstruments>
<CsScore>
i1 0 .2
i2 .2 .2
</CsScore>
</CsoundSynthesizer>
