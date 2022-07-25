//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


opcode Taphath, kk[]k[]k[], kk[]k[]k[]k[]k[]kOOOO
/*
Different rituals, but can grant you powers similar to those of the
Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]

Syntax:
kActiveStep, kPitch[], kTrig[] [, kIndex[]] Taphath kInTrig, kNoteIndx[],     \
    kNdxGain[], kQueue[], [kMin[], kMax[],] kFn [, kStepMode]                 \
    [, kReset] [, kLmtMode] [, kIntrp]

Performance:
kActiveStep: The index of the currently active step [0, lenarray(kNoteIndex)[
kPitch[]: An array of the pitch outputs from each step.
        (whatever values stored in iFn)
kTrig[]: An array of trigger outputs from each step. A trigger is
        1 k-cycle long, and equals 1 (in amplitude) when that corresponding
        step is activated (0 otherwise).
kIndex[]: The transposed index of each step. can be left out

kInTrig: Trigger signal that runs the sequencer.(metro, metro2, seqtime, Basemath..)
        The sequencer advances one step every k-cycle where kInTrig != 0
        (direction determined by kStepMode)
kNoteIndx[]: 1D array the length of which is the length of the sequence.
        It contains index values of the kFn for every sequence
        step before the sequencer starts to self-modulate.
        Those are not note values, they're the indexes to the values
        stored in the kFn
kNdxGain[]: Each time the corresponding step is active, add the this value
        to the note index. (first sequence cycle is no exception)
        2 for exmple means that every time the step is active, it'll be transposed 2
        scale degrees higher. (from c to d ... if kFn contains a chromatic c scale)
        Increments can be negative or fractional values. But since those are
        indexes we're dealing with, the jump will only happen when the increments
        add up to an integer.
        (this should be same length as kNoteIndex, to avoid out-of-range indexing)
kQueue[]: The queue inputs for each step. Queued steps take priority over
        other steps. This won't be modified by the sequencer but can be
        from within the calling instrument after invoking the sequencer. Example:
        kQueueArr[kActiveStep] = kQueueArr[kActiveStep]*kToggle
        kToggle = 0 for reset, and kToggle = 1 for keep.
        Positive values add corresponding steps to queue, non-positive remove them.
kMin[], kMax[]: Minimum and maximum indexes along the function table for each step
        (for selecting the range of each step) (can be ommited for full ft)
kFn: Function table containing pitch information (using gen51 for example)
        Can be i-time function table. but in the case of k-time the input tables
        should all have the same length. (unless managing the range manually with
        arrays)
kStepMode: How the sequencer will behave upon receiving a trigger.
        0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
kReset: Reset the sequencer to its original (kNoteIndex) state when non zero.
        (defaults to 0)
kLmtMode: How to behave around the boundaries of the function table.
        (0=wrap (default), 1=limit, 2=mirror) (other values are treated as 0)
        note: when given kFn and no range arrays, mirror mode will work according
        to the length of the init value of kFn
kIntrp: Interpolation mode for fractional indexes (0=raw index, 1=linear, 2=cubic)
        (other values will be treated as 0) (defauts to 0)

Note: The GEN51 plays a big role in this opcode's operation.
        It acts as a pitch quantizer and a pitch range limiter.
        Might wanna check out its documentation.
*/

kTrig, kNoteIndx[], kNdxGain[], kQArr[], kMin[], kMax[], kFn, kStepMode, kReset, kLmtMode, kIntrp xin

ilen        =       lenarray(kNoteIndx)
kmem[]      init    ilen ;storing the initial notes state
ksum[]      init    ilen ;for accumulating the gain
knewindex[] init    ilen ;sum of note indexes and gain
kPitchArr[] init    ilen
kTrigArr[]  init    ilen

