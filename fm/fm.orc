//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.

//You're right, Mya, it is like seeing the face of god! ^_^

//16 algorithms for 16 operator fm (designed for funzies)
//see the png image in this directory
//everything (algorithms and the operators inside) is numbered as follows:
// 00 01 02 03
// 04 05 06 07
// 08 09 10 11
// 12 13 14 15

//#include "oscillators.orc"

instr FM0
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00], aOp01+aOp04, kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp05+aOp06, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp05+aOp06, kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp02+aOp07, kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp05+aOp09, kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05],              kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06],              kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp06+aOp10, kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp05+aOp09, kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09],              kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10],              kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp06+aOp10, kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12], aOp08+aOp13, kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp09+aOp10, kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp09+aOp10, kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp11+aOp14, kFB[15]
aSig = aOp00 + aOp03 + aOp12 + aOp15
endin

instr FM1
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00],                          kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp00,                   kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp03,                   kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03],                          kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp00,                   kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp01+aOp02+aOp04+aOp08, kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp01+aOp02+aOp07+aOp11, kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp03,                   kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp12,                   kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp04+aOp08+aOp13+aOp14, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp07+aOp11+aOp13+aOp14, kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp15,                   kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12],                          kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp12,                   kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp15,                   kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15],                          kFB[15]
aSig = aOp05 + aOp06 + aOp09 + aOp10
endin

instr FM2
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00], aOp01+aOp04+2*aOp05+aOp06+aOp09, kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp05+aOp06,                     kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp05+aOp06,                     kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp02+aOp07+2*aOp06+aOp05+aOp10, kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp05+aOp09,                     kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05],                                  kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06],                                  kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp06+aOp10,                     kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp05+aOp09,                     kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09],                                  kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10],                                  kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp06+aOp10,                     kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12], aOp08+aOp13+2*aOp09+aOp05+aOp10, kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp09+aOp10,                     kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp09+aOp10,                     kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp11+aOp14+2*aOp10+aOp06+aOp09, kFB[15]
aSig = aOp00 + aOp03 + aOp12 + aOp15
endin

instr FM3
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00], aOp05, kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp05, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp06, kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp06, kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp05, kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp09, kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp05, kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp06, kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp09, kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp10, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10],        kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp10, kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12], aOp09, kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp09, kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp10, kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp10, kFB[15]
aSig = aOp00+aOp01+aOp02+aOp03+aOp04+aOp07+aOp08+aOp11+aOp12+aOp13+aOp14+aOp15
endin

instr FM4
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00],        kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp00, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp01, kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp02, kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp00, kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp00, kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp01, kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp02, kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp04, kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp04, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp05, kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp06, kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12], aOp08, kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp08, kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp09, kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp10, kFB[15]
aSig = aOp03+aOp07+aOp11+aOp12+aOp13+aOp14+aOp15
endin

instr FM5
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00], aOp04,                   kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp04,                   kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp07,                   kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp07,                   kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp05+aOp06+aOp09+aOp10, kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05],                          kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06],                          kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp05+aOp06+aOp09+aOp10, kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp05+aOp06+aOp09+aOp10, kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09],                          kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10],                          kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp05+aOp06+aOp09+aOp10, kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12], aOp08,                   kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp08,                   kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp11,                   kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp11,                   kFB[15]
aSig = aOp00+aOp01+aOp02+aOp03+aOp12+aOp13+aOp14+aOp15
endin

instr FM6
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00],                    kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp00+aOp04+aOp02, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp03+aOp07,       kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03],                    kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04],                    kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp00+aOp04,       kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp03+aOp07+aOp05, kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07],                    kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08],                    kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp08+aOp12+aOp10, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp11+aOp15,       kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11],                    kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12],                    kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp08+aOp12,       kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp11+aOp15+aOp13, kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15],                    kFB[15]
aSig = aOp01+aOp06+aOp09+aOp14
endin

instr FM7
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00], aOp02+aOp03+aOp06+aOp07, kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp02+aOp03+aOp06+aOp07, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02],                          kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03],                          kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp02+aOp03+aOp06+aOp07, kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp02+aOp03+aOp06+aOp07, kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06],                          kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07],                          kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp00+aOp01+aOp04+aOp05, kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp00+aOp01+aOp04+aOp05, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp08+aOp09+aOp12+aOp13, kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp08+aOp09+aOp12+aOp13, kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12], aOp00+aOp01+aOp04+aOp05, kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp00+aOp01+aOp04+aOp05, kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp08+aOp09+aOp12+aOp13, kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp08+aOp09+aOp12+aOp13, kFB[15]
aSig = aOp10+aOp11+aOp14+aOp15
endin

instr FM8
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00],              kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01],              kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02],              kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp07,       kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04],              kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp00+aOp04, kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp01+aOp05, kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp02+aOp06, kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08],              kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp08+aOp12, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp09+aOp13, kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp10+aOp14, kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12],              kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13],              kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14],              kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp11,       kFB[15]
aSig = aOp03+aOp15
endin

