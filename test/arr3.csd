//trans rights
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
//i-array manipulation and assignment to k-array
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

instr Main
iarr[] fillarray 2, 4, 5, 3
iarr *= 5
karr[] = iarr
printarray karr
endin
schedule("Main", 0, .05)

</CsInstruments>
</CsoundSynthesizer>
