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



;TODO: hbout a feedback buffer length? (sample-by-sample is buffer length 1)
;ranging from 1 to ksmps. and ksmps should be divisible by it

//Pmoscilx
;sample-by-sample feedback with a separate feedback parameter
;don't feed the signal back into the phase input, that's ksmps dependent
;instead use the feedback parameter which isn't limited by the way >:)

;syntax: aOut Pmoscilx kAmp, kFrq, aPhs [,kFB] [,iIntrp] [,iFn]

;aPhs: audio-rate phase modulation input
;kFB: feedback amount. defaults to 0 (no feedback), can go to 1
;   (feed full signal), can be higher (multiplier) or negative (attenuverter)
;iIntrp: interpolation mode (defaults to linear)
;   (0 = linear, 1 = cubic, otherwise no interpolation)
;iFn: oscillator's waveform function table (defaults to -1, a sine wave ft)
opcode Pmoscilx, a, kkaOoj
kAmp, kFrq, aPhs, kFB, iIntrp, iFn xin
aSig init 0
aCar phasor kFrq
kLastSamp init 0 ;last sample from previous k-cycle
ki = 0
while ki < ksmps do
    ;add previous out sample to phase input
    if ki == 0 then
        aPhs[ki] = aPhs[ki] + kLastSamp*kFB
    else
        aPhs[ki] = aPhs[ki] + aSig[ki-1]*kFB
    endif
    ;oscillate
    if iIntrp == 0 then
        aSig[ki] tablei aCar[ki]+aPhs[ki], iFn, 1,0,1
    elseif iIntrp == 1 then
        aSig[ki] table3 aCar[ki]+aPhs[ki], iFn, 1,0,1
    else
        aSig[ki] table aCar[ki]+aPhs[ki], iFn, 1,0,1
    endif
    ki += 1
od
;store last sample of output signal to use next cycle
kLastSamp = aSig[ksmps-1]
xout aSig*kAmp
endop



;a-rate amp input
;syntax: aOut Pmoscilx aAmp, kFrq, aPhs [,kFB] [,iIntrp] [,iFn]
opcode Pmoscilx, a, akaOoj
aAmp, kFrq, aPhs, kFB, iIntrp, iFn xin
aSig init 0
aCar phasor kFrq
kLastSamp init 0 ;last sample from previous k-cycle
ki = 0
while ki < ksmps do
    ;add previous out sample to phase input
    if ki == 0 then
        aPhs[ki] = aPhs[ki] + kLastSamp*kFB
    else
        aPhs[ki] = aPhs[ki] + aSig[ki-1]*kFB
    endif
    ;oscillate
    if iIntrp == 0 then
        aSig[ki] tablei aCar[ki]+aPhs[ki], iFn, 1,0,1
    elseif iIntrp == 1 then
        aSig[ki] table3 aCar[ki]+aPhs[ki], iFn, 1,0,1
    else
        aSig[ki] table aCar[ki]+aPhs[ki], iFn, 1,0,1
    endif
    ki += 1
od
;store last sample of output signal to use next cycle
kLastSamp = aSig[ksmps-1]
xout aSig*aAmp
endop



;no phase input
;syntax: aOut Pmoscilx kAmp, kFrq [,kFB] [,iIntrp] [,iFn]
opcode Pmoscilx, a, kkOoj
kAmp, kFrq, kFB, iIntrp, iFn xin
aPhs = 0
aSig init 0
aCar phasor kFrq
kLastSamp init 0 ;last sample from previous k-cycle
ki = 0
while ki < ksmps do
    ;add previous out sample to phase input
    if ki == 0 then
        aPhs[ki] = aPhs[ki] + kLastSamp*kFB
    else
        aPhs[ki] = aPhs[ki] + aSig[ki-1]*kFB
    endif
    ;oscillate
    if iIntrp == 0 then
        aSig[ki] tablei aCar[ki]+aPhs[ki], iFn, 1,0,1
    elseif iIntrp == 1 then
        aSig[ki] table3 aCar[ki]+aPhs[ki], iFn, 1,0,1
    else
        aSig[ki] table aCar[ki]+aPhs[ki], iFn, 1,0,1
    endif
    ki += 1
od
;store last sample of output signal to use next cycle
kLastSamp = aSig[ksmps-1]
xout aSig*kAmp
endop



;a-rate amp input and no phase input
;syntax: aOut Pmoscilx aAmp, kFrq [,kFB] [,iIntrp] [,iFn]
opcode Pmoscilx, a, akOoj
aAmp, kFrq, kFB, iIntrp, iFn xin
aPhs = 0
aSig init 0
aCar phasor kFrq
kLastSamp init 0 ;last sample from previous k-cycle
ki = 0
while ki < ksmps do
    ;add previous out sample to phase input
    if ki == 0 then
        aPhs[ki] = aPhs[ki] + kLastSamp*kFB
    else
        aPhs[ki] = aPhs[ki] + aSig[ki-1]*kFB
    endif
    ;oscillate
    if iIntrp == 0 then
        aSig[ki] tablei aCar[ki]+aPhs[ki], iFn, 1,0,1
    elseif iIntrp == 1 then
        aSig[ki] table3 aCar[ki]+aPhs[ki], iFn, 1,0,1
    else
        aSig[ki] table aCar[ki]+aPhs[ki], iFn, 1,0,1
    endif
    ki += 1
od
;store last sample of output signal to use next cycle
kLastSamp = aSig[ksmps-1]
xout aSig*aAmp
endop





;optimizing
opcode Pmoi, a, kkaOj
kAmp, kFrq, aPhs, kFB, iFn xin
aSig init 0
aCar phasor kFrq
kLastSamp init 0 ;last sample from previous k-cycle
ki = 0
while ki < ksmps do
    ;add previous out sample to phase input
    if ki == 0 then
        aPhs[ki] = aPhs[ki] + kLastSamp*kFB
    else
        aPhs[ki] = aPhs[ki] + aSig[ki-1]*kFB
    endif
    ;oscillate
    aSig[ki] tablei aCar[ki]+aPhs[ki], iFn, 1,0,1
    ki += 1
od
;store last sample of output signal to use next cycle
kLastSamp = aSig[ksmps-1]
xout aSig*kAmp
endop

;no phase input
opcode Pmoi, a, kkOj
kAmp, kFrq, kFB, iFn xin
aPhs = 0
aSig init 0
aCar phasor kFrq
kLastSamp init 0 ;last sample from previous k-cycle
ki = 0
while ki < ksmps do
    ;add previous out sample to phase input
    if ki == 0 then
        aPhs[ki] = aPhs[ki] + kLastSamp*kFB
    else
        aPhs[ki] = aPhs[ki] + aSig[ki-1]*kFB
    endif
    ;oscillate
    aSig[ki] tablei aCar[ki]+aPhs[ki], iFn, 1,0,1
    ki += 1
od
;store last sample of output signal to use next cycle
kLastSamp = aSig[ksmps-1]
xout aSig*kAmp
endop




;USE WITH CAUTION! attenuate AND limit output!
;maybe use safe division (divz) here
;asig SuperFormula kcps, km1, km2, kn1, kn2, kn3, ka, kb
opcode SuperFormula, a, kkkkkkkk
kcps, km1, km2, kn1, kn2, kn3, ka, kb xin
asig phasor kcps
asig = (abs(cos((km1*asig)/4)/ka)^kn2 +
        abs(sin((km2*asig)/4)/kb)^kn3)^-1/kn1
xout asig
endop