instr FM9
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00], aOp04+aOp05, kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp05+aOp06, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp05+aOp06, kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp06+aOp07, kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp08+aOp09, kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp09+aOp10, kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp09+aOp10, kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp10+aOp11, kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp12+aOp13, kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp13+aOp14, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp13+aOp14, kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp14+aOp15, kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12],              kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13],              kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14],              kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15],              kFB[15]
aSig = aOp00+aOp01+aOp02+aOp03
endin

instr FM10
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00], aOp08+aOp09+aOp13, kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp00,             kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp03,             kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp01+aOp04+aOp05, kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp00,             kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp00,             kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp03,             kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp03,             kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp12,             kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp12,             kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp15,             kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp15,             kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12], aOp10+aOp11+aOp14, kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp12,             kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp15,             kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15],                    kFB[15]
aSig = aOp02+aOp06+aOp07
endin

instr FM11
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00], aOp01+aOp05, kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp02+aOp06, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp03+aOp07, kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03], aOp11+aOp15, kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp01+aOp05, kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp02+aOp06, kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp03+aOp07, kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp11+aOp15, kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08],              kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp08+aOp12, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp09+aOp13, kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp10+aOp14, kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12],              kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp08+aOp12, kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp09+aOp13, kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp10+aOp14, kFB[15]
aSig = aOp00+aOp04
endin

instr FM12
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00],                    kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp00,             kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp03,             kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03],                    kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp00,             kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp00,             kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp03,             kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp03,             kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp09,             kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp01+aOp04+aOp05, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp02+aOp06+aOp07, kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp10,             kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12], aOp09,             kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp09,             kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp10,             kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15], aOp10,             kFB[15]
aSig = aOp08+aOp11+aOp12+aOp13+aOp14+aOp15
endin

instr FM13
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00],                          kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01],                          kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02],                          kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03],                          kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04],                          kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp00+aOp01+aOp04+aOp09, kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp02+aOp03+aOp07+aOp05, kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07],                          kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08],                          kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp08+aOp12+aOp13+aOp10, kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp11+aOp14+aOp15,       kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11],                          kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12],                          kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13],                          kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14],                          kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15],                          kFB[15]
aSig = aOp06
endin

instr FM14
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00],                    kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp05+aOp09+aOp13, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp06+aOp10+aOp14, kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03],                    kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04],                    kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp04,             kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp07,             kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07],                    kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08],                    kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp08,             kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp11,             kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11],                    kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12],                    kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13], aOp12,             kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14], aOp15,             kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15],                    kFB[15]
aSig = aOp01+aOp02
endin

instr FM15
kAmp[]  init 16
kCps[]  init 16
kRat[]  init 16
kFB[]   init 16
aOp00, aOp01, aOp02, aOp03, aOp04, aOp05, aOp06, aOp07 init 0
aOp08, aOp09, aOp10, aOp11, aOp12, aOp13, aOp14, aOp15 init 0
aOp00   Pmoscilx kAmp[00], kCps[00]*kRat[00],                    kFB[00]
aOp01   Pmoscilx kAmp[01], kCps[01]*kRat[01], aOp00+aOp04+aOp05, kFB[01]
aOp02   Pmoscilx kAmp[02], kCps[02]*kRat[02], aOp03+aOp06+aOp07, kFB[02]
aOp03   Pmoscilx kAmp[03], kCps[03]*kRat[03],                    kFB[03]
aOp04   Pmoscilx kAmp[04], kCps[04]*kRat[04], aOp08,             kFB[04]
aOp05   Pmoscilx kAmp[05], kCps[05]*kRat[05], aOp09,             kFB[05]
aOp06   Pmoscilx kAmp[06], kCps[06]*kRat[06], aOp10,             kFB[06]
aOp07   Pmoscilx kAmp[07], kCps[07]*kRat[07], aOp11,             kFB[07]
aOp08   Pmoscilx kAmp[08], kCps[08]*kRat[08], aOp12,             kFB[08]
aOp09   Pmoscilx kAmp[09], kCps[09]*kRat[09], aOp13,             kFB[09]
aOp10   Pmoscilx kAmp[10], kCps[10]*kRat[10], aOp14,             kFB[10]
aOp11   Pmoscilx kAmp[11], kCps[11]*kRat[11], aOp15,             kFB[11]
aOp12   Pmoscilx kAmp[12], kCps[12]*kRat[12],                    kFB[12]
aOp13   Pmoscilx kAmp[13], kCps[13]*kRat[13],                    kFB[13]
aOp14   Pmoscilx kAmp[14], kCps[14]*kRat[14],                    kFB[14]
aOp15   Pmoscilx kAmp[15], kCps[15]*kRat[15],                    kFB[15]
aSig = aOp01+aOp02
endin

