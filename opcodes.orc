/*
trans rights
*/

/*
Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
*/


opcode Taphath, kk[]k[], kk[]k[]k[]iOO
/*
Different rituals, but can grant you powers similar to those of the
Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]

syntax:
kActiveStep, kPitchArr[], kTrigArr[] Taphath kTrig, kNoteIndx[], \
    kIncrements[], kQArr[], iFn [, kStepMode] [, kReset]

initialization:
iFn: Function table containing pitch information (using gen51 for example)
        (but doesn't have to be pitch, it can contain any values you want)

performance:
kActiveStep: The index of the currently active step (from 0 to lenarray(kNoteIndex))
kPitchArr[]: An array of the pitch outputs from each step.
        (whatever values stored in iFn)
kTrigArr[]: An array of trigger outputs from each step. A trigger is
        1 k-cycle long, and equals 1 (in amplitude) when that corresponding
        step is activated (0 otherwise).
Note: You can combine these outputs: current-pitch = kPitchArr[kActiveStep]

kTrig: Trigger signal that runs the sequencer.(metro, metro2, seqtime, Basemath...)
        The sequencer advances one step every k-cycle where kTrig != 0
        (direction determined by kStepMode)
kNoteIndx[]: 1D array the length of which is the length of the sequence.
        It contains index values of the iFn for every sequence
        step before the sequencer starts to self-modulate.
        Those are not note values, they're the indexes to the values
        stored in the iFn (the sequencer will output values in
        the function table, not these indexes)
kIncrements[]: 1D array containing the amount for each step to move up or down
        the iFn every time it is active. (first step is no exception)
        2 means every time the step is active, it will be 2 scale degrees higher.
        (from c to d ... if iFn contains a chromatic c scale)
        Increments can be negative or fractional values. But since those are
        indexes were dealing with the jump will only happen when the increments
        add up to an integer.
        (this should be same length as kNoteIndex, but if not,
        Csound will complain if it becomes a problem)
kQArr[]: The queue inputs for eaxh step. Queued steps take priority over
        other steps. This won't be modified by the sequencer but can be
        from within the calling instrument after invoking the sequencer. Example:
        kQueueArr[kActiveStep] = kQueueArr[kActiveStep]*kToggle
        kToggle = 0 for reset, and kToggle = 1 for keep.
        Positive values will add the corresponding steps to the queue,
        zero and negative will not.
kStepMode: How the sequencer will behave upon receiving a trigger.
        0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
kReset: Reset the sequencer to its original (kNoteIndex) state when non zero.
        (defaults to 0)

Note: The GEN51 plays a big role in this opcode's operation.
        It acts as a pitch quantizer and a pitch range limiter.
        Might wanna check out its documentation.
*/
kTrig, kNoteIndx[], kIncrements[], kQArr[], iFn, kStepMode, kReset xin

ilen        =       lenarray(kNoteIndx)
kmem[]      init    ilen ;storing the initial notes state
ktmp[]      init    ilen ;for accumulating the increments
ksum[]      init    ilen ;sum of notes and increments
kPitchArr[] init    ilen
kTrigArr[]  init    ilen

;do this only on the first k-cycle the opcode runs
kfirst  init 1
ckgoto kfirst!=1, PastKOne
kfirst = 0
;store initial notes
kmem = kNoteIndx
;initial active step
if kStepMode == 0 then
    kAS = ilen-1
else
    kAS = 0
endif
;initialize the pitch array
kn = 0
while kn < ilen do
    kPitchArr[kn] = table(kNoteIndx[kn], iFn, 0, 0, 1)
    kn += 1
od

