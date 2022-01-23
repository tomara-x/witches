//trans rights
//Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


opcode ClkDiv, k, kk
/*
Clock divider. Outputs 1 on the nth time the in-signal is non-zero.
This opcode is quite handy with the ladies!
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


opcode ClkDivp, k, kko
/*
Clock divider with phase input.
Syntax: kout ClkDiv ksig, kn [, iphase] (0 <= iphase < kn)
*/
ksig, kn, iphs xin
kcount init iphs
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


opcode Taphath, kk[]k[], kk[]k[]k[]iOOOO
/*
Different rituals, but can grant you powers similar to those of the
Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]


Syntax:
kActiveStep, kPitchArr[], kTrigArr[] Taphath kTrig, kNoteIndx[],    \
    kNdxGain[], kQArr[], [kMin[], kMax[],] i/kFn [, kStepMode]      \
    [, kReset] [, kLmtMode] [, kIntrp]

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
kNdxGain[]: Each time the corresponding step is active, add the this value
        to the note index. (first sequence cycle is no exception)
        2 for exmple means that every time the step is active, it will be 2
        scale degrees higher. (from c to d ... if iFn contains a chromatic c scale)
        Increments can be negative or fractional values. But since those are
        indexes we're dealing with, the jump will only happen when the increments
        add up to an integer.
        (this should be same length as kNoteIndex, to avoid out-of-range indexing)
kQArr[]: The queue inputs for eaxh step. Queued steps take priority over
        other steps. This won't be modified by the sequencer but can be
        from within the calling instrument after invoking the sequencer. Example:
        kQueueArr[kActiveStep] = kQueueArr[kActiveStep]*kToggle
        kToggle = 0 for reset, and kToggle = 1 for keep.
        Positive values add corresponding steps to queue, non-positive remove them.
kMin[], kMax[]: Minimum and maximum indexes along the function table for each step
        (for selecting the range of each step) (can be ommited for full ft)
kFn: A k-rate variable holding the number to the function table, unlike using
        an iFn, this can be changed in performance time.
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
kTrig, kNoteIndx[], kNdxGain[], kQArr[], iFn, kStepMode, kReset, kLmtMode, kIntrp xin

ilen        =       lenarray(kNoteIndx)
kmem[]      init    ilen ;storing the initial notes state
ksum[]      init    ilen ;for accumulating the gain
knewindex[] init    ilen ;sum of note indexes and gain
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
            kPitchArr[kn] = tablei(kNoteIndx[kn], iFn) ;linear
        elseif kIntrp == 2 then
            kPitchArr[kn] = table3(kNoteIndx[kn], iFn) ;cubic
        else
            kPitchArr[kn] = table(kNoteIndx[kn], iFn) ;raw index (default)
        endif
    ; mirror mode
    elseif kLmtMode == 2 then
        if kIntrp == 1 then
            kPitchArr[kn] = tablei(mirror(kNoteIndx[kn], 0, ftlen(iFn)), iFn)
        elseif kIntrp == 2 then
            kPitchArr[kn] = table3(mirror(kNoteIndx[kn], 0, ftlen(iFn)), iFn)
        else
            kPitchArr[kn] = table(mirror(kNoteIndx[kn], 0, ftlen(iFn)), iFn)
        endif
    ; wrap mode (default)
    else
        if kIntrp == 1 then
            kPitchArr[kn] = tablei(kNoteIndx[kn], iFn, 0, 0, 1)
        elseif kIntrp == 2 then
            kPitchArr[kn] = table3(kNoteIndx[kn], iFn, 0, 0, 1)
        else
            kPitchArr[kn] = table(kNoteIndx[kn], iFn, 0, 0, 1)
        endif
    endif
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
            kPitchArr[kAS] = tablei(knewindex[kAS], iFn) ; linear
        elseif kIntrp == 2 then
            kPitchArr[kAS] = table3(knewindex[kAS], iFn) ; cubic
        else
            kPitchArr[kAS] = table(knewindex[kAS], iFn) ; raw index (default)
        endif
    ; mirror mode
    elseif kLmtMode == 2 then
        if kIntrp == 1 then
            kPitchArr[kAS] = tablei(mirror(knewindex[kAS], 0, ftlen(iFn)), iFn)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = table3(mirror(knewindex[kAS], 0, ftlen(iFn)), iFn)
        else
            kPitchArr[kAS] = table(mirror(knewindex[kAS], 0, ftlen(iFn)), iFn)
        endif
    ; wrap mode (default)
    else
        if kIntrp == 1 then
            kPitchArr[kAS] = tablei(knewindex[kAS], iFn, 0, 0, 1)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = table3(knewindex[kAS], iFn, 0, 0, 1)
        else
            kPitchArr[kAS] = table(knewindex[kAS], iFn, 0, 0, 1)
        endif
    endif
endif

if kReset != 0 then
    knewindex = kmem ;revert to initial state
    ksum = 0 ;clear accumulated increments
endif

xout kAS, kPitchArr, kTrigArr
endop

opcode Taphath, kk[]k[], kk[]k[]k[]k[]k[]iOOOO  ;range selection arrays overoad
kTrig, kNoteIndx[], kNdxGain[], kQArr[], kMin[], kMax[], iFn, kStepMode, kReset, kLmtMode, kIntrp xin

ilen        =       lenarray(kNoteIndx)
kmem[]      init    ilen ;storing the initial notes state
ksum[]      init    ilen ;for accumulating the gain
knewindex[] init    ilen ;sum of note indexes and gain
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
            kPitchArr[kn] = tablei(limit(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn)
        elseif kIntrp == 2 then
            kPitchArr[kn] = table3(limit(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn)
        else
            kPitchArr[kn] = table(limit(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn)
        endif
    ; mirror mode
    elseif kLmtMode == 2 then
        if kIntrp == 1 then
            kPitchArr[kn] = tablei(mirror(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn)
        elseif kIntrp == 2 then
            kPitchArr[kn] = table3(mirror(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn)
        else
            kPitchArr[kn] = table(mirror(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn)
        endif
    ; wrap mode (defaut)
    else
        if kIntrp == 1 then
            kPitchArr[kn] = tablei(wrap(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn,0,0,1)
        elseif kIntrp == 2 then
            kPitchArr[kn] = table3(wrap(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn,0,0,1)
        else
            kPitchArr[kn] = table(wrap(kNoteIndx[kn],kMin[kn],kMax[kn]),iFn,0,0,1)
        endif
    endif
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
            kPitchArr[kAS] = tablei(limit(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = table3(limit(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn)
        else
            kPitchArr[kAS] = table(limit(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn)
        endif
    ; mirror mode
    elseif kLmtMode == 2 then
        if kIntrp == 1 then
            kPitchArr[kAS] = tablei(mirror(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = table3(mirror(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn)
        else
            kPitchArr[kAS] = table(mirror(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn)
        endif
    ; wrap mode (default)
    else
        if kIntrp == 1 then
            kPitchArr[kAS] = tablei(wrap(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn,0,0,1)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = table3(wrap(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn,0,0,1)
        else
            kPitchArr[kAS] = table(wrap(knewindex[kAS],kMin[kAS],kMax[kAS]),iFn,0,0,1)
        endif
    endif
endif

if kReset != 0 then
    knewindex = kmem ;revert to initial state
    ksum = 0 ;clear accumulated increments
endif

xout kAS, kPitchArr, kTrigArr
endop

opcode Taphath, kk[]k[], kk[]k[]k[]kOOOO  ;kFt overload
kTrig, kNoteIndx[], kNdxGain[], kQArr[], kFn, kStepMode, kReset, kLmtMode, kIntrp xin

ilen        =       lenarray(kNoteIndx)
kmem[]      init    ilen ;storing the initial notes state
ksum[]      init    ilen ;for accumulating the gain
knewindex[] init    ilen ;sum of note indexes and gain
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
            kPitchArr[kn] = tableikt(kNoteIndx[kn], kFn) ;linear
        elseif kIntrp == 2 then
            kPitchArr[kn] = tablexkt(kNoteIndx[kn], kFn, 0, 4) ;cubic
        else
            kPitchArr[kn] = tablekt(kNoteIndx[kn], kFn) ;raw index (default)
        endif
    ; mirror mode
    elseif kLmtMode == 2 then
        if kIntrp == 1 then
            kPitchArr[kn] = tableikt(mirror(kNoteIndx[kn],0,ftlen(i(kFn))), kFn)
        elseif kIntrp == 2 then
            kPitchArr[kn] = tablexkt(mirror(kNoteIndx[kn],0,ftlen(i(kFn))), kFn,0,4)
        else
            kPitchArr[kn] = tablekt(mirror(kNoteIndx[kn],0,ftlen(i(kFn))), kFn)
        endif
    ; wrap mode (default)
    else
        if kIntrp == 1 then
            kPitchArr[kn] = tableikt(kNoteIndx[kn], kFn, 0, 0, 1)
        elseif kIntrp == 2 then
            kPitchArr[kn] = tablexkt(kNoteIndx[kn], kFn, 0,4, 0,0,1)
        else
            kPitchArr[kn] = tablekt(kNoteIndx[kn], kFn, 0, 0, 1)
        endif
    endif
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
            kPitchArr[kAS] = tableikt(knewindex[kAS], kFn) ; linear
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(knewindex[kAS], kFn, 0,4) ; cubic
        else
            kPitchArr[kAS] = tablekt(knewindex[kAS], kFn) ; raw index (default)
        endif
    ; mirror mode
    elseif kLmtMode == 2 then
        if kIntrp == 1 then
            kPitchArr[kAS] = tableikt(mirror(knewindex[kAS],0,ftlen(i(kFn))), kFn)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(mirror(knewindex[kAS],0,ftlen(i(kFn))), kFn, 0,4)
        else
            kPitchArr[kAS] = tablekt(mirror(knewindex[kAS],0,ftlen(i(kFn))), kFn)
        endif
    ; wrap mode (default)
    else
        if kIntrp == 1 then
            kPitchArr[kAS] = tableikt(knewindex[kAS], kFn, 0, 0, 1)
        elseif kIntrp == 2 then
            kPitchArr[kAS] = tablexkt(knewindex[kAS], kFn, 0,4, 0, 0, 1)
        else
            kPitchArr[kAS] = tablekt(knewindex[kAS], kFn, 0, 0, 1)
        endif
    endif
endif

if kReset != 0 then
    knewindex = kmem ;revert to initial state
    ksum = 0 ;clear accumulated increments
endif

xout kAS, kPitchArr, kTrigArr
endop

opcode Taphath, kk[]k[], kk[]k[]k[]k[]k[]kOOOO  ;kFt and range arrays overload
kTrig, kNoteIndx[], kNdxGain[], kQArr[], kMin[], kMax[], kFn, kStepMode, kReset, kLmtMode, kIntrp xin

ilen        =       lenarray(kNoteIndx)
kmem[]      init    ilen ;storing the initial notes state
ksum[]      init    ilen ;for accumulating the gain
knewindex[] init    ilen ;sum of note indexes and gain
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
    (should be the same length as kLength to avoid out-of-range idexing)
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
    steps. This won't be modified by the sequencer but can be from within the
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
    kAS = (ilen-1)%ilen
else
    kAS = 0
endif
;step biz
knewlen[kAS] = klengainsum[kAS]+kLength[kAS]
knewdiv[kAS] = kdivgainsum[kAS]+kDivision[kAS]
knewlen[kAS] = wrap(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
knewdiv[kAS] = wrap(knewdiv[kAS], 0, kMaxDiv[kAS])

PastKOne:
kfreq = 1/(kTimeUnit == 0? 1 : abs(kTimeUnit))
kTrigArr = 0
kDivArr = 0
ktrig metro kfreq/(knewlen[kAS] > 0? knewlen[kAS] : 1)
kdiv  metro (kfreq/(knewlen[kAS] > 0? knewlen[kAS] : 1))*(knewdiv[kAS] > 0? knewdiv[kAS] : 1)
if knewlen[kAS] <= 0 then
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
                kAS = wrap(kAS-1, 0, ilen) ;wrap is easier than dealing with neg %
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
    kAS = wrap(iInitStep-1, 0, ilen)%ilen
else
    kAS = wrap(iInitStep, 0, ilen)
endif

PastKOne:
kfreq = 1/(kTimeUnit == 0? 1 : abs(kTimeUnit))
kTrigArr = 0
ktrig metro kfreq/(kLength[kAS] > 0? kLength[kAS] : 1)
if kLength[kAS] <= 0 then
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


opcode tBasemath, kk[], kk[]k[]k[]k[]k[]OO
/*
Basemath that takes an external trigger input. (metro, metro2, etc)
Instead of the length there's a count input for how many triggers are in a step.
(Think sequential clock divider) Also there are no divisions.

Syntax:
kActiveStep, kTrigArr[] tBasemath kTrig, kCount[], kGain[], kMin[], kMax[], \
    kQArr[] [, kStepMode] [, Reset]

Performance:
kActiveStep: Index of the currently active step (from 0 to lenarray(kCount))
kTrigArr[]: Each step's trigger output.

kTrig: Input trigger that runs the sequencer. Every k-cycle when this is
    non-zero will advance the sequencer (according to count and step mode)
kCount[]: Count of how many input triggers it takes to move to next step
    (how long a step is in clicks) These sould be positive integers.
    The length of this array controls the length of the sequence.
kGain[]: Increment to be added to the counth of each step each time
    that step is activated. (can be negative or fractional)
    (should be the same length as kCount to avoid out-of-range idexing)
kMin[], kMax[]: Minimum and maximum count for each step (kMin <= count < kMax)
kQArr[]: The queue inputs for eaxh step. Queued steps take priority over other
    steps. This won't be modified by the sequencer but can be from within the
    calling instrument after invoking the sequencer. Example:
    kQueueArr[kActiveStep] = kQueueArr[kActiveStep]*kToggle
    kToggle = 0 for reset, and kToggle = 1 for keep.
    Positive values add the corresponding steps to queue, non-positive remove them.
kStepMode: Direction in which the sequencer will move.
    0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
kReset: Reset sequencer to its original (kCount) state when non-zero.(defaults to 0)
*/
kTrig, kCount[], kGain[], kMin[], kMax[], kQArr[], kStepMode, kReset xin
ilen        =       lenarray(kCount)
kgainsum[]  init    ilen ;accumulates the gain values through sequencer run time
knewcount[] init    ilen ;accumulated gains + the input kCount
kTrigArr[]  init    ilen
kcnt        init    0

