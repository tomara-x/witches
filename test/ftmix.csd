<CsoundSynthesizer>
<CsOptions>
-n -L stdin
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 441
nchnls = 1
0dbfs  = 1

</CsInstruments>
<CsScore>
f1 0 16384 10 1 ; Sine
f2 0 16384 10 1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111 ; Sawtooth
f3 0 16384 18 1 -1 0 16383 2 1 0 16383
</CsScore>
</CsoundSynthesizer>
