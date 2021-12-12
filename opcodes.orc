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

Syntax:
kActiveStep, kPitchArr[], kTrigArr[] Taphath kTrig, kNoteIndx[],    \
    kIncrements[], kQArr[], iFn [, kStepMode] [, kReset]

Initialization:
iFn: Function table containing pitch information (using gen51 for example)
        (but doesn't have to be pitch, it can contain any values you want)

Performance:
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
        Positive values add corresponding steps to queue, non-positive remove them.
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

Syntax:
kActiveStep, kPitchArr[], kTrigArr[] uTaphath kTrig, kNoteIndx[], iFn   \
        [, kStepMode] [, iInitStep]

Initialization:
iFn: Function table containing pitch information (using gen51 for example)
        (but doesn't have to be pitch, it can contain any values you want)
iInitStep: First active step in the sequence (defaults to 0)

Performance:
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
    kAS = wrap(iInitStep-1, 0, ilen)
else
    kAS = wrap(iInitStep, 0, ilen)
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


opcode Basemath, kk[]k[], kk[]k[]k[]k[]k[]k[]k[]k[]OO
/*
Sister of Taphath. She modulates time and subdivisions instead of pitch/value.
Inspired by the seqtime opcode, the Laundry Soup sequencer by computerscare,
and, of course, the Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
Aria [https://aria.dog/modules/]
computerscare [https://github.com/freddyz]

Syntax:
kActiveStep, kTrigArr[], kDivArr[] Basemath kTimeUnit, kLength[], kLenGain[],   \
    kMinLen[], kMaxLen[], kDivision[], kDivGain[], kMaxDiv[], kQArr[]           \
    [, kStepMode] [, Reset]

Performance:
kActiveStep: Index of the currently active step (from 0 to lenarray(kLength))
kTrigArr[]: Each step's trigger output. (without the divisions)
kDivArr[]: Division outputs

kTimeUnit: Time unit (in seconds/fractions of second) for all the time arrays.
    Also, see seqtime manual entry.
kLength[]: Length of each step in kTimeUnit (can be fractional).
    Non-positive step lengths will have the length of 1 k-cycle.
    The length of this array itself controls the length of the sequence.
kLenGain[]: A value (in TimeUnit) to be added to the length of each step each time
    that step is activated. (can be negative or fractional)
    (should be the same length as kLength to avoid out of range idexing)
kMinLen[], kMaxLen[]: Minimum and maximum length of step (in TimeUnit)
    (From and including kMinLen, up to, but not including, kMaxLen)
kDivision[]: An array defining how many divisions are in a corresponding step.
    0 or 1 is just natural trigger at the beginning, 2 outputs a trigger at the
    beginning and a trigger in the middle, and so on. Like a multiplied clock.
    (0 and 1 will be treated equally, but have different effects with kDivGain)
kDivGain[]: Amount to increase each step's divisions every time it's activated.
    (just like kLenGain but for the divisions) (psst! fractions do fun stuff here!)
kMaxDiv[]: Maximum number of subdivisions in a step before wraping around (modulo).
    (up to, but not including)
kQArr[]: The queue inputs for eaxh step. Queued steps take priority over other
    steps. This won't be modified by the sequencer but can bebfrom within the
    calling instrument after invoking the sequencer. Example:
    kQueueArr[kActiveStep] = kQueueArr[kActiveStep]*kToggle
    kToggle = 0 for reset, and kToggle = 1 for keep.
    Positive values add the corresponding steps to queue, non-positive remove them.
kStepMode: Direction in which the sequencer will move.
    0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
kReset: Reset sequencer to its original (kLength and kDivision) state when non zero.
    (defaults to 0)

Note: All input arrays can be modified mid-performance and the sequencer will
    react accordingly. Just don't change the length of the arrays please!
Note: I guess you can think of kLength as frequency dividers, and kDivision
    as frequency multipliers? (frequency being 1/kTimeUnit Hz)
*/

kTimeUnit, kLength[], kLenGain[], kMinLen[], kMaxLen[], kDivision[], kDivGain[], kMaxDiv[], kQArr[], kStepMode, kReset xin

ilen            =       lenarray(kLength)
klengainsum[]   init    ilen ;accumulates the gain values through sequencer run time
knewlen[]       init    ilen ;accumulated gains + the input kLength
kdivgainsum[]   init    ilen ;same as the two above
knewdiv[]       init    ilen
;output arrays
kTrigArr[]      init    ilen
kDivArr[]       init    ilen

;first k-cycle stuff
kfirst init 1
ckgoto kfirst!=1, PastKOne
kfirst = 0
;store initial state
kmem1[] = kLength
kmem2[] = kDivision
;initialize active step
if kStepMode == 0 then
    kAS = ilen-1
else
    kAS = 0
endif
;step biz
;klengainsum[kAS] = klengainsum[kAS]+kLenGain[kAS]
;kdivgainsum[kAS] = kdivgainsum[kAS]+kDivGain[kAS]
knewlen[kAS] = klengainsum[kAS]+kLength[kAS]
knewdiv[kAS] = kdivgainsum[kAS]+kDivision[kAS]
knewlen[kAS] = wrap(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
knewdiv[kAS] = wrap(knewdiv[kAS], 0, kMaxDiv[kAS])

PastKOne:
kfreq = 1/kTimeUnit
kTrigArr = 0
kDivArr = 0
if knewlen[kAS] > 0 then
    ktrig metro (kfreq/knewlen[kAS])
    kdiv  metro (kfreq/knewlen[kAS])*(knewdiv[kAS] > 0 ? knewdiv[kAS] : 1)
else
    ktrig = 1 ;non-positive length step (trigger new step in next k-cycle)
endif

if ktrig != 0 then
    ; go to the next step
    kmax maxarray kQArr
    if kmax == 0 then ; no queued steps (max=0 means entire array's non-positive)
        if kStepMode == 0 then
            kAS = (kAS+1)%ilen ;step foreward
        elseif kStepMode == 1 then
            kAS = wrap(kAS-1, 0, ilen) ;step backward
        elseif kStepMode == 2 then
            kAS = trandom(ktrig, 0, ilen) ;go to random step
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
            kAS = trandom(ktrig, 0, ilen) ;jump to random step..
            while kQArr[kAS] <= 0 do ; ..then go to nearest queued step foreward
                kAS = (kAS+1)%ilen
            od
        else
        endif
    endif

    ;step biz
    klengainsum[kAS] = klengainsum[kAS]+kLenGain[kAS]
    kdivgainsum[kAS] = kdivgainsum[kAS]+kDivGain[kAS]
    knewlen[kAS] = klengainsum[kAS]+kLength[kAS]
    knewdiv[kAS] = kdivgainsum[kAS]+kDivision[kAS]
    knewlen[kAS] = wrap(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
    knewdiv[kAS] = wrap(knewdiv[kAS], 0, kMaxDiv[kAS])

    kTrigArr[kAS] = 1
endif

if kdiv != 0 then
    kDivArr[kAS] = 1
endif

if kReset != 0 then
    knewlen = kmem1
    knewdiv = kmem2
    klengainsum = 0
    kdivgainsum = 0
endif

xout kAS, kTrigArr, kDivArr
endop


opcode uBasemath, kk[], kk[]Oo
/*
Smaller Basemath

Syntax:
kActiveStep, kTrigArr[] uBasemath kTimeUnit, kLength[] [, kStepMode] [, iInitStep]

Initialization:
iInitStep: First active step in the sequence (defaults to 0)

Performance:
kActiveStep: Index of the currently active step (from 0 to lenarray(kLength))
kTrigArr[]: Each step's trigger output.

kTimeUnit: Time unit (in seconds/fractions of second) for all the time arrays.
    Also, see seqtime manual entry.
kLength[]: Length of each step in kTimeUnit (can be fractional).
    Non-positive step lengths will have the length of 1 k-cycle.
    The length of this array itself controls the length of the sequence.
kStepMode: Direction in which the sequencer will move.
    0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
*/

kTimeUnit, kLength[], kStepMode, iInitStep xin

ilen        =       lenarray(kLength)
kTrigArr[]  init    ilen

;first k-cycle stuff
kfirst init 1
ckgoto kfirst!=1, PastKOne
kfirst = 0
;initialize active step
if kStepMode == 0 then
    kAS = wrap(iInitStep-1, 0, ilen)
else
    kAS = wrap(iInitStep, 0, ilen)
endif

PastKOne:
kfreq = 1/kTimeUnit
kTrigArr = 0
if kLength[kAS] > 0 then
    ktrig metro (kfreq/kLength[kAS])
else
    ktrig = 1 ;non-positive length step (trigger new step in next k-cycle)
endif

if ktrig != 0 then
    ; go to the next step
    if kStepMode == 0 then
        kAS = (kAS+1)%ilen ;step foreward
    elseif kStepMode == 1 then
        kAS = wrap(kAS-1, 0, ilen) ;step backward
    elseif kStepMode == 2 then
        kAS = trandom(ktrig, 0, ilen) ;go to random step
    else
    endif

    kTrigArr[kAS] = 1
endif

xout kAS, kTrigArr
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
