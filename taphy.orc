//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


opcode Taphy, kk[]k[], kk[]k[]k[]k[]kOOO
/*
Different rituals, but can grant you powers similar to those of the
Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]

An arbitrary length sequencer. you get 2 arrays of outputs, pitch and trigger,
each index corresponds to a step of the sequence. And you get the active step's index
The sequencer can therefor self-modulate by modifying the input arrays based on outputs

Syntax:
kActiveStep, kPitch[], kTrig[] Taphy kInTrig, kNoteIndx[], kQueue[],        \
    [kMin[], kMax[],] kFn [, kStepMode] [, kLmtMode] [, kIntrp]

Performance:
kActiveStep: The index of the currently active step [0, lenarray(kNoteIndex)[
kPitch[]: An array of the pitch outputs from each step.
        (whatever values stored in iFn)
kTrig[]: An array of trigger outputs from each step. A trigger is
        1 k-cycle long, and equals 1 (in amplitude) when that corresponding
        step is activated (0 otherwise).

kInTrig: Trigger signal that runs the sequencer.(metro, metro2, seqtime, Basemath..)
        The sequencer advances one step every k-cycle where kInTrig != 0
        (direction determined by kStepMode)
kNoteIndx[]: 1D array the length of which is the length of the sequence.
        It contains index values of the kFn for every sequence step.
        Those are not note values, they're the indexes to the values
        stored in the kFn
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

kTrig, kNoteIndx[], kQArr[], kMin[], kMax[], kFn, kStepMode, kLmtMode, kIntrp xin

ilen        =       lenarray(kNoteIndx)
kPitchArr[] init    ilen
kTrigArr[]  init    ilen

;do this only on the first k-cycle the opcode runs
kfirst  init 1
if kfirst == 1 then
    kfirst = 0
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
    kTrigArr[kAS] = 1 ;output step trigger
    ;output step pitch
    ; limit mode
    if kLmtMode == 1 then
        if kIntrp == 1 then
            kPitchArr[kAS] = tableikt(limit(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(limit(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn,0,4)
        else
            kPitchArr[kAS] = tablekt(limit(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn)
        endif
    ; mirror mode
    elseif kLmtMode == 2 then
        if kIntrp == 1 then
            kPitchArr[kAS] = tableikt(mirror(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(mirror(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn,0,4)
        else
            kPitchArr[kAS] = tablekt(mirror(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn)
        endif
    ; wrap mode (default)
    else
        if kIntrp == 1 then
            kPitchArr[kAS] = tableikt(wrap(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn,0,0,1)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(wrap(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn,0,4,0,0,1)
        else
            kPitchArr[kAS] = tablekt(wrap(kNoteIndx[kAS],kMin[kAS],kMax[kAS]),kFn,0,0,1)
        endif
    endif
endif

xout kAS, kPitchArr, kTrigArr
endop
;overloads ;this can be made more effecient (full definition)
opcode Taphy, kk[]k[], kk[]k[]kOOO ;no range arrays. global index range = [0, ftlen(i(kFn))[
kTrig, kNoteIndx[], kQArr[], kFn, kStepMode, kLmtMode, kIntrp xin
ilen = lenarray(kNoteIndx)
kMin[] init ilen
kMax[] init ilen
kMin = 0
kMax = ftlen(i(kFn))
kAS,kP[],kT[] Taphy kTrig,kNoteIndx,kQArr,kMin,kMax,kFn,kStepMode,kLmtMode,kIntrp
xout kAS, kP, kT
endop