;first k-cycle stuff
kfirst init 1
ckgoto kfirst!=1, PastKOne
kfirst = 0
;store initial state
kmem1[] = kCount
;pick initial step
if kStepMode == 0 then
    kAS = (ilen-1)%ilen
else
    kAS = 0
endif

PastKOne:
kTrigArr = 0
if kcnt < 1 && kTrig != 0 then
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

    ;step biz
    kgainsum[kAS] = kgainsum[kAS]+kGain[kAS]
    knewcount[kAS] = kgainsum[kAS]+kCount[kAS]
    knewcount[kAS] = wrap(knewcount[kAS], kMin[kAS], kMax[kAS])
    kTrigArr[kAS] = 1
endif

;counter
if kTrig != 0 then
    kcnt = (kcnt+1)%knewcount[kAS]
endif

if kReset != 0 then
    knewcount = kmem1
    kgainsum = 0
endif

xout kAS, kTrigArr
endop


opcode utBasemath, kk[], kk[]Oo
/*
Smaller tBasemath

Syntax:
kActiveStep, kTrigArr[] utBasemath kTrig, kCount[] [, kStepMode] [, iInitStep]

Initialization:
iInitStep: First active step in the sequence (defaults to 0)

Performance:
kActiveStep: Index of the currently active step (from 0 to lenarray(kCount))
kTrigArr[]: Each step's trigger output.

kTrig: Input trigger that runs the sequencer. Every k-cycle when this is
    non-zero will advance the sequencer (according to count and step mode)
kCount[]: Count of how many input triggers it takes to move to next step
    (how long a step is in clicks) These sould be positive integers.
    The length of this array controls the length of the sequence.
kStepMode: Direction in which the sequencer will move.
    0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
*/
kTrig, kCount[], kStepMode, iInitStep xin
ilen        =       lenarray(kCount)
kTrigArr[]  init    ilen
kcnt        init    0

;first k-cycle stuff
kfirst init 1
ckgoto kfirst!=1, PastKOne
kfirst = 0
;pick initial step
if kStepMode == 0 then
    kAS = wrap(iInitStep-1, 0, ilen)%ilen
else
    kAS = wrap(iInitStep, 0, ilen)
endif

PastKOne:
kTrigArr = 0
if kcnt < 1 && kTrig != 0 then
    ; go to the next step
    if kStepMode == 0 then
        kAS = (kAS+1)%ilen ;step foreward
    elseif kStepMode == 1 then
        kAS = wrap(kAS-1, 0, ilen) ;step backward
    elseif kStepMode == 2 then
        kAS = trandom(kTrig, 0, ilen) ;go to random step
    else
    endif

    kTrigArr[kAS] = 1
endif

;counter
if kTrig != 0 then
    kcnt = (kcnt+1)%kCount[kAS]
endif

xout kAS, kTrigArr
endop


;phase modulation oscillator
;syntax: ares Pmoscili xamp, kfreq [,aphase] [,ifn]
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

;you ever do this? add an empty line at the end so your code doesn't fall off?!

