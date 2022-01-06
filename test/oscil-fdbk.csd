trans rights
<CsoundSynthesizer>
<CsOptions>
; Real-time / render / no sound
-odac -L stdin -m 231
; -o rose.wav
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   1
0dbfs   =   1

opcode Pmoscili, a, kkaj
kamp, kfreq, aphs, ifn xin
acarrier    phasor kfreq
asig        tablei acarrier+aphs, ifn, 1,0,1
xout        asig*kamp
endop

instr 1
asig = Pmoscili(.2, 220, asig*1.1) ;works
asig = Pmoscili(.2, 220, asig*0.1) ;works
asig = Pmoscili(.2, 220, asig*1.0) ;workn't

out asig
endin

</CsInstruments>
<CsScore>
i1      0       1
e
</CsScore>
</CsoundSynthesizer>

