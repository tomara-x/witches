//trans rights
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
</CsOptions>
<CsInstruments>
0dbfs  = 1
instr Main
;out oscil(db(100), 440)
endin
schedule("Main", 0, 10)
</CsInstruments>
</CsoundSynthesizer>
