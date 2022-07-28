//trans rights
//Copyright © 2022 Amy Universe
//This work is free. You can redistribute it and/or modify it under the
//terms of the Do What The Fuck You Want To Public License, Version 2,
//as published by Sam Hocevar. See the COPYING file for more details.


opcode Basma, kk[]k[], kk[]k[]k[]k[]k[]k[]OO
/*
Sister of Taphy. She modulates time and subdivisions instead of pitch/value.
Inspired by the seqtime opcode, the Laundry Soup sequencer by computerscare,
and, of course, the Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
Aria [https://aria.dog/modules/]
computerscare [https://github.com/freddyz]

Syntax:
kActiveStep, kTrigArr[], kDivArr[] Basma kTimeUnit, kLength[], kMinLen[], kMaxLen[],  \
    kDivision[], kMaxDiv[], kQArr[] [, kStepMode] [, kLmtMode]

kActiveStep, kTrigArr[], kDivArr[] Basma kTimeUnit, kLength[], kMinLen, kMaxLen,      \
    kDivision[], kMaxDiv, kQArr[] [, kStepMode] [, kLmtMode]

(any combination of min/max/maxDiv as scalar/array is allowed)

Performance:
kActiveStep: Index of the currently active step (from 0 to lenarray(kLength))
kTrigArr[]: Each step's trigger output. (without the divisions)
kDivArr[]: Each step's division triggers output

kTimeUnit: Time unit (in seconds/fractions of second) for all the time arrays.
    Also, see seqtime manual entry.
kLength[]: Length of each step in kTimeUnit (can be fractional).
    Non-positive step lengths will have the length of 1 k-cycle.
    The length of this array itself controls the length of the sequence.
kMinLen[], kMaxLen[]: Minimum and maximum length of step (in TimeUnit)
    (From and including kMinLen, up to, but not including, kMaxLen)
kMinLen, kMaxLen: Minimum and maximum length for all steps (in TimeUnit)
kDivision[]: How many divisions are in a corresponding step. (outputed at kDivArr[])
    0 or 1 is just natural trigger at the beginning, 2 outputs a trigger at the
    beginning and a trigger in the middle, and so on. Like a multiplied clock.
    Also can be thought of as tuplets. 3=triplets 5=quintuplets, etc (if step length is 1 beat)
kMaxDiv[]: Maximum number of subdivisions in a step before wraping around (modulo).
    (up to, but not including)
kMaxDiv: Maximum number of divisions for all steps
kQArr[]: The queue inputs for each step. Queued steps take priority over other
    steps. This won't be modified by the sequencer but can be from within the
    calling instrument after invoking the sequencer. Example:
    kQueueArr[kActiveStep] = kQueueArr[kActiveStep]*kToggle
    kToggle = 0 for reset, and kToggle = 1 for keep.
    Positive values add the corresponding steps to queue, non-positive remove them.
kStepMode: Direction in which the sequencer will move.
    0 = forward, 1 = backward, 2 = random. (halt otherwise) (defaults to 0)
kLmtMode: How to behave around the boundaries of length and divisions
    (0=wrap (default), 1=limit, 2=mirror) (other values are treated as 0)
*/

kTimeUnit, kLength[], kMinLen[], kMaxLen[], kDivision[], kMaxDiv[], kQArr[], kStepMode, kLmtMode xin

ilen = lenarray(kLength)
;output arrays
kTrigArr[] init ilen
kDivArr[]  init ilen

;first k-cycle stuff
kfirst init 1
if kfirst == 1 then
    kfirst = 0
    ;initialize active step
    if kStepMode == 0 then
        kAS = (ilen-1)%ilen
    else
        kAS = 0
    endif
endif

; limit mode
if kLmtMode == 1 then
    kLength[kAS] = limit(kLength[kAS], kMinLen[kAS], kMaxLen[kAS])
    kDivision[kAS] = limit(kDivision[kAS], 0, kMaxDiv[kAS])
; mirror mode
elseif kLmtMode == 2 then
    kLength[kAS] = mirror(kLength[kAS], kMinLen[kAS], kMaxLen[kAS])
    kDivision[kAS] = mirror(kDivision[kAS], 0, kMaxDiv[kAS])
; wrap mode
else
    kLength[kAS] = wrap(kLength[kAS], kMinLen[kAS], kMaxLen[kAS])
    kDivision[kAS] = wrap(kDivision[kAS], 0, kMaxDiv[kAS])
endif

kfreq = 1/(kTimeUnit == 0? 1 : abs(kTimeUnit))
kTrigArr = 0
kDivArr = 0
;you can use divz here
ktrig metro kfreq/(kLength[kAS] > 0? kLength[kAS] : 1)
kdiv  metro (kfreq/(kLength[kAS] > 0? kLength[kAS] : 1))*(kDivision[kAS] > 0? kDivision[kAS] : 1)

