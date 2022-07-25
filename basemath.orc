//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


opcode Basemath, kk[]k[], kk[]k[]k[]k[]k[]k[]k[]k[]OOO
/*
Sister of Taphath. She modulates time and subdivisions instead of pitch/value.
Inspired by the seqtime opcode, the Laundry Soup sequencer by computerscare,
and, of course, the Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
Aria [https://aria.dog/modules/]
computerscare [https://github.com/freddyz]

Syntax:
kActiveStep, kTrigArr[], kDivArr[] Basemath kTimeUnit, kLength[], kLenGain[],   \
    kMinLen[], kMaxLen[], kDivision[], kDivGain[], kMaxDiv[], kQArr[]           \
    [, kStepMode] [, kReset] [, kLmtMode]

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
kQArr[]: The queue inputs for each step. Queued steps take priority over other
    steps. This won't be modified by the sequencer but can be from within the
    calling instrument after invoking the sequencer. Example:
    kQueueArr[kActiveStep] = kQueueArr[kActiveStep]*kToggle
    kToggle = 0 for reset, and kToggle = 1 for keep.
    Positive values add the corresponding steps to queue, non-positive remove them.
kStepMode: Direction in which the sequencer will move.
    0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
kReset: Reset sequencer to its original (kLength and kDivision) state when non zero.
    (defaults to 0)
kLmtMode: How to behave around the boundaries. (0=wrap (default), 1=limit, 2=mirror)
        (other values are treated as 0)

Note: All input arrays can be modified mid-performance and the sequencer will
    react accordingly. Just don't change the length of the arrays please!
Note: I guess you can think of kLength as frequency dividers, and kDivision
    as frequency multipliers? (frequency being 1/kTimeUnit Hz)
*/

kTimeUnit, kLength[], kLenGain[], kMinLen[], kMaxLen[], kDivision[], kDivGain[], kMaxDiv[], kQArr[], kStepMode, kReset, kLmtMode xin

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
if kfirst == 1 then
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
    ; limit mode
    if kLmtMode == 1 then
        knewlen[kAS] = limit(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
        knewdiv[kAS] = limit(knewdiv[kAS], 0, kMaxDiv[kAS])
    ; mirror mode
    elseif kLmtMode == 2 then
        knewlen[kAS] = mirror(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
        knewdiv[kAS] = mirror(knewdiv[kAS], 0, kMaxDiv[kAS])
    ; wrap mode
    else
        knewlen[kAS] = wrap(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
        knewdiv[kAS] = wrap(knewdiv[kAS], 0, kMaxDiv[kAS])
    endif
endif

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
    ; limit mode
    if kLmtMode == 1 then
        knewlen[kAS] = limit(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
        knewdiv[kAS] = limit(knewdiv[kAS], 0, kMaxDiv[kAS])
    ; mirror mode
    elseif kLmtMode == 2 then
        knewlen[kAS] = mirror(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
        knewdiv[kAS] = mirror(knewdiv[kAS], 0, kMaxDiv[kAS])
    ; wrap mode
    else
        knewlen[kAS] = wrap(knewlen[kAS], kMinLen[kAS], kMaxLen[kAS])
        knewdiv[kAS] = wrap(knewdiv[kAS], 0, kMaxDiv[kAS])
    endif
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
if kfirst == 1 then
    kfirst = 0
    ;initialize active step
    if kStepMode == 0 then
        kAS = wrap(iInitStep-1, 0, ilen)%ilen
    else
        kAS = wrap(iInitStep, 0, ilen)
    endif
endif

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

