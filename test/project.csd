<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

gkTest init 42

opcode UDOInit, i, 0
    gkTest += 1
    iVal = i(gkTest)
    xout iVal
endop

instr Test
	kgoto l1
    kValue init UDOInit()
l1:
    printk .01, kValue ; prints "42", as expected
    printk .01, gkTest ; why does it keep being incremented?
endin

</CsInstruments>
<CsScore>
i "Test" 0 .1
</CsScore>
</CsoundSynthesizer>
