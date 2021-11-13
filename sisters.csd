trans rights

/*
Copyright © 2021 Amy Universe <nopenullnilvoid00@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
*/

<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
; ==============================================
<CsInstruments>

sr		=	44100
ksmps	=	42
;kr		=	1050
nchnls	=	1
0dbfs	=	1


; ------------------------------ 
; function tables

;gifn1 gen51
iscaledegrees	= 7
itotalsize		= iscaledegrees*4
iinterval		= 2 ;ratio range covered before repeating (octave = 2)
ibasefreq		= cpspch(6) ;cpspch(8) = c4
ibaseindex		= 0 ;index 0 will be ibasefreq
gifn1 ftgen 0,0,-itotalsize,-51, iscaledegrees,iinterval,
ibasefreq,ibaseindex,
2^(0/12),
2^(2/12),
2^(3/12),
2^(6/12),
2^(7/12),
2^(9/12),
2^(10/12)
; ratios (the numirators are the scale notes 0=c ... 11=b)
; (this is c dorian #4 (ukrainian dorian) in 12-tet)

gifn2 ftgen 0,0,-8,-2, 2,2,1,2,1,2,3,3 ;delta times (16 steps)

;natural minor
gifn3 ftgen 0,0,-7*4,-51, 7,2,cpspch(6),0,
2^(0/12),
2^(2/12),
2^(3/12),
2^(5/12),
2^(7/12),
2^(8/12),
2^(10/12)
; ------------------------------ 


; ------------------------------
; user defined opcodes

opcode Taphath, kk[]k[], kk[]k[]ioOO
/*
Different rituals, but can grant you powers similar to those of the
Modulus Salomonis Regis sequencers by Aria Salvatrice. <3
[https://aria.dog/modules/]

syntax:
kPitch, kTrigArr[], kPitchArr[] Taphath kTrig, kNoteIndx[],
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

ilen		=		lenarray(kNoteIndx)
kmem[]		init	ilen ;storing the initial notes state
ktmp[]		init	ilen ;for accumulating the increments
ksum[]		init	ilen ;sum of notes and increments
kPitchArr[]	init	ilen
kTrigArr[]	init	ilen
kAS			init	iInitStep%ilen ;active step

kgoto perf
kmem = kNoteIndx

perf:
kTrigArr	=	0
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
	ksum	=	kmem
	kAS		=	iInitStep%ilen
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
kTrigOut, kSubTrig, kTrigAtt[] Basemath kTimeUnit, kTimes[], kIncrements[],
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

ilen			=		lenarray(kTimes)
kAS				init	0	;active step

ktimetmp[]		init	ilen ;accumulating the time increments in this
kdivstmp[]		init	ilen ;same but divs increments
ktimesum[]		init	ilen ;sum of accumulated increments and kTimes array
kdivsum[]		init	ilen ;sum of accimulated div incs and kDivs
kTrigArr[]		init	ilen

kgoto perf
ktimetmp		=		kIncrements
kdivstmp		=		kDivIncs

perf:
ktimesum[kAS]	=		ktimetmp[kAS]+kTimes[kAS]
kdivsum[kAS]	=		kdivstmp[kAS]+kDivs[kAS]

kTrigArr		=		0

ktimesum[kAS]	=		wrap(ktimesum[kAS], kMinLen[kAS], kMaxLen[kAS])
kdivsum[kAS]	=		wrap(kdivsum[kAS], 0, kMaxDivs[kAS])
kfreq			=		1/kTimeUnit

if ktimesum[kAS] > 0 then
	ktrig		metro	(kfreq/ktimesum[kAS])
	ksubdiv		metro	(kfreq/ktimesum[kAS])*(kdivsum[kAS] > 0 ? kdivsum[kAS] : 1)
else
	ktrig		=		1
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
acarrier	phasor kfreq
asig		tablei acarrier+aphs, ifn, 1,0,1
xout		asig*aamp
endop
; ------------------------------


; ------------------------------
; instruments

instr 1
ktmpo		init	137 ;bpm
kclkx1		metro	ktmpo/60 ;whole notes
kclkx4		metro	4*ktmpo/60 ;quarter notes
kclkd4		metro	ktmpo/60/4 ;4 whole notes
kclkd8		metro	ktmpo/60/8 ;8 whole notes
kclkd16		metro	ktmpo/60/16 ;16 whole notes
ktrigseq1	seqtime	1/(4*ktmpo/60), 0, 8, 0, gifn2

knotes[]	fillarray	0,0,0,0,0,0,0,0
kincs[]		fillarray	0,-1,2,0,1,0,-3,1

;kreset = kclkd8  ;reset must be 1-k-cycle-long trigger

;if kclkx1 > 0 then ;randomly increment a random step increment!
;	krandstep	trandom	kclkx1, 0, lenarray(kincs)
;	krandval	=		int(trandom(kclkx1,-5,5))
;	kincs[krandstep] = kincs[krandstep] + krandval
;endif

; run the sequencer
kpitch,kotrig[],kopitch[] Taphath kclkx1,knotes,kincs,gifn1,0,0,0

;self-patching trig-outs to noteIndex or to incs
;if kotrig[5] == 1 then
;	knotes[1] = knotes[1]-5 ;can access values of other steps this way.
;							;totally not because the += form doesn't work on arrays!
;	kincs[0] = kincs[0] + 1 ;if you want increasing inrements!
;endif

; make some noise
kpres	randi		2, 8, 0.5, 0, 3 ;amp, cps, seed, bit, offset
krat	randi		0.25, 2, 0.5, 0, 0.01
asig	wgbow		0.4, kpitch, 3, 0.13, 5, 0.004
		out			asig
; run another instrument with the same pitch info
		schedkwhen	kclkx1, 0, 0, 2, 0, 0.4, kpitch/2
endin

instr 2
iz		init		0.001
aenv1	expseg		2,0.2,iz
aenv2	expseg		2,0.4,iz
aenv3	expsegr		1,0.9,iz,0.6,iz
aenv4	expsegr		1,0.5,iz,0.5,iz
amod1	oscili		aenv1, p4/2
amod2	oscili		aenv2, p4
acar1	Pmoscili	aenv3, p4*2, amod1+amod2
acar2	Pmoscili 	aenv4, p4, amod1+amod2
asig	bqrez		acar1+acar2, p4*4, 1
asig	limit		asig, -0.25, 0.25
		out			asig
endin

instr 4
ktempo		=	137 ;bpm
ktimeunit	=	1/(ktempo/60) ;1 whole note at tempo in seconds

ktimes[]	fillarray	4,    4,    4,    4,    4,    4,    4,    4
kincs[]		fillarray	0,    0,    0,    0,    0,    0,    0,    0
kminlen[]	fillarray	1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64, 1/64
kmaxlen[]	fillarray	4,    4,    4,    4,    4,    4,    4,    4

kdivs[]		fillarray	0,    0,    0,    0,    0,    0,    0,    0
kdivincs[]	fillarray	0,    0,    0,    0,    0,    0,    0,    0
kmaxdivs[]	fillarray	256,  256,  256,  256,  256,  256,  256,  256

ktrig, ksub, ktrigArr[] Basemath ktimeunit, ktimes, kincs, kdivs, kdivincs,
		kmaxdivs, kminlen, kmaxlen

schedkwhen	ksub, 0, 0, 5, 0, 0.0001
endin

instr 5 ;hat
aenv	expsegr	1,p3,1,0.04,0.001
asig	noise	0.1*aenv, 0
out		asig
endin

instr 6
ktempo		=	137 ;bpm
ktimeunit	=	1/(ktempo/60) ;1 whole note at ktempo (in seconds)

kTimes[]	fillarray	1,    1,    1,    1,    1,    1,    1,    1
kTimeIncs[]	fillarray	0,    0,    0,    1,    0,    0,    0,    0
kDivs[]		fillarray	0,    0,    0,    4,    0,    0,    0,    0
kDivIncs[]	fillarray	0,    0,    0,    0,    0,    0,    0,    0

kMaxDivs[]	fillarray	16,   16,   16,   8,    8,    8,    8,    8
kMinLen[]	fillarray	0,    0,    0,    1,    0,    0,    0,    0
kMaxLen[]	fillarray	4,    4,    4,    4,    4,    4,    4,    4

ktrig,ksub,kbasemathtrigs[] Basemath ktimeunit,kTimes,kTimeIncs,kDivs,kDivIncs,
		kMaxDivs,kMinLen,kMaxLen

kNotes[]	fillarray	0,    2,    0,    6,    2,    3,    0,    1
kNoteIncs[]	fillarray	1,    2,    0,    0,   -4,    0,    0,    3

kpitch,ktaphtrigs[],ktaphpitches[] Taphath ktrig,kNotes,kNoteIncs,gifn3

kenv	looptseg	ktempo/8/60, ksub, 0, 1,-40,1, 0,0,0
asig	oscili		kenv, kpitch*4
		out			limit(asig, -0.2,0.2)
endin

instr 7
ktempo		=	137
ktimeunit	=	1/(ktempo/60)

ktimes[]	genarray
kTimeIncs[]	genarray
kDivs[]		genarray
kDivIncs[]	genarray

kMaxDivs[]	init
kMinLen[]	init
kMaxLen[]	init

ktrig,ksub,kbasemathtrigs[] Basemath ktimeunit,kTimes,kTimeIncs,kDivs,kDivIncs,
		kMaxDivs,kMinLen,kMaxLen

kNotes[]	fillarray
kNoteIncs[]	fillarray

kpitch,ktaphtrigs[],ktaphpitches[] Taphath ktrig,kNotes,kNoteIncs,gifn3

kenv	looptseg	ktempo/8/60, ksub, 0, 1,-40,1, 0,0,0
asig	oscili		kenv, kpitch*4
		out			limit(asig, -0.2,0.2)
endin

; ------------------------------

</CsInstruments>
; ==============================================
<CsScore>
t		0		137	;score tempo 137bpm
;i1		0		128	;activate instrument 1 for 128 beats
;i4		0		64
;i6		0		64
i7		0		64
e
</CsScore>
</CsoundSynthesizer>


