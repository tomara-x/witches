<CsoundSynthesizer>
<CsOptions>
-odac -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 42
nchnls = 1
0dbfs = 1

instr 1
ktrig metro 1/5 ;every 5 seconds
if ktrig == 1 then
  reinit compile
endif
compile:
  ires compileorc "injection.orc"
endin

</CsInstruments>
<CsScore>
i1   0 120
</CsScore>
</CsoundSynthesizer>
