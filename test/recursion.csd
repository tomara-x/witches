//trans rights
<CsoundSynthesizer>
<CsOptions>
-odac -Lstdin -m231
;-n -Lstdin -m231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42
nchnls  =   2
0dbfs   =   1

instr Play
ifreq1 random 600, 1000
idiff  random 100, 300
ifreq2 = ifreq1 - idiff
kFreq  expseg ifreq1, p3, ifreq2
iMaxdb random -18, -6
kAmp   transeg ampdb(iMaxdb), p3, -10, 0
aTone  poscil kAmp, kFreq
out aTone, aTone

if p4 > 0 then
    schedule("Play", random:i(.3,1.), random:i(1,5), p4-1)
endif
endin
schedule("Play", 0, 3, 20)
</CsInstruments>
</CsoundSynthesizer>

example by joachim heintz
