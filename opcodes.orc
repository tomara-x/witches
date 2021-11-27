/*
trans rights
*/

/*
Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
*/

opcode Taphath, kk[]k[], kk[]k[]ioOO
/*
Different rituals, but can grant you powers similar to those of the
Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]

syntax:
kPitch, kTrigArr[], kPitchArr[] Taphath kTrig, kNoteIndx[], \
    kIncrements[], iFn [, iInitStep] [, kReset] [, kRandomMode]

initialization:
iFn: Function table containing pitch information, or whatever
        (using gen51 for example)
iInitStep: First active step in the sequence (defaults to 0)

performance:
kPitch: Pitch information returned by currently active step.
        This will be the same format as in the input iFn. (cps, pch, ...)
kTrigArr[]: An array of triggers with each index corresponding to
        a step in the sequence. It contains a k-cycle-long trigger
        that equals 1 when that corresponding step is activated (0 otherwise).
kPitchArr[]: An array of the pitch information of all the steps.
kTrig: Trigger signal that runs the sequencer.(metro, metro2, seqtime, Basemath...)
        The sequencer advances one step every k-cycle where kTrig != 0
kNoteIndx[]: 1D array the length of which is the length of the sequence.
        It contains index values of the iFn for every sequence
        step before the sequencer starts to self-modulate.
        (ie the base index of a gen51)
kIncrements[]: 1D array (same length as kNoteIndx.. or not?)
        containing the amount for each step to be transposed
        every time it is active. 2 means every time the step
        is active, it will be 2 scale degrees higher.
        (from c to d ... if iFn contains a chromatic c scale)
        Increments can be negative or fractional values.
kReset: Reset the sequencer to its original state when non zero.
        kNoteIndx[] and iInitStep wise. (defaults to 0)
kRandomMode: Advance the sequence in random order when non zero.
        (defaults to 0)
*/
kTrig, kNoteIndx[], kIncrements[], iFn, iInitStep, kReset, kRandMode xin

ilen        =       lenarray(kNoteIndx)
kmem[]      init    ilen ;storing the initial notes state
ktmp[]      init    ilen ;for accumulating the increments
ksum[]      init    ilen ;sum of notes and increments
kPitchArr[] init    ilen
kTrigArr[]  init    ilen
kAS         init    iInitStep%ilen ;active step

kgoto perf
kmem = kNoteIndx

perf:
kTrigArr    =   0
ksum = kNoteIndx+ktmp

if kTrig != 0 then
    ktmp[kAS] = ktmp[kAS]+kIncrements[kAS]
    kTrigArr[kAS] = 1

    ;update pitch output array
    kj = 0
    while kj < ilen do
        kPitchArr[kj] = table(ksum[kAS], iFn, 0, 0, 1)
        kj += 1
    od
    kpitch = kPitchArr[kAS]

    if kRandMode == 0 then
        kAS = (kAS+1)%ilen
    else
        kAS = trandom(kTrig, 0, ilen)
    endif
endif

if kReset != 0 then
    ksum    =   kmem
    kAS     =   iInitStep%ilen
endif

xout kpitch, kTrigArr, kPitchArr
endop

opcode Basemath, kkk[], kk[]k[]k[]k[]k[]k[]k[]
/*
Sister of Taphath. She modulates time and subdivisions instead of pitch/value.
Inspired by the seqtime opcode, the Laundry Soup sequencer by computerscare,
and, of course, the Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
computerscare [https://github.com/freddyz]
Aria [https://aria.dog/modules/]

Syntax:
kTrigOut, kSubTrig, kTrigAtt[] Basemath kTimeUnit, kTimes[], kIncrements[], \
    kDivs[], kDivIncs[], kMaxDivs[], kMinLen[], kMaxLen[]

Performance:
kTrigOut: Step trigger output.
kSubTrig: Dividied step trigger output
kTrigArr: Trigger array with each index corresponding to a sequencer step.
    (will output only the step trigger without the subdivisions)

kTimeUnit: Time unit (in seconds/fractions of second) for all the time arrays.
    Also, see seqtime manual entry.
kTimes[]: An array defining the length of each step (in kTimeUnit).
    The length of this array controls the length of the sequence.
    A value of zero (or negative) will have the length of 1 k-cycle.
    (can be modified from calling instrument for live performance)
kIncrements[]: An array (same length as kTimes) containing the values
    (in TimeUnit) to be added to the length of each step each time
    that step is activated. (can be negative or fractional)
kDivs[]: An array defining how many divisions are in a corresponding step.
    0 or 1 is just natural trigger at the beginning, 2 gives you a trigger
    at the beginning and a trigger in the middle, and so on.
    Like a multiplied clock. (can be modified from calling instrument)
    (0 and 1 will be treated equally, but have different effects with increments)
kDivIncs[]: Amounts to increase each step's divisions every time
    it's activated. (this to kDivs is just like kIncrements is to kTimes)
kMaxDivs[]: Maximum number of subdivisions in a step before wraping around (modulo).
    (up to, but not including)
kMinLen[], kMaxLen[]: Minimum and maximum length of step (in TimeUnit)
    (From and including kMinLen, up to, but not including, kMaxLen)
*/

kTimeUnit, kTimes[], kIncrements[], kDivs[], kDivIncs[], kMaxDivs[], kMinLen[], kMaxLen[] xin

ilen            =       lenarray(kTimes)
kAS             init    0   ;active step

ktimetmp[]      init    ilen ;accumulating the time increments in this
kdivstmp[]      init    ilen ;same but divs increments
ktimesum[]      init    ilen ;sum of accumulated increments and kTimes array
kdivsum[]       init    ilen ;sum of accimulated div incs and kDivs
kTrigArr[]      init    ilen

kgoto perf
ktimetmp        =       kIncrements
kdivstmp        =       kDivIncs

perf:
ktimesum[kAS]   =       ktimetmp[kAS]+kTimes[kAS]
kdivsum[kAS]    =       kdivstmp[kAS]+kDivs[kAS]

kTrigArr        =       0

ktimesum[kAS]   =       wrap(ktimesum[kAS], kMinLen[kAS], kMaxLen[kAS])
kdivsum[kAS]    =       wrap(kdivsum[kAS], 0, kMaxDivs[kAS])
kfreq           =       1/kTimeUnit

if ktimesum[kAS] > 0 then
    ktrig       metro   (kfreq/ktimesum[kAS])
    ksubdiv     metro   (kfreq/ktimesum[kAS])*(kdivsum[kAS] > 0 ? kdivsum[kAS] : 1)
else
    ktrig       =       1
endif

if ktrig != 0 then
    ktimetmp[kAS] = ktimetmp[kAS] + kIncrements[kAS]
    kdivstmp[kAS] = kdivstmp[kAS] + kDivIncs[kAS]
    kTrigArr[kAS] = 1
    kAS = (kAS+1)%ilen
endif

xout ktrig, ksubdiv, kTrigArr
endop

;phase modulation oscillator
opcode Pmoscili, a, akaj
aamp, kfreq, aphs, ifn xin
acarrier    phasor kfreq
asig        tablei acarrier+aphs, ifn, 1,0,1
xout        asig*aamp
endop

opcode ClkDiv, k, kk
/*
Clock divider. Outputs 1 on the nth time the in-signal is non-zero.
Syntax: kout ClkDiv ksig, kn
*/
ksig, kn xin
kcount init 0
kout = 0
if ksig != 0 then
    kcount += 1
endif
if kcount >= abs(kn) then
    kout = 1
    kcount = 0
endif
xout kout
endop
