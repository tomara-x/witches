//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//You're right, Mya, it is like seeing the face of god! ^_^

//DO NOT #include THIS!

//i wrote these with my weird scary convention in mind, and now
//i'm giving that up, and there should be a better fm oscillator
//i'll write sometime.. so those are a bit of a mess

//16 algorithms for 16 operator fm (designed for funzies)
//To be used with 3 global 2d arrays for each instrument gkFMx(Amp/Cps/Rat)
//and one 1d global audio array for the outputs. for example instrument 0:
/*
gkFM0Amp[][] init row, col
gkFM0Cps[][] init row, col
gkFM0Rat[][] init row, col
gaFM0Out[]   init row
*/
//row is the number of simultanious instances wanted and col should be 16
//the amplitude array controls the amplitude of each operator in each instance
//same for frequency and ratio arrays (ratio is a frequency multiplier)
//(gkFM12Rat[0][5] is the ratio of operator 5 in instance 0 instrument 12
//NOTE: Feedback is not done sample by sample in Pmoscili (ksmps dependent)

instr FM0
kAmp[]  getrow gkFM0Amp, p4
kCps[]  getrow gkFM0Cps, p4
kRat[]  getrow gkFM0Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp01+aOp04 
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp05+aOp06
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp05+aOp06
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp02+aOp07
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp05+aOp09
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05]
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06]
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp06+aOp10
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp05+aOp09
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09]
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10]
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp06+aOp10
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp08+aOp13
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp09+aOp10
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp09+aOp10
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp11+aOp14
gaFM0Out[p4] = aOp00 + aOp03 + aOp12 + aOp15
endin

instr FM1
kAmp[]  getrow gkFM1Amp, p4
kCps[]  getrow gkFM1Cps, p4
kRat[]  getrow gkFM1Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00]
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp00
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp03
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03]
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp00
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp01+aOp02+aOp04+aOp08
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp01+aOp02+aOp07+aOp11
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp03
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp12
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp04+aOp08+aOp13+aOp14
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp07+aOp11+aOp13+aOp14
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp15
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12]
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp12
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp15
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
gaFM1Out[p4] = aOp05 + aOp06 + aOp09 + aOp10
endin

instr FM2
kAmp[]  getrow gkFM2Amp, p4
kCps[]  getrow gkFM2Cps, p4
kRat[]  getrow gkFM2Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp01+aOp04+2*aOp05+aOp06+aOp09
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp05+aOp06
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp05+aOp06
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp02+aOp07+2*aOp06+aOp05+aOp10
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp05+aOp09
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05]
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06]
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp06+aOp10
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp05+aOp09
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09]
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10]
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp06+aOp10
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp08+aOp13+2*aOp09+aOp05+aOp10
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp09+aOp10
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp09+aOp10
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp11+aOp14+2*aOp10+aOp06+aOp09
gaFM2Out[p4] = aOp00 + aOp03 + aOp12 + aOp15
endin

instr FM3
kAmp[]  getrow gkFM3Amp, p4
kCps[]  getrow gkFM3Cps, p4
kRat[]  getrow gkFM3Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp05
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp05
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp06
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp06
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp05
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp09
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp05
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp06
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp09
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp10
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10]
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp10
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp09
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp09
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp10
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp10
gaFM3Out[p4]=aOp00+aOp01+aOp02+aOp03+aOp04+aOp07+aOp08+aOp11+aOp12+aOp13+aOp14+aOp15
endin

instr FM4
kAmp[]  getrow gkFM4Amp, p4
kCps[]  getrow gkFM4Cps, p4
kRat[]  getrow gkFM4Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00]
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp00
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp01
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp02
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp00
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp00
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp01
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp02
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp04
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp04
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp05
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp06
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp08
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp08
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp09
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp10
gaFM4Out[p4] = aOp03+aOp07+aOp11+aOp12+aOp13+aOp14+aOp15
endin

instr FM5
kAmp[]  getrow gkFM5Amp, p4
kCps[]  getrow gkFM5Cps, p4
kRat[]  getrow gkFM5Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp04
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp04
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp07
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp07
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp05+aOp06+aOp09+aOp10
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05]
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06]
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp05+aOp06+aOp09+aOp10
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp05+aOp06+aOp09+aOp10
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09]
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10]
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp05+aOp06+aOp09+aOp10
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp08
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp08
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp11
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp11
gaFM5Out[p4] = aOp00+aOp01+aOp02+aOp03+aOp12+aOp13+aOp14+aOp15
endin

instr FM6
kAmp[]  getrow gkFM6Amp, p4
kCps[]  getrow gkFM6Cps, p4
kRat[]  getrow gkFM6Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00]
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp00+aOp04+aOp02
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp03+aOp07
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03]
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04]
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp00+aOp04
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp03+aOp07+aOp05
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07]
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08]
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp08+aOp12+aOp10
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp11+aOp15
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11]
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12]
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp08+aOp12
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp11+aOp15+aOp13
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
gaFM6Out[p4] = aOp01+aOp06+aOp09+aOp14
endin

instr FM7
kAmp[]  getrow gkFM7Amp, p4
kCps[]  getrow gkFM7Cps, p4
kRat[]  getrow gkFM7Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp02+aOp03+aOp06+aOp07
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp02+aOp03+aOp06+aOp07
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02]
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03]
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp02+aOp03+aOp06+aOp07
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp02+aOp03+aOp06+aOp07
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06]
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07]
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp00+aOp01+aOp04+aOp05
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp00+aOp01+aOp04+aOp05
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp08+aOp09+aOp12+aOp13
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp08+aOp09+aOp12+aOp13
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp00+aOp01+aOp04+aOp05
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp00+aOp01+aOp04+aOp05
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp08+aOp09+aOp12+aOp13
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp08+aOp09+aOp12+aOp13
gaFM7Out[p4] = aOp10+aOp11+aOp14+aOp15
endin

