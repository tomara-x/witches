//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


opcode tBasemath, kk[], kk[]k[]k[]k[]k[]OOO
/*
Basemath that takes an external trigger input. (metro, metro2, etc)
Instead of the length there's a count input for how many triggers are in a step.
(Think sequential clock divider) Also there are no divisions.

Syntax:
kActiveStep, kTrigArr[] tBasemath kTrig, kCount[], kGain[], kMin[], kMax[], kQArr[]
    [, kStepMode] [, kReset] [, kLmtMode]

kActiveStep, kTrigArr[] tBasemath kTrig, kCount[], kGain[], kMin, kMax, kQArr[]
    [, kStepMode] [, kReset] [, kLmtMode]

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
kMin, kMax: Minimum and maximum count for all steps (kMin <= count < kMax)
    (you can have min be a variable and max be an array or vice versa)
kQArr[]: The queue inputs for each step. Queued steps take priority over other
    steps. This won't be modified by the sequencer but can be from within the
    calling instrument after invoking the sequencer. Example:
    kQueueArr[kActiveStep] = kQueueArr[kActiveStep]*kToggle
    kToggle = 0 for reset, and kToggle = 1 for keep.
    Positive values add the corresponding steps to queue, non-positive remove them.
kStepMode: Direction in which the sequencer will move.
    0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
kReset: Reset sequencer to its original (kCount) state when non-zero.(defaults to 0)
kLmtMode: How to behave around the boundaries. (0=wrap (default), 1=limit, 2=mirror)
        (other values are treated as 0)
*/
kTrig, kCount[], kGain[], kMin[], kMax[], kQArr[], kStepMode, kReset, kLmtMode xin
ilen        =       lenarray(kCount)
kgainsum[]  init    ilen ;accumulates the gain values through sequencer run time
knewcount[] init    ilen ;accumulated gains + the input kCount
kTrigArr[]  init    ilen
kcnt        init    0

;first k-cycle stuff
kfirst init 1
if kfirst == 1 then
    kfirst = 0
    ;store initial state
    kmem1[] = kCount
    ;pick initial step
    if kStepMode == 0 then
        kAS = (ilen-1)%ilen
    else
        kAS = 0
    endif
endif

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
    ; limit mode
    if kLmtMode == 1 then
        knewcount[kAS] = limit(knewcount[kAS], kMin[kAS], kMax[kAS])
    ; mirror mode
    elseif kLmtMode == 2 then
        knewcount[kAS] = mirror(knewcount[kAS], kMin[kAS], kMax[kAS])
    ; wrap mode
    else
        knewcount[kAS] = wrap(knewcount[kAS], kMin[kAS], kMax[kAS])
    endif
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
;overloads
opcode tBasemath, kk[], kk[]k[]kkk[]OOO ;pass min and max as scalars
kTrig, kCount[], kGain[], kMin, kMax, kQArr[], kStepMode, kReset, kLmtMode xin
ilen = lenarray(kCount)
kMinArr[] init ilen
kMaxArr[] init ilen
kMinArr = kMin
kMaxArr = kMax
kAS,kT[] tBasemath kTrig,kCount,kGain,kMinArr,kMaxArr,kQArr,kStepMode,kReset,kLmtMode
xout kAS, kT
endop
opcode tBasemath, kk[], kk[]k[]kk[]k[]OOO ;only scaler min
kTrig, kCount[], kGain[], kMin, kMax[], kQArr[], kStepMode, kReset, kLmtMode xin
ilen = lenarray(kCount)
kMinArr[] init ilen
kMinArr = kMin
kAS,kT[] tBasemath kTrig,kCount,kGain,kMinArr,kMax,kQArr,kStepMode,kReset,kLmtMode
xout kAS, kT
endop
opcode tBasemath, kk[], kk[]k[]k[]kk[]OOO ;scaler max
kTrig, kCount[], kGain[], kMin[], kMax, kQArr[], kStepMode, kReset, kLmtMode xin
ilen = lenarray(kCount)
kMaxArr[] init ilen
kMaxArr = kMax
kAS,kT[] tBasemath kTrig,kCount,kGain,kMin,kMaxArr,kQArr,kStepMode,kReset,kLmtMode
xout kAS, kT
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
if kfirst == 1 then
    kfirst = 0
    ;pick initial step
    if kStepMode == 0 then
        kAS = wrap(iInitStep-1, 0, ilen)%ilen
    else
        kAS = wrap(iInitStep, 0, ilen)
    endif
endif

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

