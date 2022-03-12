//trans rights
<CsoundSynthesizer>
<CsOptions>
-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   441
nchnls  =   1
0dbfs   =   1

instr Arr1
kArr[][] init 4, 8
kArr = setrow(getrow(kArr, 0) + 2, 0)
printarray(kArr)
endin
schedule("Arr1", 0, 0.01)

</CsInstruments>
</CsoundSynthesizer>


