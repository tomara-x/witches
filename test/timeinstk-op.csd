<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

opcode Relative, k, 0
ktime timeinstk
xout ktime
endop

instr 1
kInstrTime timeinstk
;kOpcodTime Relative

if kInstrTime > 3 then
    kOpcodTime Relative
endif

printks "Instrument: %f, Opcode: %f\n", 0, kInstrTime, kOpcodTime
endin

</CsInstruments>
<CsScore>
i1 0 .1
</CsScore>
</CsoundSynthesizer>
