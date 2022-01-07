trans rights
<CsoundSynthesizer>
<CsOptions>
-odac -L stdin -m 231
</CsOptions>
<CsInstruments>
sr      =   44100
ksmps   =   42 ;kr=1050
nchnls  =   1
0dbfs   =   1

;phase modulation oscillator
;syntax: ares Pmoscili xamp, kfreq [,aphase] [,ifn]
opcode Pmoscili, a, kkaj
kamp, kfreq, aphs, ifn xin
;setksmps 1
acarrier    phasor kfreq
asig        tablei acarrier+aphs, ifn, 1,0,1
xout        asig*kamp
endop
opcode Pmoscili, a, akaj ;overload for doing AM
aamp, kfreq, aphs, ifn xin
;setksmps 1
acarrier    phasor kfreq
asig        tablei acarrier+aphs, ifn, 1,0,1
xout        asig*aamp
endop
opcode Pmoscili, a, kkj ;just an oscili if no phase input is given
kamp, kfreq, ifn xin
xout    oscili(kamp, kfreq, ifn)
endop
opcode Pmoscili, a, akj ; AM
aamp, kfreq, ifn xin
xout    oscili(aamp, kfreq, ifn)
endop

instr 1
setksmps 1
asig1, asig2 init 0
asig1 = Pmoscili(1, 110)
asig2 = Pmoscili(1, 220, asig2*0.3)
out asig2*0.1
endin

instr 2
setksmps 1
acarrier    phasor 220
asig        init 0
asig        tablei acarrier+asig*0.4, -1, 1,0,1
out         asig*0.1
endin

</CsInstruments>
<CsScore>
i1 0 1
e
</CsScore>
</CsoundSynthesizer>