;non-positive length step (trigger new step in next k-cycle) (1 k-cycle long step)
if kLength[kAS] <= 0 then
    ktrig = 1
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

    ;trigger high
    kTrigArr[kAS] = 1
endif

if kdiv != 0 then
    ;division high
    kDivArr[kAS] = 1
endif

xout kAS, kTrigArr, kDivArr
endop

;overloads
;take min, max, and maxDiv as scalars
opcode Basma, kk[]k[], kk[]kkk[]kk[]OO
kTimeUnit, kLength[], kMinLen, kMaxLen, kDivision[], kMaxDiv, kQArr[], kStepMode, kLmtMode xin

ilen = lenarray(kLength)
kMinArr[]    init ilen
kMaxArr[]    init ilen
kMaxDivArr[] init ilen
kMinArr = kMinLen
kMaxArr = kMaxLen
kMaxDivArr = kMaxDiv

kAS,kTrig[],kDiv[] Basma kTimeUnit,kLength,kMinArr,kMaxArr,kDivision,kMaxDivArr,kQArr,kStepMode,kLmtMode

xout kAS, kTrig, kDiv
endop

;take min and max as scalars
opcode Basma, kk[]k[], kk[]kkk[]k[]k[]OO
kTimeUnit, kLength[], kMinLen, kMaxLen, kDivision[], kMaxDiv[], kQArr[], kStepMode, kLmtMode xin

ilen = lenarray(kLength)
kMinArr[]    init ilen
kMaxArr[]    init ilen
kMinArr = kMinLen
kMaxArr = kMaxLen

kAS,kTrig[],kDiv[] Basma kTimeUnit,kLength,kMinArr,kMaxArr,kDivision,kMaxDiv,kQArr,kStepMode,kLmtMode

xout kAS, kTrig, kDiv
endop

;take min and maxDiv as scalars
opcode Basma, kk[]k[], kk[]kk[]k[]kk[]OO
kTimeUnit, kLength[], kMinLen, kMaxLen[], kDivision[], kMaxDiv, kQArr[], kStepMode, kLmtMode xin

ilen = lenarray(kLength)
kMinArr[]    init ilen
kMaxDivArr[] init ilen
kMinArr = kMinLen
kMaxDivArr = kMaxDiv

kAS,kTrig[],kDiv[] Basma kTimeUnit,kLength,kMinArr,kMaxLen,kDivision,kMaxDivArr,kQArr,kStepMode,kLmtMode

xout kAS, kTrig, kDiv
endop

;take max and maxDiv as scalars
opcode Basma, kk[]k[], kk[]k[]kk[]kk[]OO
kTimeUnit, kLength[], kMinLen[], kMaxLen, kDivision[], kMaxDiv, kQArr[], kStepMode, kLmtMode xin

ilen = lenarray(kLength)
kMaxArr[]    init ilen
kMaxDivArr[] init ilen
kMaxArr = kMaxLen
kMaxDivArr = kMaxDiv

kAS,kTrig[],kDiv[] Basma kTimeUnit,kLength,kMinLen,kMaxArr,kDivision,kMaxDivArr,kQArr,kStepMode,kLmtMode

xout kAS, kTrig, kDiv
endop


;take maxDiv as scalar
opcode Basma, kk[]k[], kk[]k[]k[]k[]kk[]OO
kTimeUnit, kLength[], kMinLen[], kMaxLen[], kDivision[], kMaxDiv, kQArr[], kStepMode, kLmtMode xin

ilen = lenarray(kLength)
kMaxDivArr[] init ilen
kMaxDivArr = kMaxDiv

kAS,kTrig[],kDiv[] Basma kTimeUnit,kLength,kMinLen,kMaxLen,kDivision,kMaxDivArr,kQArr,kStepMode,kLmtMode

xout kAS, kTrig, kDiv
endop

;take min as scalar
opcode Basma, kk[]k[], kk[]kk[]k[]k[]k[]OO
kTimeUnit, kLength[], kMinLen, kMaxLen[], kDivision[], kMaxDiv[], kQArr[], kStepMode, kLmtMode xin

ilen = lenarray(kLength)
kMinArr[]    init ilen
kMinArr = kMinLen

kAS,kTrig[],kDiv[] Basma kTimeUnit,kLength,kMinArr,kMaxLen,kDivision,kMaxDiv,kQArr,kStepMode,kLmtMode

xout kAS, kTrig, kDiv
endop

;take max as scalar
opcode Basma, kk[]k[], kk[]k[]kk[]k[]k[]OO
kTimeUnit, kLength[], kMinLen[], kMaxLen, kDivision[], kMaxDiv[], kQArr[], kStepMode, kLmtMode xin

ilen = lenarray(kLength)
kMaxArr[]    init ilen
kMaxArr = kMaxLen

kAS,kTrig[],kDiv[] Basma kTimeUnit,kLength,kMinLen,kMaxArr,kDivision,kMaxDiv,kQArr,kStepMode,kLmtMode

xout kAS, kTrig, kDiv
endop