instr FM8
kAmp[]  getrow gkFM8Amp, p4
kCps[]  getrow gkFM8Cps, p4
kRat[]  getrow gkFM8Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00]
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01]
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02]
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp07
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04]
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp00+aOp04
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp01+aOp05
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp02+aOp06
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08]
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp08+aOp12
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp09+aOp13
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp10+aOp14
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12]
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13]
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14]
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp11
gaFM8Out[p4] = aOp03+aOp15
endin

instr FM9
kAmp[]  getrow gkFM9Amp, p4
kCps[]  getrow gkFM9Cps, p4
kRat[]  getrow gkFM9Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp04+aOp05
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp05+aOp06
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp05+aOp06
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp06+aOp07
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp08+aOp09
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp09+aOp10
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp09+aOp10
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp10+aOp11
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp12+aOp13
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp13+aOp14
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp13+aOp14
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp14+aOp15
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12]
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13]
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14]
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
gaFM9Out[p4] = aOp00+aOp01+aOp02+aOp03
endin

instr FM10
kAmp[]  getrow gkFM10Amp, p4
kCps[]  getrow gkFM10Cps, p4
kRat[]  getrow gkFM10Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp08+aOp09+aOp13
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp00
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp03
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp01+aOp04+aOp05
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp00
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp00
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp03
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp03
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp12
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp12
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp15
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp15
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp10+aOp11+aOp14
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp12
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp15
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
gaFM10Out[p4] = aOp02+aOp06+aOp07
endin

instr FM11
kAmp[]  getrow gkFM11Amp, p4
kCps[]  getrow gkFM11Cps, p4
kRat[]  getrow gkFM11Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00], aOp01+aOp05
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp02+aOp06
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp03+aOp07
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03], aOp11+aOp15
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp01+aOp05
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp02+aOp06
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp03+aOp07
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp11+aOp15
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08]
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp08+aOp12
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp09+aOp13
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp10+aOp14
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12]
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp08+aOp12
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp09+aOp13
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp10+aOp14
gaFM11Out[p4] = aOp00+aOp04
endin

instr FM12
kAmp[]  getrow gkFM12Amp, p4
kCps[]  getrow gkFM12Cps, p4
kRat[]  getrow gkFM12Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00]
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp00
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp03
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03]
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp00
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp00
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp03
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp03
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp09
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp01+aOp04+aOp05
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp02+aOp06+aOp07
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp10
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12], aOp09
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp09
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp10
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15], aOp10
gaFM12Out[p4] = aOp08+aOp11+aOp12+aOp13+aOp14+aOp15
endin

instr FM13
kAmp[]  getrow gkFM13Amp, p4
kCps[]  getrow gkFM13Cps, p4
kRat[]  getrow gkFM13Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00]
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01]
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02]
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03]
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04]
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp00+aOp01+aOp04+aOp09
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp02+aOp03+aOp07+aOp05
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07]
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08]
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp08+aOp12+aOp13+aOp10
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp11+aOp14+aOp15
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11]
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12]
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13]
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14]
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
gaFM13Out[p4] = aOp06
endin

instr FM14
kAmp[]  getrow gkFM14Amp, p4
kCps[]  getrow gkFM14Cps, p4
kRat[]  getrow gkFM14Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00]
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp05+aOp09+aOp13
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp06+aOp10+aOp14
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03]
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04]
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp04
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp07
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07]
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08]
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp08
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp11
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11]
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12]
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13], aOp12
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14], aOp15
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
gaFM14Out[p4] = aOp01+aOp02
endin

instr FM15
kAmp[]  getrow gkFM15Amp, p4
kCps[]  getrow gkFM15Cps, p4
kRat[]  getrow gkFM15Rat, p4
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscili kAmp[00], kCps[00]*kRat[00]
aOp01   Pmoscili kAmp[01], kCps[01]*kRat[01], aOp00+aOp04+aOp05
aOp02   Pmoscili kAmp[02], kCps[02]*kRat[02], aOp03+aOp06+aOp07
aOp03   Pmoscili kAmp[03], kCps[03]*kRat[03]
aOp04   Pmoscili kAmp[04], kCps[04]*kRat[04], aOp08
aOp05   Pmoscili kAmp[05], kCps[05]*kRat[05], aOp09
aOp06   Pmoscili kAmp[06], kCps[06]*kRat[06], aOp10
aOp07   Pmoscili kAmp[07], kCps[07]*kRat[07], aOp11
aOp08   Pmoscili kAmp[08], kCps[08]*kRat[08], aOp12
aOp09   Pmoscili kAmp[09], kCps[09]*kRat[09], aOp13
aOp10   Pmoscili kAmp[10], kCps[10]*kRat[10], aOp14
aOp11   Pmoscili kAmp[11], kCps[11]*kRat[11], aOp15
aOp12   Pmoscili kAmp[12], kCps[12]*kRat[12]
aOp13   Pmoscili kAmp[13], kCps[13]*kRat[13]
aOp14   Pmoscili kAmp[14], kCps[14]*kRat[14]
aOp15   Pmoscili kAmp[15], kCps[15]*kRat[15]
gaFM15Out[p4] = aOp01+aOp02
endin