;do this only on the first k-cycle the opcode runs
kfirst  init 1
if kfirst == 1 then
    kfirst = 0
    ;store initial notes
    kmem = kNoteIndx
    ;initial active step
    if kStepMode == 0 then
        kAS = (ilen-1)%ilen
    else
        kAS = 0
    endif
    ;initialize the pitch array
    kn = 0
    while kn < ilen do
        ; limit mode
        if kLmtMode == 1 then
            if kIntrp == 1 then
                kPitchArr[kn] = tableikt(limit(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn)
            elseif kIntrp == 2 then
                kPitchArr[kn] = tablexkt(limit(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn,0,4)
            else
                kPitchArr[kn] = tablekt(limit(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn)
            endif
        ; mirror mode
        elseif kLmtMode == 2 then
            if kIntrp == 1 then
                kPitchArr[kn] = tableikt(mirror(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn)
            elseif kIntrp == 2 then
                kPitchArr[kn] = tablexkt(mirror(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn,0,4)
            else
                kPitchArr[kn] = tablekt(mirror(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn)
            endif
        ; wrap mode (defaut)
        else
            if kIntrp == 1 then
                kPitchArr[kn] = tableikt(wrap(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn,0,0,1)
            elseif kIntrp == 2 then
                kPitchArr[kn] = tablexkt(wrap(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn,0,4,0,0,1)
            else
                kPitchArr[kn] = tablekt(wrap(kNoteIndx[kn],kMin[kn],kMax[kn]),kFn,0,0,1)
            endif
        endif
        kn += 1
    od
endif

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
                kAS = wrap(kAS-1, 0, ilen) ;wrap is easier than dealing with neg %
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
    ksum[kAS] = ksum[kAS]+kNdxGain[kAS] ;accumulate the increments
    knewindex[kAS] = kNoteIndx[kAS]+ksum[kAS] ;add increments and index values
    kTrigArr[kAS] = 1 ;current step's trigger output
    ;output transposed index's value
    ; limit mode
    if kLmtMode == 1 then
        if kIntrp == 1 then
            kPitchArr[kAS] = tableikt(limit(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(limit(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn,0,4)
        else
            kPitchArr[kAS] = tablekt(limit(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn)
        endif
    ; mirror mode
    elseif kLmtMode == 2 then
        if kIntrp == 1 then
            kPitchArr[kAS] = tableikt(mirror(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(mirror(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn,0,4)
        else
            kPitchArr[kAS] = tablekt(mirror(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn)
        endif
    ; wrap mode (default)
    else
        if kIntrp == 1 then
            kPitchArr[kAS] = tableikt(wrap(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn,0,0,1)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(wrap(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn,0,4,0,0,1)
        else
            kPitchArr[kAS] = tablekt(wrap(knewindex[kAS],kMin[kAS],kMax[kAS]),kFn,0,0,1)
        endif
    endif
endif

if kReset != 0 then
    knewindex = kmem ;revert to initial state
    ksum = 0 ;clear accumulated increments
endif

xout kAS, kPitchArr, kTrigArr, knewindex
endop
;overloads
opcode Taphath, kk[]k[]k[], kk[]k[]k[]kOOOO ;no range arrays [0, ftlen(i(kFn))[
kTrig, kNoteIndx[], kNdxGain[], kQArr[], kFn, kStepMode, kReset, kLmtMode, kIntrp xin
ilen = lenarray(kNoteIndx)
kMin[] init ilen
kMax[] init ilen
kMin = 0
kMax = ftlen(i(kFn))
kAS, kP[], kT[], kN[] Taphath kTrig, kNoteIndx, kNdxGain, kQArr, kMin, kMax, kFn, kStepMode, kReset, kLmtMode, kIntrp
xout kAS, kP, kT, kN
endop
opcode Taphath, kk[]k[], kk[]k[]k[]k[]k[]kOOOO ;no index out
kTrig, kNoteIndx[], kNdxGain[], kQArr[], kMin[], kMax[], kFn, kStepMode, kReset, kLmtMode, kIntrp xin
kAS, kP[], kT[], kN[] Taphath kTrig, kNoteIndx, kNdxGain, kQArr, kMin, kMax, kFn, kStepMode, kReset, kLmtMode, kIntrp
xout kAS, kP, kT
endop
opcode Taphath, kk[]k[], kk[]k[]k[]kOOOO ;no range arrays or index out
kTrig, kNoteIndx[], kNdxGain[], kQArr[], kFn, kStepMode, kReset, kLmtMode, kIntrp xin
kAS, kP[], kT[], kN[] Taphath kTrig, kNoteIndx, kNdxGain, kQArr, kFn, kStepMode, kReset, kLmtMode, kIntrp
xout kAS, kP, kT
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
if kfirst == 1 then
    kfirst = 0
    ;initial active step
    if kStepMode == 0 then
        kAS = wrap(iInitStep-1, 0, ilen)%ilen ;Amy, listen! It's important! Leave it!
    else
        kAS = wrap(iInitStep, 0, ilen)
    endif
    ;initialize the pitch array
    kn = 0
    while kn < ilen do
        kPitchArr[kn] = table(kNoteIndx[kn], iFn, 0, 0, 1)
        kn += 1
    od
endif

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

