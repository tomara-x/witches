//trans rights
<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

;haha! optional array arguments, bitches!
opcode Test, 0, 0
kArr1[] fillarray 1,2,3,4
printarray kArr1
endop
opcode Test, 0, k[]
kArr1[] xin
printarray kArr1
endop
opcode Test, 0, k[]k[]
kArr1[], kArr2[] xin
printarray kArr2
Test kArr1
endop

instr Main
k1[] fillarray 1,1,1,1
k2[] fillarray 2,2,2,2
Test
endin

schedule("Main", 0, .1)
</CsInstruments>
</CsoundSynthesizer>