PastKOne:
kTrigArr = 0 ;clear trigger outputs
if kTrig != 0 then
    ; go to the next step
    kmax maxarray kQArr
    if kmax == 0 then ; no queued steps (max=0 means entire array's non-positive)
        if kStepMode == 0 then
            kAS = (kAS+1)%ilen ;step foreward
        elseif kStepMode == 1 then
            kAS = wrap(kAS-1, 0, ilen) ;step backward
        elseif kStepMode == 2 then
            kAS = trandom(kTrig, 0, ilen) ;go to random step
        else
        endif
    else ;there are queued steps
        if kStepMode == 0 then
            kAS = (kAS+1)%ilen ;make sure to not get stuck if current step is queued
            while kQArr[kAS] <= 0 do ;go to nearest queued step forward
                kAS = (kAS+1)%ilen
            od
        elseif kStepMode == 1 then
            kAS = wrap(kAS-1, 0, ilen) ;same deal but we're moving backward
            while kQArr[kAS] <= 0 do
                kAS = wrap(kAS-1, 0, ilen) ;wrap is easier then dealing with neg %
            od
        elseif kStepMode == 2 then
            kAS = trandom(kTrig, 0, ilen) ;jump to random step..
            while kQArr[kAS] <= 0 do ; ..then go to nearest queued step foreward
                kAS = (kAS+1)%ilen
            od
        else
        endif
    endif

    ; do the step biz
    ktmp[kAS] = ktmp[kAS]+kIncrements[kAS] ;accumulate the increments
    ksum = kNoteIndx+ktmp ;add the increments and the index values
    kTrigArr[kAS] = 1 ;current step's trigger output
    kPitchArr[kAS] = table(ksum[kAS], iFn, 0, 0, 1) ;output transposed index's value
endif

if kReset != 0 then
    ksum = kmem ;revert to initial state
    ktmp = 0 ;clear accumulated increments
endif

xout kAS, kPitchArr, kTrigArr
endop


opcode uTaphath, kk[]k[], kk[]iOo
/*
Smaller Taphath. No increments, no queue, no reset.

syntax:
kActiveStep, kPitchArr[], kTrigArr[] uTaphath kTrig, kNoteIndx[], iFn \
        [, kStepMode] [, iInitStep]

initialization:
iFn: Function table containing pitch information (using gen51 for example)
        (but doesn't have to be pitch, it can contain any values you want)
iInitStep: First active step in the sequence (defaults to 0)

performance:
kActiveStep: The index of the currently active step (from 0 to lenarray(kNoteIndex))
kTrigArr[]: An array of triggers with each index corresponding to
        a step in the sequence. It contains a k-cycle-long trigger
        that equals 1 when that corresponding step is activated and 0 otherwise.
kPitchArr[]: An array of the pitch information of all the steps.
kTrig: Trigger signal that runs the sequencer.(metro, metro2, seqtime, Basemath...)
        The sequencer advances one step every k-cycle where kTrig != 0
kNoteIndx[]: 1D array the length of which is the length of the sequence.
        It contains index values of the iFn for every sequence
        step before the sequencer starts to self-modulate.
        (ie the base index of a gen51)
kStepMode: How the sequencer will behave upon receiving a trigger.
        0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
*/
kTrig, kNoteIndx[], iFn, kStepMode, iInitStep xin

ilen        =       lenarray(kNoteIndx)
kPitchArr[] init    ilen
kTrigArr[]  init    ilen

;do this only on the first k-cycle the opcode runs
kfirst  init 1
ckgoto kfirst!=1, PastKOne
kfirst = 0
;initial active step
if kStepMode == 0 then
    kAS = ilen-1
else
    kAS = 0
endif
;initialize the pitch array
kn = 0
while kn < ilen do
    kPitchArr[kn] = table(kNoteIndx[kn], iFn, 0, 0, 1)
    kn += 1
od

PastKOne:
kTrigArr    =   0
if kTrig != 0 then
    ;move to next step
    if kStepMode == 0 then
        kAS = (kAS+1)%ilen ;step foreward
    elseif kStepMode == 1 then
        kAS = wrap(kAS-1, 0, ilen) ;step backward
    elseif kStepMode == 2 then
        kAS = trandom(kTrig, 0, ilen) ;go to random step
    else
    endif

    ;do current step biz
    kTrigArr[kAS] = 1
    kPitchArr[kAS] = table(kNoteIndx[kAS], iFn, 0, 0, 1)
endif

xout kAS, kPitchArr, kTrigArr
endop


opcode Basemath, kkk[], kk[]k[]k[]k[]k[]k[]k[]
/*
Sister of Taphath. She modulates time and subdivisions instead of pitch/value.
Inspired by the seqtime opcode, the Laundry Soup sequencer by computerscare,
and, of course, the Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
computerscare [https://github.com/freddyz]
Aria [https://aria.dog/modules/]

Syntax:
kTrigOut, kSubTrig, kTrigArr[] Basemath kTimeUnit, kTimes[], kIncrements[], \
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
kAS             init    ilen-1   ;active step (this avoids skipping the first step)

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


opcode uBasemath, kk[], kk[]k[]
/*
smaller Basemath

Syntax:
kTrigOut, kTrigArr[] uBasemath kTimeUnit, kTimes[], kIncrements[], kMaxLen[]

Performance:
kTrigOut: Step trigger output.
kTrigArr: Trigger array with each index corresponding to a sequencer step.

kTimeUnit: Time unit (in seconds/fractions of second) for all the time arrays.
    Also, see seqtime manual entry.
kTimes[]: An array defining the length of each step (in kTimeUnit).
    The length of this array controls the length of the sequence.
    A value of zero (or negative) will have the length of 1 k-cycle.
    (can be modified from calling instrument for live performance)
kMaxLen[]: Minimum and maximum length of step (in TimeUnit)
    (up to but not including)
*/

kTimeUnit, kTimes[], kMaxLen[] xin

ilen            =       lenarray(kTimes)
kAS             init    ilen-1  ;active step (starting at the last step)
kTrigArr[]      init    ilen
kTrigArr        =       0

kfreq           =       1/kTimeUnit
if kTimes[kAS] > 0 then
    ktrig       metro   kfreq/abs(kTimes[kAS]%kMaxLen[kAS])
else
    ktrig       =       1
endif

if ktrig != 0 then
    kTrigArr[kAS] = 1
    kAS = (kAS+1)%ilen
endif

xout ktrig, kTrigArr
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
