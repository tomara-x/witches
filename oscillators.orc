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



//Pmoscili2
;sample-by-sample feedback with a separate feedback parameter
;don't feed the signal back anto the phase input, that's ksmps dependent
;instead use the feedback parameter which isn't limited by the way >:)

;syntax: aSig Pmoscili2 kAmp, kFrq, aPhs [,kFeedback] [,iFn]
opcode Pmoscili2, a, kkaOj
kamp, kfreq, aphs, kfb, ifn xin
asig init 0
acar phasor kfreq
klastsamp init 0
ki = 0
while ki < ksmps do
    if ki == 0 then
        aphs[ki] = aphs[ki] + klastsamp*kfb
    else
        aphs[ki] = aphs[ki] + asig[ki-1]*kfb
    endif
    asig[ki] tablei acar[ki]+aphs[ki], ifn, 1,0,1
    ki += 1
od
klastsamp = asig[ksmps-1]
xout asig*kamp
endop

;hbout an interp input which selects table/tablei/table3?
;feels easier than a bunch of different definitions.

;after which do the am/no-phase-in overloads


