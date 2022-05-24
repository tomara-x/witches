//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

;phase modulation oscillator
;syntax: ares Pmoscili xamp, kfreq [,aphase] [,ifn]
;note: feedback is not done sample by sample here
;using it without feedback is fine, but with makes it ksmps dependent
opcode Pmoscili, a, kkaj
kamp, kfreq, aphs, ifn xin
acarrier    phasor kfreq
asig        tablei acarrier+aphs, ifn, 1,0,1
xout        asig*kamp
endop
opcode Pmoscili, a, akaj ;overload for doing AM
aamp, kfreq, aphs, ifn xin
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

;pmo2
;hmm this way won't work
opcode Pmoscili2, a, kkaj
kamp, kfreq, aphs, ifn xin
acarrier phasor kfreq
kcnt = 0
while kcnt < ksmps do
    asig[kcnt] = tablei(acarrier[kcnt]+aphs[kcnt], ifn, 1,0,1)
    kcnt += 1
od
xout        asig*kamp
endop
opcode Pmoscili2, a, kkj ;just an oscili if no phase input is given
kamp, kfreq, ifn xin
xout    oscili(kamp, kfreq, ifn)
endop
