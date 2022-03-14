//trans rights
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
;fillarray length at i time
sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

/*
instr Main
karr[] fillarray 2, 4, 5, 3, 2
print(lenarray(karr))
printarray karr
endin
*/
instr Main
kv init 0
kv += 1
karr[] fillarray 2, 4, 5, 3, kv
print(lenarray(karr))
printarray karr
endin
schedule("Main", 0, .05)

</CsInstruments>
</CsoundSynthesizer>
